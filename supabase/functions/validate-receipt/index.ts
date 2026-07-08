// HueTone Receipt Validation Edge Function
// Deploy: supabase functions deploy validate-receipt
// Set secrets:
//   supabase secrets set APP_STORE_SHARED_SECRET=your_secret
//   supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_key (set automatically in Supabase cloud)

import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

interface ReceiptPayload {
  receiptData: string;
  userId: string;
  productId: string;
}

interface AppleResponse {
  status: number;
  receipt: {
    in_app: Array<{
      transaction_id: string;
      product_id: string;
      expires_date_ms?: string;
      purchase_date_ms: string;
    }>;
  };
  latest_receipt_info?: Array<{
    transaction_id: string;
    product_id: string;
    expires_date_ms: string;
    purchase_date_ms: string;
  }>;
}

const APP_STORE_PRODUCTION = "https://buy.itunes.apple.com/verifyReceipt";
const APP_STORE_SANDBOX = "https://sandbox.itunes.apple.com/verifyReceipt";

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const { receiptData, userId, productId }: ReceiptPayload = await req.json();
    if (!receiptData || !userId || !productId) {
      return new Response(
        JSON.stringify({ valid: false, error: "Missing required fields" }),
        { status: 400, headers: { "Content-Type": "application/json" } },
      );
    }

    const sharedSecret = Deno.env.get("APP_STORE_SHARED_SECRET") ?? "";

    // Try production first
    let appleData = await verifyWithApple(APP_STORE_PRODUCTION, receiptData, sharedSecret);

    // 21007 = sandbox receipt sent to production → retry with sandbox
    if (appleData.status === 21007) {
      appleData = await verifyWithApple(APP_STORE_SANDBOX, receiptData, sharedSecret);
    }

    if (appleData.status !== 0) {
      return new Response(
        JSON.stringify({ valid: false, error: `Apple returned status ${appleData.status}` }),
        { status: 400, headers: { "Content-Type": "application/json" } },
      );
    }

    return await processReceipt(appleData, userId, productId);
  } catch (err) {
    return new Response(
      JSON.stringify({ valid: false, error: err instanceof Error ? err.message : "Unknown error" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});

async function verifyWithApple(url: string, receiptData: string, password: string): Promise<AppleResponse> {
  const resp = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      "receipt-data": receiptData,
      password,
      "exclude-old-transactions": true,
    }),
  });
  return resp.json();
}

async function processReceipt(appleData: AppleResponse, userId: string, productId: string): Promise<Response> {
  const receiptInfo = appleData.latest_receipt_info?.[0] ?? appleData.receipt.in_app[0];
  if (!receiptInfo) {
    return new Response(
      JSON.stringify({ valid: false, error: "No in-app purchase found in receipt" }),
      { status: 400, headers: { "Content-Type": "application/json" } },
    );
  }

  const expiresAt = receiptInfo.expires_date_ms
    ? new Date(parseInt(receiptInfo.expires_date_ms))
    : new Date(Date.now() + 365 * 24 * 60 * 60 * 1000); // 1 year fallback for non-renewing

  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const supabase = createClient(supabaseUrl, supabaseKey);

  // Upsert subscription record
  const { error: subError } = await supabase.from("subscriptions").upsert(
    {
      user_id: userId,
      product_id: productId,
      original_transaction_id: receiptInfo.transaction_id,
      expires_at: expiresAt.toISOString(),
      is_active: expiresAt > new Date(),
    },
    { onConflict: "original_transaction_id" },
  );

  if (subError) {
    return new Response(
      JSON.stringify({ valid: false, error: subError.message }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  // Update profile to premium
  const { error: profileError } = await supabase
    .from("profiles")
    .update({ subscription_tier: "premium" })
    .eq("id", userId);

  if (profileError) {
    return new Response(
      JSON.stringify({ valid: false, error: profileError.message }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  return new Response(
    JSON.stringify({ valid: true, expires_at: expiresAt.toISOString() }),
    { headers: { "Content-Type": "application/json" } },
  );
}

#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════════
# HueTone — Full Supabase Backend Setup
# ═══════════════════════════════════════════════════════════════
# Prerequisites:
#   1. node + npm (for Supabase CLI)
#   2. Xcode 15+ 
#   3. An Apple Developer account (for Sign in with Apple + IAP)
#   4. A Supabase account (free tier at supabase.com)
#
# Run: bash scripts/setup.sh
# ═══════════════════════════════════════════════════════════════

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { printf "${CYAN}[INFO]${NC}  %s\n" "$*"; }
ok()    { printf "${GREEN}[OK]${NC}    %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${NC}  %s\n" "$*"; }
fail()  { printf "${RED}[FAIL]${NC}  %s\n" "$*"; exit 1; }

# ── 1. Check prerequisites ────────────────────────────────────

info "Checking prerequisites..."

SUPABASE_BIN=""
for cmd in supabase npx; do
  if command -v $cmd &>/dev/null; then
    SUPABASE_BIN="$cmd"
    break
  fi
done

if [ -z "$SUPABASE_BIN" ]; then
  fail "Supabase CLI not found. Install it:\n  brew install supabase/tap/supabase\n  # or\n  npm install -g supabase"
fi

SUPABASE_VERSION=$(supabase --version 2>/dev/null || echo "0.0.0")
info "Supabase CLI v$SUPABASE_VERSION found"

if ! command -v node &>/dev/null; then
  fail "Node.js is required for Edge Function deployment"
fi
info "Node.js $(node --version) found"

ok "Prerequisites met"

# ── 2. Link to Supabase project ───────────────────────────────

if [ ! -f "supabase/config.toml" ]; then
  fail "Run this script from the project root (where supabase/ lives)"
fi

PROJECT_ID=$(grep '^project_id' supabase/config.toml | head -1 | cut -d'"' -f2)
info "Project ID: $PROJECT_ID"

# Check if already linked
if supabase status &>/dev/null 2>&1; then
  ok "Already linked to a Supabase project"
else
  echo ""
  warn "You need to create a Supabase project first."
  echo "  1. Go to https://supabase.com/dashboard/projects"
  echo "  2. Click 'New project'"
  echo "  3. Note your project reference (the subdomain like 'abcdeftgihxyz')"
  echo "  4. Get your anon key from Project Settings → API"
  echo ""
  read -rp "Enter your Supabase project reference: " SUPABASE_REF
  read -rp "Enter your Supabase anon key: " SUPABASE_ANON_KEY

  supabase link --project-ref "$SUPABASE_REF" || fail "Failed to link project. Check your project reference."

  # Store anon key for local dev
  echo "$SUPABASE_ANON_KEY" > .supabase_anon_key
  ok "Linked to project $SUPABASE_REF"
fi

# ── 3. Push database schema ───────────────────────────────────

info "Pushing database schema to Supabase..."
supabase db push || fail "Database migration failed. Fix the SQL in supabase/migrations/ and retry."
ok "Schema deployed"

# ── 4. Deploy Edge Function ───────────────────────────────────

info "Deploying receipt validation Edge Function..."
supabase functions deploy validate-receipt || warn "Edge Function deployment failed. You can deploy later with: supabase functions deploy validate-receipt"
ok "Edge Function deployed"

# ── 5. Configure Apple Sign-In ────────────────────────────────

echo ""
warn "Apple Sign-In setup required in Supabase Dashboard:"
echo "  1. Go to https://supabase.com/dashboard/project/$PROJECT_ID/auth/providers"
echo "  2. Enable 'Apple' provider"
echo "  3. Enter your Service ID (e.g. com.huetone.app)"
echo "  4. Download the Apple private key from Apple Developer portal"
echo "  5. Paste the private key into the 'Apple Secret' field"
echo "  6. Set 'Apple Key ID' and 'Apple Team ID' from your Apple Developer account"
echo ""

# ── 6. Set secrets ────────────────────────────────────────────

echo ""
read -rp "Enter your App Store Shared Secret (from App Store Connect): " APP_STORE_SECRET
if [ -n "$APP_STORE_SECRET" ]; then
  supabase secrets set APP_STORE_SHARED_SECRET="$APP_STORE_SECRET" || warn "Failed to set secret"
fi

# ── 7. Update iOS Info.plist ──────────────────────────────────

if [ -n "${SUPABASE_ANON_KEY:-}" ]; then
  info "Updating Info.plist with Supabase configuration..."

  SUPABASE_URL="https://$SUPABASE_REF.supabase.co"

  # Use plistbuddy if available
  if command -v /usr/libexec/PlistBuddy &>/dev/null; then
    PLIST="HueTone/Resources/Info.plist"
    /usr/libexec/PlistBuddy -c "Set :SUPABASE_URL $SUPABASE_URL" "$PLIST" 2>/dev/null || \
      /usr/libexec/PlistBuddy -c "Add :SUPABASE_URL string $SUPABASE_URL" "$PLIST"
    /usr/libexec/PlistBuddy -c "Set :SUPABASE_ANON_KEY $SUPABASE_ANON_KEY" "$PLIST" 2>/dev/null || \
      /usr/libexec/PlistBuddy -c "Add :SUPABASE_ANON_KEY string $SUPABASE_ANON_KEY" "$PLIST"
    ok "Info.plist updated"
  else
    warn "Cannot update Info.plist automatically. Update SUPABASE_URL and SUPABASE_ANON_KEY manually in HueTone/Resources/Info.plist"
  fi
fi

# ── 8. Verify build ───────────────────────────────────────────

echo ""
read -rp "Run a build test now? (y/n): " BUILD_NOW
if [ "$BUILD_NOW" = "y" ] || [ "$BUILD_NOW" = "Y" ]; then
  info "Building project..."
  SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}" SUPABASE_URL="${SUPABASE_URL:-}" \
    xcodebuild -project HueTone.xcodeproj -scheme HueTone -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 17' build 2>&1 | grep -E "BUILD|error:" || true
fi

# ── 9. Summary ────────────────────────────────────────────────

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  HueTone Backend Setup Complete"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "  Supabase Project:  $SUPABASE_REF"
echo "  Supabase URL:      https://$SUPABASE_REF.supabase.co"
echo ""
echo "  Next steps in Xcode:"
echo "  1. File → Add Package Dependencies"
echo "     → https://github.com/supabase-community/supabase-swift.git"
echo "     → Add to HueTone target"
echo ""
echo "  2. Open HueTone/Resources/Info.plist"
echo "     → Verify SUPABASE_URL and SUPABASE_ANON_KEY are set"
echo ""
echo "  3. Build and run on a simulator/device"
echo ""
echo "  4. For production release:"
echo "     - Configure Apple Sign-In in Supabase Dashboard"
echo "     - Set up App Store Connect In-App Purchases"
echo "     - Run: supabase functions deploy validate-receipt"
echo "     - Create Config.local.xcconfig from Config.xcconfig template"
echo ""
echo "═══════════════════════════════════════════════════════"

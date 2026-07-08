import Foundation

class StorageService {
    static let shared = StorageService()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func save<T: Encodable>(_ value: T, for key: String) {
        let url = documentsURL.appendingPathComponent("\(key).json")
        if let data = try? encoder.encode(value) {
            try? data.write(to: url)
        }
    }

    func load<T: Decodable>(_ type: T.Type, for key: String) -> T? {
        let url = documentsURL.appendingPathComponent("\(key).json")
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? decoder.decode(type, from: data)
    }

    func delete(for key: String) {
        let url = documentsURL.appendingPathComponent("\(key).json")
        try? FileManager.default.removeItem(at: url)
    }
}

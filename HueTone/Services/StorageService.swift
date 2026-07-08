import Foundation

enum StorageError: LocalizedError {
    case documentsDirectoryUnavailable
    case encodingFailed(Error)
    case writeFailed(Error)
    case fileNotFound(String)
    case readFailed(Error)
    case decodingFailed(Error)
    case deleteFailed(Error)

    var errorDescription: String? {
        switch self {
        case .documentsDirectoryUnavailable: return "Documents directory not available"
        case .encodingFailed(let error): return "Encoding failed: \(error.localizedDescription)"
        case .writeFailed(let error): return "Write failed: \(error.localizedDescription)"
        case .fileNotFound(let key): return "File not found for key: \(key)"
        case .readFailed(let error): return "Read failed: \(error.localizedDescription)"
        case .decodingFailed(let error): return "Decoding failed: \(error.localizedDescription)"
        case .deleteFailed(let error): return "Delete failed: \(error.localizedDescription)"
        }
    }
}

class StorageService {
    static let shared = StorageService()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private var documentsURL: URL {
        get throws {
            guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                throw StorageError.documentsDirectoryUnavailable
            }
            return url
        }
    }

    func save<T: Encodable>(_ value: T, for key: String) throws {
        let url = try documentsURL.appendingPathComponent("\(key).json")
        do {
            let data = try encoder.encode(value)
            try data.write(to: url)
        } catch let error as EncodingError {
            throw StorageError.encodingFailed(error)
        } catch {
            throw StorageError.writeFailed(error)
        }
    }

    func load<T: Decodable>(_ type: T.Type, for key: String) throws -> T {
        let url = try documentsURL.appendingPathComponent("\(key).json")
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw StorageError.fileNotFound(key)
        }
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(type, from: data)
        } catch let error as DecodingError {
            throw StorageError.decodingFailed(error)
        } catch {
            throw StorageError.readFailed(error)
        }
    }

    func delete(for key: String) throws {
        let url = try documentsURL.appendingPathComponent("\(key).json")
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            throw StorageError.deleteFailed(error)
        }
    }
}

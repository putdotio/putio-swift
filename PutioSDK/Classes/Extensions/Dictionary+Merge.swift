import Foundation

extension Dictionary {
    func merge(with source: [Key: Value]) -> Dictionary {
        var result: [Key: Value] = [:]

        for (key, value) in self {
            result[key] = value
        }

        for (key, value) in source {
            result[key] = value
        }

        return result
    }
}

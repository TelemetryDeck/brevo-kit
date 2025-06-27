import Foundation

public enum BrevoError: Error {
    case badRequest
    case unknownResponse
    case notFound
}

public extension DecodingError {
    static func failedToDecodeOneOfSchema(
        type: Any.Type,
        codingPath: [any CodingKey],
        errors: [any Error]
    ) -> Self {
        DecodingError.valueNotFound(
            type,
            DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "The oneOf structure did not decode into any child schema.",
                underlyingError: MultiError(errors: errors)
            )
        )
    }
}

/// A wrapper of multiple errors, for example collected during a parallelized
/// operation from the individual subtasks.
struct MultiError: Swift.Error, LocalizedError, CustomStringConvertible {
    /// The multiple underlying errors.
    var errors: [any Error]

    var description: String {
        let combinedDescription =
            errors.map { error in
                guard let error = error as? (any PrettyStringConvertible) else { return "\(error)" }
                return error.prettyDescription
            }
            .enumerated().map { ($0.offset + 1, $0.element) }.map { "Error \($0.0): [\($0.1)]" }.joined(separator: ", ")
        return "MultiError (contains \(errors.count) error\(errors.count == 1 ? "" : "s")): \(combinedDescription)"
    }

    var errorDescription: String? {
        if let first = errors.first {
            return "Mutliple errors encountered, first one: \(first.localizedDescription)."
        } else {
            return "No errors"
        }
    }
}

protocol PrettyStringConvertible {
    /// A pretty string description.
    var prettyDescription: String { get }
}

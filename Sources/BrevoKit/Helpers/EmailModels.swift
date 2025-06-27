
public struct SenderEmail {
    public let email: String
    public let name: String?
    public let id: Int64?

    public init(email: String, name: String? = nil, id: Int64? = nil) {
        self.email = email
        self.name = name
        self.id = id
    }

    var toSenderPayload: Components.Schemas.SendSmtpEmail.SenderPayload {
        Components.Schemas.SendSmtpEmail.SenderPayload(
            name: name, email: email,
            id: id
        )
    }
}

public struct RecipientEmail {
    public let email: String
    public let name: String?

    public init(email: String, name: String? = nil) {
        self.email = email
        self.name = name
    }

    var toRecipientPayload: Components.Schemas.SendSmtpEmail.ToPayloadPayload {
        Components.Schemas.SendSmtpEmail.ToPayloadPayload(
            email: email,
            name: name
        )
    }
}

public struct ReplyToEmail {
    public let email: String
    public let name: String?

    public init(email: String, name: String? = nil) {
        self.email = email
        self.name = name
    }

    var toReplyToPayload: Components.Schemas.SendSmtpEmail.ReplyToPayload {
        Components.Schemas.SendSmtpEmail.ReplyToPayload(
            email: email,
            name: name
        )
    }
}

public typealias ObjectContainer = [String: PrimitiveValue]

public enum PrimitiveValue: Codable, Hashable, Sendable {
    case double(Double)
    case string(String)
    case bool(Bool)
    case int(Int)
    case stringArray([String])

    public init(from decoder: Decoder) throws {
        var errors: [any Error] = []

        do {
            self = try .double(decoder.decodeFromSingleValueContainer())
            return
        } catch {
            errors.append(error)
        }

        do {
            self = try .string(decoder.decodeFromSingleValueContainer())
            return
        } catch {
            errors.append(error)
        }

        do {
            self = try .bool(decoder.decodeFromSingleValueContainer())
            return
        } catch {
            errors.append(error)
        }

        do {
            self = try .int(decoder.decodeFromSingleValueContainer())
            return
        } catch {
            errors.append(error)
        }

        do {
            self = try .stringArray(decoder.decodeFromSingleValueContainer())
            return
        } catch {
            errors.append(error)
        }

        throw Swift.DecodingError.failedToDecodeOneOfSchema(
            type: Self.self,
            codingPath: decoder.codingPath,
            errors: errors
        )
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .double(let value):
            try encoder.encodeToSingleValueContainer(value)
        case .string(let value):
            try encoder.encodeToSingleValueContainer(value)
        case .bool(let value):
            try encoder.encodeToSingleValueContainer(value)
        case .int(let value):
            try encoder.encodeToSingleValueContainer(value)
        case .stringArray(let value):
            try encoder.encodeToSingleValueContainer(value)
        }
    }
}

public extension Decoder {
    /// Returns the decoded value by using a single value container.
    /// - Parameter type: The type to decode.
    /// - Returns: The decoded value.
    /// - Throws: An error if there are issues with decoding the value from the single value container.
    func decodeFromSingleValueContainer<T: Decodable>(_ type: T.Type = T.self) throws -> T {
        let container = try singleValueContainer()
        return try container.decode(T.self)
    }
}

extension Encoder {
    /// Encodes the value into the encoder using a single value container.
    /// - Parameter value: The value to encode.
    /// - Throws: An error if there are issues with encoding the value.
    func encodeToSingleValueContainer<T: Encodable>(_ value: T) throws {
        var container = singleValueContainer()
        try container.encode(value)
    }
}

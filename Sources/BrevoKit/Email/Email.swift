import Foundation
import OpenAPIRuntime

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

public struct Email {
    private let brevo: Brevo

    init(brevo: Brevo) {
        self.brevo = brevo
    }

    public func send(
        from sender: SenderEmail? = nil,
        to recipients: [RecipientEmail],
        replyTo: ReplyToEmail? = nil,
        subject: String? = nil,
        htmlContent: String? = nil,
        textContent: String? = nil,
        templateID: Int64? = nil,
        parameters: [String: String]? = nil,
        tags: [String]? = nil,
        scheduledAt: Date? = nil,
        batchID: String? = nil
    ) async throws {
        var params: [String: OpenAPIRuntime.OpenAPIValueContainer] = [:]
        for (parameter, value) in parameters ?? [:] {
            params[parameter] = .init(stringLiteral: value)
        }

        let response = try await brevo.client.sendTransacEmail(
            Operations.SendTransacEmail.Input(
                body: Operations.SendTransacEmail.Input.Body.json(
                    Components.Schemas.SendSmtpEmail(
                        sender: sender?.toSenderPayload,
                        to: recipients.map { $0.toRecipientPayload },
                        htmlContent: htmlContent,
                        textContent: textContent,
                        subject: subject,
                        replyTo: replyTo?.toReplyToPayload,
                        templateId: templateID,
                        params: parameters != nil ? Components.Schemas.SendSmtpEmail.ParamsPayload(additionalProperties: params) : nil,
                        tags: tags,
                        scheduledAt: scheduledAt,
                        batchId: batchID
                    )
                )
            )
        )

        switch response {
        case .created(let created):
            print(created)
        case .accepted(let accepted):
            print(accepted)
        case .badRequest(let badRequest):
            print(badRequest)
        case .undocumented(let statusCode, let undocumentedPayload):
            print("Undocumented response with status code \(statusCode): \(undocumentedPayload)")
            print(undocumentedPayload.body)
        }
    }
}

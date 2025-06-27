import Foundation
import OpenAPIRuntime


public struct Email {
    private let brevo: Brevo

    init(brevo: Brevo) {
        self.brevo = brevo
    }

    /// Send a transactional email
    ///
    /// - Parameters:
    ///   - sender: Mandatory if templateId is not passed. Pass name (optional) and email or id of sender from which emails will be sent. name will be ignored if passed along with sender id.
    ///   - recipients: Mandatory if messageVersions are not passed, ignored if messageVersions are passed. List of email addresses and names (optional) of the recipients
    ///   - replyTo: Email (required), along with name (optional), on which transactional mail recipients will be able to reply back. F
    ///   - subject: Subject of the message. Mandatory if 'templateId' is not passed
    ///   - htmlContent: HTML body of the message. Mandatory if 'templateId' is not passed, ignored if 'templateId' is passed
    ///   - textContent: Plain Text body of the message. Ignored if 'templateId' is passed
    ///   - templateID: Id of the template.
    ///   - parameters: Pass the set of attributes to customize the template
    ///   - tags: Tag your emails to find them more easily
    ///   - scheduledAt: UTC date-time on which the email has to schedule (YYYY-MM-DDTHH:mm:ss.SSSZ). Prefer to pass your timezone in date-time format for scheduling. There can be an expected delay
    ///                  of +5 minutes in scheduled email delivery.
    ///   - batchID: Valid UUIDv4 batch id to identify the scheduled batches transactional email. If not passed we will create a valid UUIDv4 batch id at our end.
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
        case .badRequest(let badRequest):
            brevo.logger.error("Bad request: \(badRequest)")
            throw BrevoError.badRequest
        case .undocumented(let statusCode, let undocumentedPayload):
            brevo.logger.error("Undocumented response with status code \(statusCode): \(undocumentedPayload)")
            throw BrevoError.unknownResponse
        default:
            return
        }
    }
}

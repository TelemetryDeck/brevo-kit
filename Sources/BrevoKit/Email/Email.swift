public struct Email {
    private let brevo: Brevo

    init(brevo: Brevo) {
        self.brevo = brevo
    }

    public func send(
        fromName: String? = nil,
        fromEmail: String,
        toEmail: String,
        toName: String,
        subject: String,
        htmlContent: String? = nil,
        textContent: String,
        replyToEmail: String? = nil,
        replyToName: String? = nil,
        templateId: Int64? = nil
    ) async throws {
        let response = try await brevo.client.sendTransacEmail(
            Operations.SendTransacEmail.Input(
                body: Operations.SendTransacEmail.Input.Body.json(
                    Components.Schemas.SendSmtpEmail(
                        sender: Components.Schemas.SendSmtpEmail.SenderPayload(
                            name: fromName,
                            email: fromEmail
                        ),
                        to: [Components.Schemas.SendSmtpEmail.ToPayloadPayload(
                            email: toEmail,
                            name: toName
                        )],
                        htmlContent: htmlContent,
                        textContent: textContent,
                        subject: subject,
                        replyTo: replyToEmail != nil ? Components.Schemas.SendSmtpEmail.ReplyToPayload(
                            email: replyToEmail ?? "",
                            name: replyToName
                        ) : nil,
                        templateId: templateId
//                        params: Components.Schemas.SendSmtpEmail.ParamsPayload? = nil,
//                        messageVersions: Components.Schemas.SendSmtpEmail.MessageVersionsPayload? = nil,
//                        tags: [Swift.String]? = nil,
//                        scheduledAt: Foundation.Date? = nil,
//                        batchId: Swift.String? = nil
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

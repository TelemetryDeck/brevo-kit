import Foundation
import OpenAPIURLSession

func test() async throws {
    let client = try Client(serverURL: Servers.Server1.url(), transport: URLSessionTransport())
    let response = try await client.getProcess(.init(path: .init(processId: 39)))
}

public struct BrevoClient {
    let client: Client

    public init(apiKey: String, sandbox: Bool = false) throws {
        self.client = try Client(
            serverURL: Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: apiKey, sandBox: sandbox)]
        )
    }

    public func email(
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
        let response = try await client.sendTransacEmail(
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

    public func createContact(
        email: String,
        externalID: String? = nil,
        attributes: [String: String]? = nil,
        listIDs: [Int64]? = nil,
        updateEnabled: Bool = false
    ) async throws {
        try await client.createContact(
            Operations.CreateContact.Input.init(
                body: Operations.CreateContact.Input.Body.json(
                    Components.Schemas.CreateContact.init(
                        email: email,
                        extId: externalID,
                        attributes: nil, // TODO
                        emailBlacklisted: nil,
                        smsBlacklisted: nil,
                        listIds: listIDs,
                        updateEnabled: updateEnabled,
                        smtpBlacklistSender: nil
                    )
                )
            )
        )
    }

}

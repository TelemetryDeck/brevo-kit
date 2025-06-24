import Foundation
import OpenAPIURLSession

func test() async throws {
    let client = try Client(serverURL: Servers.Server1.url(), transport: URLSessionTransport())
    let response = try await client.getProcess(.init(path: .init(processId: 39)))
}

public struct Brevo {
    public var email: Email {
        Email(brevo: self)
    }

    public var contacts: Contacts {
        Contacts(brevo: self)
    }

    internal let client: Client

    public init(apiKey: String, sandbox: Bool = false) throws {
        self.client = try Client(
            serverURL: Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: apiKey, sandBox: sandbox)]
        )
    }
}

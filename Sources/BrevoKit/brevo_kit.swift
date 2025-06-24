import Foundation
import OpenAPIURLSession
import Logging

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

    public var events: Events {
        Events(brevo: self)
    }

    let client: Client
    let logger = Logger(label: "com.telemetrydeck.brevo-kit")

    public init(apiKey: String, sandbox: Bool = false) throws {
        self.client = try Client(
            serverURL: Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: apiKey, sandBox: sandbox)]
        )
    }
}

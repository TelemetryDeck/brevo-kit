import Foundation
import Logging
import OpenAPIURLSession

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

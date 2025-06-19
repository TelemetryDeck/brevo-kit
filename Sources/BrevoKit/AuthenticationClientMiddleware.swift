import Foundation
import HTTPTypes
import OpenAPIRuntime

/// A client middleware that injects a value into the `Authorization` header field of the request.
package struct AuthenticationMiddleware {
    /// The value for the `Authorization` header field.
    private let value: String
    private let sandbox: Bool

    /// Creates a new middleware.
    /// - Parameter value: The value for the `Authorization` header field.
    package init(authorizationHeaderFieldValue value: String, sandBox: Bool = false) {
        self.value = value
        self.sandbox = sandBox
    }
}

extension AuthenticationMiddleware: ClientMiddleware {
    package func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        // Adds the `Authorization` header field with the provided value.
        request.headerFields[.init("api-key") ?? .authorization] = value

        if sandbox {
            request.headerFields[.init("X-Sib-Sandbox") ?? .authorization] = "drop"
        }

        return try await next(request, body, baseURL)
    }
}

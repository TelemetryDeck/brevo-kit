import Foundation
import OpenAPIURLSession

func test() async throws {
    let client = try Client(serverURL: Servers.Server1.url(), transport: URLSessionTransport())
    let response = try await client.getProcess(.init(path: .init(processId: 39)))
}

//@main struct HelloWorldURLSessionClient {
//    static func main() async throws {
//        let args = CommandLine.arguments
//        guard args.count == 2 else {
//            print("Requires a token")
//            exit(1)
//        }
//        let client = Client(
//            serverURL: URL(string: "http://localhost:8080/api")!,
//            transport: URLSessionTransport(),
//            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: args[1])]
//        )
//        let response = try await client.getProcess(.init(path: .init(processId: 39)))
////        switch response {
////        case .ok(let okResponse): try print(okResponse.body.json.message)
////        case .unauthorized: print("Unauthorized")
////        case .undocumented(statusCode: let statusCode, _): print("Undocumented status code: \(statusCode)")
////        }
//    }
//}

public struct BrevoClient {
    let client: Client

    init(apiKey: String) throws {
        self.client = try Client(
            serverURL: Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: apiKey)]
        )
    }
}

# brevo-kit
Swift Vapor SDK for Brevo

Generated from the [Brevo API OpenAPI specification](https://api.brevo.com/v3/swagger_definition_v3.yml) 
using [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator).

See the [Brevo API docs](https://developers.brevo.com/docs/getting-started) for more information on how to use the API.

## Installation

Add the package dependency in your `Package.swift`:

```swift
.package(url: "https://github.com/telemetryDeck/brevo-kit", from: "1.0.0"),
```

Next, in your target, add `BrevoKit` to your dependencies:

```swift
.target(name: "MyTarget", dependencies: [
    .product(name: "BrevoKit", package: "brevo-kit"),
]),
```

## Setup

Get an API key from your Brevo account here: https://app.brevo.com/settings/keys/api

Init with API Key: 

```swift
let brevo: Brevo = try Brevo(apiKey: "xkeysib-...", sandbox: false)
```

TODO: Setup with Vapor. 

## Usage

Send an email with defined content: 

```swift
try await brevo.email.send(
    from: .init(email: "root@eruditorium.org", name: "Enoch Root"),
    to: [.init(email: "hello@example.com")],
    subject: "Hello World",
    htmlContent: nil,
    textContent: "Hello World!"
)
```

Send an email with a template:

```swift
try await brevo.email.send(
    to: [.init(email: "hello@example.com")],
    templateID: 1,
    parameters: ["name": "Daniel"],
    tags: ["test", "brevo-kit"]
)
```

## Development

To update the generated code from the OpenAPI specification, you can use the generate-code-from-openapi plugin 
provided by Apple. Download a new version of the 
[Brevo API OpenAPI specification](https://api.brevo.com/v3/swagger_definition_v3.yml), place it into `openapi.yml`, 
and run the following command:

```
swift package plugin generate-code-from-openapi --target BrevoKit
```


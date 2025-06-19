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


## Development

```
swift package plugin generate-code-from-openapi --target BrevoKit
```


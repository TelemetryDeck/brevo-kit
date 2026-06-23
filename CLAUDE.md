# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`brevo-kit` is a Swift package (`BrevoKit`) that wraps the [Brevo](https://developers.brevo.com/docs/getting-started) transactional email/marketing API. The bulk of the code is **generated** from Brevo's OpenAPI spec via [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator); the hand-written code is a thin, ergonomic facade over that generated client.

## Commands

```sh
swift build
swift test                                  # runs the swift-testing suite in Tests/
swift test --filter <TestName>              # run a single test
swiftlint                                   # lint (config in .swiftlint.yml; GeneratedSources is excluded)
```

Regenerate the client from the OpenAPI spec. First replace `Sources/BrevoKit/openapi.yaml` with a fresh download of the [Brevo spec](https://api.brevo.com/v3/swagger_definition_v3.yml), then **uncomment the `swift-openapi-generator` dependency in `Package.swift`** (it is commented out by default to keep it out of the normal build) and clean the build directory:

```sh
swift package plugin generate-code-from-openapi --target BrevoKit
```

CI (`.github/workflows/test.yml`) runs `swiftlint` then `swift test` on self-hosted macOS runners for PRs to `main`.

## Architecture

- **`Brevo` (`brevo_kit.swift`)** is the single public entry point. `try Brevo(apiKey:sandbox:)` builds the generated `Client` with `URLSessionTransport` and the auth middleware. It exposes feature namespaces as computed properties: `brevo.email`, `brevo.contacts`, `brevo.events`. Each namespace is a small struct holding a reference back to `Brevo` (for `client` and `logger`).

- **`AuthenticationClientMiddleware.swift`** injects the `api-key` header on every request. When `sandbox: true`, it also adds `X-Sib-Sandbox: drop` so emails are accepted but never delivered.

- **`GeneratedSources/` (Client.swift, Types.swift — ~130k lines, do not hand-edit)** contains the generated `Client`, `Operations.*`, and `Components.Schemas.*`. The generator is configured by `openapi-generator-config.yaml` (generates `types` + `client`, `namingStrategy: idiomatic`). These files are excluded from SwiftLint and from package compilation inputs (`openapi.yaml`/`openapi-generator-config.yaml` are `exclude`d in Package.swift).

- **Feature wrappers (`Email/`, `Contacts/`, `Events/`)** are the value of this package: they translate clean Swift call sites into the verbose generated request types and collapse the generated response enums into either a return value or a thrown `BrevoError`. New API surface should follow this same pattern rather than exposing generated types directly.

- **Public model types (`Models/`, `Helpers/EmailModels.swift`, `Contacts/ContactModels.swift`)** are hand-written wrappers (`SenderEmail`, `RecipientEmail`, `ReplyToEmail`, `ContactDetails`, etc.) so callers never touch the generated types. They carry a `toXPayload` computed property (outbound) and/or an `init(...: Components.Schemas...)` (inbound) to bridge across. Note the asymmetry: request bodies are built from per-operation types (`Operations.<Op>.Input.Body.JsonPayload...`), while response decoding uses the shared `Components.Schemas.*` types.

## Conventions

- **Response handling pattern:** every wrapper method `switch`es on the generated response enum, logs via `brevo.logger` and throws the matching `BrevoError` for `.badRequest` / `.undocumented` (and `.notFound` / `.methodNotAllowed` where applicable), and treats the success case via `default:` or an explicit `.ok`/`.noContent`. Match this when adding methods. `.notFound` on a getter returns `nil` rather than throwing.

- **`PrimitiveValue` (`EmailModels.swift`)** is the public, type-safe stand-in for Brevo's free-form attribute/parameter values (double/string/bool/int/stringArray), with custom `Codable` that tries each case in turn. Use it for any `[String: ...]` attribute map; wrappers convert it to the generated `AdditionalPropertiesPayload` cases.

- Brevo's API uses `blacklist` terminology; the code keeps it for API consistency and brackets those spots with `// swiftlint:disable inclusive_language`.

- Some fields are intentionally unimplemented (e.g. `contactProperties`/`eventProperties` in `Events.create`) — left as `nil` with a `// Not implemented` comment.

- Swift 6 tools version; tests use the `swift-testing` framework (`import Testing`, `@Test`), not XCTest.

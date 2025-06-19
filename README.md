# brevo-kit
Swift Vapor SDK for Brevo


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



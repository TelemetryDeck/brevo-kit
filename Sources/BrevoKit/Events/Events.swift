import Foundation

public struct Events {
    private let brevo: Brevo

    init(brevo: Brevo) {
        self.brevo = brevo
    }

    /// Create an event to track a contact's interaction.
    ///
    /// Exactly one of the identifiers must be provided to identify the contact associated with the event.
    ///
    /// - Parameters:
    ///   - eventName: The name of the event that occurred. This is how you will find your event in Brevo. Limited to 255 characters, alphanumerical characters and - _ only.
    ///   - eventDate: Timestamp of when the event occurred (e.g. "2024-01-24T17:39:57+01:00"). If no value is passed, the timestamp of the event creation is used.
    ///   - emailID: Identifies the contact by email address
    ///   - phoneID: Identifies the contact by phone number
    ///   - whatsappID: Identifies the contact by WhatsApp number
    ///   - landlineNumberID: Identifies the contact by landline number
    ///   - extID: Identifies the contact by external ID
    public func create(
        eventName: String,
        eventDate: String? = nil,
        emailID: String? = nil,
        phoneID: String? = nil,
        whatsappID: String? = nil,
        landlineNumberID: String? = nil,
        extID: String? = nil,
        // contactProperties: [String: PrimitiveValue]? = nil, // Not implemented
        // eventProperties: [String: PrimitiveValue]? = nil, // Not implemented
    ) async throws {
        var eventProperties: [String: Components.Schemas.Event.EventPropertiesPayload.AdditionalPropertiesPayload] = [:]

        let response = try await brevo.client.createEvent(
            Operations.CreateEvent.Input(
                body: Operations.CreateEvent.Input.Body.json(
                    .init(
                        eventName: eventName,
                        eventDate: eventDate,
                        identifiers: Components.Schemas.Event.IdentifiersPayload(
                            emailId: emailID,
                            phoneId: phoneID,
                            whatsappId: whatsappID,
                            landlineNumberId: landlineNumberID,
                            extId: extID
                        ),
                        contactProperties: nil, // Not implemented
                        eventProperties: nil // Not implemented
                    )
                )
            )
        )

        switch response {
        case .badRequest(let badRequest):
            brevo.logger.error("Bad request: \(badRequest)")
            throw BrevoError.badRequest
        case .undocumented(let statusCode, let undocumentedPayload):
            brevo.logger.error("Undocumented response with status code \(statusCode): \(undocumentedPayload)")
            throw BrevoError.unknownResponse
        default:
            return
        }
    }
}

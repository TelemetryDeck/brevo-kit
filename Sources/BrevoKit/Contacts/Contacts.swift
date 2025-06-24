public struct Contacts {
    private let brevo: Brevo

    init(brevo: Brevo) {
        self.brevo = brevo
    }

    public func create(
        email: String,
        externalID: String? = nil,
        attributes: [String: String]? = nil,
        listIDs: [Int64]? = nil,
        updateEnabled: Bool = false
    ) async throws {
        try await brevo.client.createContact(
            Operations.CreateContact.Input(
                body: Operations.CreateContact.Input.Body.json(
                    Components.Schemas.CreateContact(
                        email: email,
                        extId: externalID,
                        attributes: nil, // TODO:
                        emailBlacklisted: nil,
                        smsBlacklisted: nil,
                        listIds: listIDs,
                        updateEnabled: updateEnabled,
                        smtpBlacklistSender: nil
                    )
                )
            )
        )
    }
}

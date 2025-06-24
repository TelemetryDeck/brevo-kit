public struct Contacts {
    private let brevo: Brevo

    init(brevo: Brevo) {
        self.brevo = brevo
    }

    /// Creates new contacts on Brevo.
    ///
    /// Contacts can be created by passing either -
    ///
    /// 1. email address of the contact (email_id),
    /// 2. phone number of the contact (to be passed as "SMS" field in "attributes" along with proper country code), For example- {"SMS":"+91xxxxxxxxxx"} or {"SMS":"0091xxxxxxxxxx"}
    /// 3. ext_id
    ///
    /// - Parameters:
    ///   - email: Email address of the user. Mandatory if "ext_id" & "SMS" field is not passed.
    ///   - externalID: Pass your own Id to create a contact.
    ///   - attributes: Pass the set of attributes and their values. The attribute's parameter should be passed in capital letter while creating a contact. Values that don't match the attribute type
    ///                 (e.g. text or string in a date attribute) will be ignored. These attributes must be present in your Brevo account.
    ///   - emailBlacklisted: Set this field to blacklist the contact for emails
    ///   - smsBlacklisted: Set this field to blacklist the contact for SMS
    ///   - listIDs: Ids of the lists to add the contact to
    ///   - updateEnabled: Facilitate to update the existing contact in the same request
    public func create(
        email: String,
        externalID: String? = nil,
        attributes: [String: String]? = nil,
        emailBlacklisted: Bool = false,
        smsBlacklisted: Bool = false,
        listIDs: [Int64]? = nil,
        updateEnabled: Bool = false
    ) async throws {
        var attrs: [String: Components.Schemas.CreateContact.AttributesPayload.AdditionalPropertiesPayload] = [:]
        for (attr, value) in attributes ?? [:] {
            attrs[attr.uppercased()] = .case2(value)
        }

        let response = try await brevo.client.createContact(
            Operations.CreateContact.Input(
                body: Operations.CreateContact.Input.Body.json(
                    Components.Schemas.CreateContact(
                        email: email,
                        extId: externalID,
                        attributes: attributes != nil ? Components.Schemas.CreateContact.AttributesPayload(additionalProperties: attrs) : nil,
                        emailBlacklisted: emailBlacklisted,
                        smsBlacklisted: smsBlacklisted,
                        listIds: listIDs,
                        updateEnabled: updateEnabled,
                        smtpBlacklistSender: nil
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

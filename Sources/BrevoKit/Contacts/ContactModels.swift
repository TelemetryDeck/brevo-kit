// The term 'blacklist' is not inclusive, but we're keeping it for naming consistency with the Brevo API.
// swiftlint:disable inclusive_language

public struct ContactDetails: Codable {
    public init(
        email: String? = nil,
        id: Int64,
        emailBlacklisted: Bool,
        smsBlacklisted: Bool,
        createdAt: String,
        modifiedAt: String,
        listIds: [Int64],
        listUnsubscribed: [Int64]? = nil
    ) {
        self.email = email
        self.id = id
        self.emailBlacklisted = emailBlacklisted
        self.smsBlacklisted = smsBlacklisted
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.listIds = listIds
        self.listUnsubscribed = listUnsubscribed
    }

    init(contactDetails: Components.Schemas.GetContactDetails) {
        self.email = contactDetails.email
        self.id = contactDetails.id
        self.emailBlacklisted = contactDetails.emailBlacklisted
        self.smsBlacklisted = contactDetails.smsBlacklisted
        self.createdAt = contactDetails.createdAt
        self.modifiedAt = contactDetails.modifiedAt
        self.listIds = contactDetails.listIds
        self.listUnsubscribed = contactDetails.listUnsubscribed
    }

    /// Email address of the contact for which you requested the details
    public var email: Swift.String?
    /// ID of the contact for which you requested the details
    public var id: Swift.Int64
    /// Blacklist status for email campaigns (true=blacklisted, false=not blacklisted)
    public var emailBlacklisted: Swift.Bool
    /// Blacklist status for SMS campaigns (true=blacklisted, false=not blacklisted)
    public var smsBlacklisted: Swift.Bool
    /// Creation UTC date-time of the contact (YYYY-MM-DDTHH:mm:ss.SSSZ)
    public var createdAt: Swift.String
    /// Last modification UTC date-time of the contact (YYYY-MM-DDTHH:mm:ss.SSSZ)
    public var modifiedAt: Swift.String
    public var listIds: [Swift.Int64]
    public var listUnsubscribed: [Swift.Int64]?
}

// swiftlint:enable inclusive_language

public struct ContactStatistics: Codable {
    public init(
        messagesSent: [CampaignEvent],
        delivered: [CampaignEvent],
        hardBounces: [CampaignEvent],
        softBounces: [CampaignEvent],
        opened: [CampaignEvent],
        clicked: [CampaignEvent],
        unsubscriptions: [CampaignEvent],
        complaints: [CampaignEvent]
    ) {
        self.messagesSent = messagesSent
        self.delivered = delivered
        self.hardBounces = hardBounces
        self.softBounces = softBounces
        self.opened = opened
        self.clicked = clicked
        self.unsubscriptions = unsubscriptions
        self.complaints = complaints
    }

    public let messagesSent: [CampaignEvent]
    public let delivered: [CampaignEvent]
    public let hardBounces: [CampaignEvent]
    public let softBounces: [CampaignEvent]
    public let opened: [CampaignEvent]
    public let clicked: [CampaignEvent]
    public let unsubscriptions: [CampaignEvent]
    public let complaints: [CampaignEvent]
}

public struct CampaignEvent: Codable {
    public init(campaignId: Int64, eventTime: String) {
        self.campaignId = campaignId
        self.eventTime = eventTime
    }

    init(_ payload: Components.Schemas.GetExtendedContactDetails.Value2Payload.StatisticsPayload.MessagesSentPayloadPayload) {
        self.campaignId = payload.campaignId
        self.eventTime = payload.eventTime
    }

    init(_ payload: Components.Schemas.GetExtendedContactDetails.Value2Payload.StatisticsPayload.HardBouncesPayloadPayload) {
        self.campaignId = payload.campaignId
        self.eventTime = payload.eventTime
    }

    init(_ payload: Components.Schemas.GetExtendedContactDetails.Value2Payload.StatisticsPayload.SoftBouncesPayloadPayload) {
        self.campaignId = payload.campaignId
        self.eventTime = payload.eventTime
    }

    init(_ payload: Components.Schemas.GetExtendedContactDetails.Value2Payload.StatisticsPayload.ComplaintsPayloadPayload) {
        self.campaignId = payload.campaignId
        self.eventTime = payload.eventTime
    }

    init(_ payload: Components.Schemas.GetExtendedContactDetails.Value2Payload.StatisticsPayload.UnsubscriptionsPayload.UserUnsubscriptionPayloadPayload) {
        self.campaignId = payload.campaignId
        self.eventTime = payload.eventTime
    }

    init(_ payload: Components.Schemas.GetExtendedContactDetails.Value2Payload.StatisticsPayload.UnsubscriptionsPayload.AdminUnsubscriptionPayloadPayload) {
        self.campaignId = nil
        self.eventTime = payload.eventTime
    }

    init(_ payload: Components.Schemas.GetExtendedContactDetails.Value2Payload.StatisticsPayload.OpenedPayloadPayload) {
        self.campaignId = payload.campaignId
        self.eventTime = payload.eventTime
        self.count = payload.count
    }

    init(_ payload: Components.Schemas.GetExtendedContactDetails.Value2Payload.StatisticsPayload.ClickedPayloadPayload.LinksPayloadPayload) {
        self.eventTime = payload.eventTime
        self.count = payload.count
        self.url = payload.url
    }

    init(_ payload: Components.Schemas.GetExtendedContactDetails.Value2Payload.StatisticsPayload.DeliveredPayloadPayload) {
        self.eventTime = payload.eventTime
        self.campaignId = payload.campaignId
    }

    /// ID of the campaign which generated the event
    public var campaignId: Swift.Int64?
    /// UTC date-time of the event
    public var eventTime: Swift.String

    public var count: Swift.Int64?
    public var url: Swift.String?
}

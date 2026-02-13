import Foundation

public enum SafetyPlan {

    public struct Global: Codable, Hashable, Sendable {
        public var id: UUID
        public var clientCode: String?
        public var lastUpdated: Date
        public var warningSigns: [String]
        public var internalCopingStrategies: [String]
        public var socialContacts: [SocialContact]
        public var supportContacts: [SupportContact]
        public var professionalContacts: [Crisis.Contact]
        public var emergencyResources: [Crisis.Contact]
        public var environmentSafetySteps: [String]
        public var reasonsForLiving: [String]

        public init(
            id: UUID = UUID(),
            clientCode: String? = nil,
            lastUpdated: Date = Date(),
            warningSigns: [String] = [],
            internalCopingStrategies: [String] = [],
            socialContacts: [SocialContact] = [],
            supportContacts: [SupportContact] = [],
            professionalContacts: [Crisis.Contact] = [],
            emergencyResources: [Crisis.Contact] = [],
            environmentSafetySteps: [String] = [],
            reasonsForLiving: [String] = []
        ) {
            self.id = id
            self.clientCode = clientCode
            self.lastUpdated = lastUpdated
            self.warningSigns = warningSigns
            self.internalCopingStrategies = internalCopingStrategies
            self.socialContacts = socialContacts
            self.supportContacts = supportContacts
            self.professionalContacts = professionalContacts
            self.emergencyResources = emergencyResources
            self.environmentSafetySteps = environmentSafetySteps
            self.reasonsForLiving = reasonsForLiving
        }
    }

    public struct SocialContact: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var name: String
        public var phone: String?
        public var notes: String?

        public init(
            id: UUID = UUID(),
            name: String,
            phone: String? = nil,
            notes: String? = nil
        ) {
            self.id = id
            self.name = name
            self.phone = phone
            self.notes = notes
        }
    }

    public struct SupportContact: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var name: String
        public var phone: String
        public var relationship: String?

        public init(
            id: UUID = UUID(),
            name: String,
            phone: String,
            relationship: String? = nil
        ) {
            self.id = id
            self.name = name
            self.phone = phone
            self.relationship = relationship
        }
    }
}

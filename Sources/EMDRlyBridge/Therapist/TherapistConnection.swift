import Foundation

/// Therapist-client connection and sharing
public enum TherapistConnection {

    /// Client's view of their therapist
    public struct TherapistInfo: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var displayName: String // Not their real name if privacy needed
        public var isConnected: Bool
        public var connectionCode: String? // Code to connect
        public var canSendEncouragement: Bool
        public var canViewMetrics: Bool
        public var lastActive: Date?

        public init(
            id: UUID? = nil,
            displayName: String = "My Therapist",
            isConnected: Bool = false,
            connectionCode: String? = nil,
            canSendEncouragement: Bool = true,
            canViewMetrics: Bool = true,
            lastActive: Date? = nil
        ) {
            self.id = id
            self.displayName = displayName
            self.isConnected = isConnected
            self.connectionCode = connectionCode
            self.canSendEncouragement = canSendEncouragement
            self.canViewMetrics = canViewMetrics
            self.lastActive = lastActive
        }
    }

    /// What the therapist can see (anonymized metrics only)
    public struct ClientMetrics: Codable, Hashable, Sendable {
        public var clientCode: String // NOT real name
        public var sessionCount: Int
        public var lastSessionDate: Date?
        public var averagePostSessionFeeling: FeelingLevel?
        public var averageFatigueLevel: FatigueLevel?
        public var memoriesLogged: Int
        public var dreamsLogged: Int
        public var crisisEventsCount: Int
        public var checkInCompletionRate: Double // 0-1
        public var flaggedForDiscussion: [FlaggedItem]
        public var recentTrend: Trend

        public init(
            clientCode: String,
            sessionCount: Int = 0,
            lastSessionDate: Date? = nil,
            averagePostSessionFeeling: FeelingLevel? = nil,
            averageFatigueLevel: FatigueLevel? = nil,
            memoriesLogged: Int = 0,
            dreamsLogged: Int = 0,
            crisisEventsCount: Int = 0,
            checkInCompletionRate: Double = 0,
            flaggedForDiscussion: [FlaggedItem] = [],
            recentTrend: Trend = .stable
        ) {
            self.clientCode = clientCode
            self.sessionCount = sessionCount
            self.lastSessionDate = lastSessionDate
            self.averagePostSessionFeeling = averagePostSessionFeeling
            self.averageFatigueLevel = averageFatigueLevel
            self.memoriesLogged = memoriesLogged
            self.dreamsLogged = dreamsLogged
            self.crisisEventsCount = crisisEventsCount
            self.checkInCompletionRate = checkInCompletionRate
            self.flaggedForDiscussion = flaggedForDiscussion
            self.recentTrend = recentTrend
        }
    }

    /// Item flagged by client for therapist discussion
    public struct FlaggedItem: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var type: FlaggedItemType
        public var title: String // Anonymized summary
        public var dateLogged: Date
        public var clientNotes: String?
        public var therapistViewed: Bool
        public var therapistAcknowledged: Bool

        public init(
            id: UUID = UUID(),
            type: FlaggedItemType,
            title: String,
            dateLogged: Date = Date(),
            clientNotes: String? = nil,
            therapistViewed: Bool = false,
            therapistAcknowledged: Bool = false
        ) {
            self.id = id
            self.type = type
            self.title = title
            self.dateLogged = dateLogged
            self.clientNotes = clientNotes
            self.therapistViewed = therapistViewed
            self.therapistAcknowledged = therapistAcknowledged
        }
    }

    public enum FlaggedItemType: String, Codable, CaseIterable, Sendable {
        case memory = "memory"
        case dream = "dream"
        case feeling = "feeling"
        case question = "question"
        case concern = "concern"

        public var displayName: String {
            rawValue.capitalized
        }
    }

    public enum Trend: String, Codable, Sendable {
        case improving = "improving"
        case stable = "stable"
        case declining = "declining"
        case variable = "variable"

        public var displayName: String {
            rawValue.capitalized
        }
    }

    /// Encouragement from therapist
    public struct Encouragement: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var type: EncouragementType
        public var message: String?
        public var timestamp: Date
        public var seen: Bool

        public init(
            id: UUID = UUID(),
            type: EncouragementType,
            message: String? = nil,
            timestamp: Date = Date(),
            seen: Bool = false
        ) {
            self.id = id
            self.type = type
            self.message = message
            self.timestamp = timestamp
            self.seen = seen
        }
    }

    public enum EncouragementType: String, Codable, CaseIterable, Sendable {
        case hug = "hug"
        case like = "like"
        case proud = "proud"
        case thinking = "thinking"
        case support = "support"
        case custom = "custom"

        public var displayName: String {
            switch self {
            case .hug: return "Sending a hug"
            case .like: return "Liked your entry"
            case .proud: return "Proud of you"
            case .thinking: return "Thinking of you"
            case .support: return "Here for you"
            case .custom: return "Message"
            }
        }

        public var emoji: String {
            switch self {
            case .hug: return "🤗"
            case .like: return "❤️"
            case .proud: return "⭐"
            case .thinking: return "💭"
            case .support: return "🤝"
            case .custom: return "💬"
            }
        }
    }
}

/// Sharing preferences for therapist connection
public struct TherapistSharingPreferences: Codable, Hashable, Sendable {
    public var shareSessionMetrics: Bool
    public var shareMemoryCount: Bool
    public var shareDreamCount: Bool
    public var shareCrisisEvents: Bool
    public var shareFeelingTrends: Bool
    public var allowEncouragements: Bool
    public var allowTherapistContact: Bool // For crisis situations

    public init(
        shareSessionMetrics: Bool = true,
        shareMemoryCount: Bool = true,
        shareDreamCount: Bool = true,
        shareCrisisEvents: Bool = true,
        shareFeelingTrends: Bool = true,
        allowEncouragements: Bool = true,
        allowTherapistContact: Bool = true
    ) {
        self.shareSessionMetrics = shareSessionMetrics
        self.shareMemoryCount = shareMemoryCount
        self.shareDreamCount = shareDreamCount
        self.shareCrisisEvents = shareCrisisEvents
        self.shareFeelingTrends = shareFeelingTrends
        self.allowEncouragements = allowEncouragements
        self.allowTherapistContact = allowTherapistContact
    }

    public static var minimal: TherapistSharingPreferences {
        TherapistSharingPreferences(
            shareSessionMetrics: false,
            shareMemoryCount: false,
            shareDreamCount: false,
            shareCrisisEvents: true, // Always share crisis for safety
            shareFeelingTrends: false,
            allowEncouragements: true,
            allowTherapistContact: true
        )
    }

    public static var full: TherapistSharingPreferences {
        TherapistSharingPreferences()
    }
}

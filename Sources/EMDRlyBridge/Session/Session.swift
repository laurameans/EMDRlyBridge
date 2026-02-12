import Foundation

/// Represents a therapy session and its metadata
public enum Session {

    /// Minimal session info for lists and references
    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var date: Date
        public var sessionNumber: Int
        public var completed: Bool

        public init(id: UUID? = nil, date: Date = Date(), sessionNumber: Int = 1, completed: Bool = false) {
            self.id = id
            self.date = date
            self.sessionNumber = sessionNumber
            self.completed = completed
        }
    }

    /// Full session data including feelings and notes
    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var preSessionFeeling: FeelingLevel?
        public var postSessionFeeling: FeelingLevel?
        public var fatigueLevel: FatigueLevel?
        public var needsRest: Bool
        public var activitiesAfter: [PostSessionActivity]
        public var notes: String?
        public var memoriesDiscussed: [UUID] // References to Memory items
        public var dreamsReported: [UUID] // References to Dream items
        public var checkInScheduledFor: Date?

        public init(
            micro: Micro,
            preSessionFeeling: FeelingLevel? = nil,
            postSessionFeeling: FeelingLevel? = nil,
            fatigueLevel: FatigueLevel? = nil,
            needsRest: Bool = false,
            activitiesAfter: [PostSessionActivity] = [],
            notes: String? = nil,
            memoriesDiscussed: [UUID] = [],
            dreamsReported: [UUID] = [],
            checkInScheduledFor: Date? = nil
        ) {
            self.micro = micro
            self.preSessionFeeling = preSessionFeeling
            self.postSessionFeeling = postSessionFeeling
            self.fatigueLevel = fatigueLevel
            self.needsRest = needsRest
            self.activitiesAfter = activitiesAfter
            self.notes = notes
            self.memoriesDiscussed = memoriesDiscussed
            self.dreamsReported = dreamsReported
            self.checkInScheduledFor = checkInScheduledFor
        }
    }

    /// Data for creating a new session
    public struct CreateData: Codable, Sendable {
        public var date: Date
        public var sessionNumber: Int
        public var notes: String?

        public init(date: Date = Date(), sessionNumber: Int = 1, notes: String? = nil) {
            self.date = date
            self.sessionNumber = sessionNumber
            self.notes = notes
        }
    }
}

/// How the user is feeling emotionally
public enum FeelingLevel: String, Codable, CaseIterable, Sendable {
    case veryCalm = "very_calm"
    case calm = "calm"
    case neutral = "neutral"
    case anxious = "anxious"
    case veryAnxious = "very_anxious"
    case sad = "sad"
    case verySad = "very_sad"
    case hopeful = "hopeful"
    case relieved = "relieved"
    case overwhelmed = "overwhelmed"
    case energized = "energized"
    case numb = "numb"

    public var displayName: String {
        switch self {
        case .veryCalm: return "Very Calm"
        case .calm: return "Calm"
        case .neutral: return "Neutral"
        case .anxious: return "Anxious"
        case .veryAnxious: return "Very Anxious"
        case .sad: return "Sad"
        case .verySad: return "Very Sad"
        case .hopeful: return "Hopeful"
        case .relieved: return "Relieved"
        case .overwhelmed: return "Overwhelmed"
        case .energized: return "Energized"
        case .numb: return "Numb"
        }
    }

    /// SF Symbol name for this feeling level
    public var symbolName: String {
        switch self {
        case .veryCalm: return "leaf.fill"
        case .calm: return "sun.min.fill"
        case .neutral: return "circle.fill"
        case .anxious: return "waveform.path"
        case .veryAnxious: return "bolt.fill"
        case .sad: return "cloud.rain.fill"
        case .verySad: return "cloud.heavyrain.fill"
        case .hopeful: return "sunrise.fill"
        case .relieved: return "wind"
        case .overwhelmed: return "tornado"
        case .energized: return "sparkles"
        case .numb: return "minus.circle.fill"
        }
    }

    public var needsExtraSupport: Bool {
        switch self {
        case .veryAnxious, .verySad, .overwhelmed:
            return true
        default:
            return false
        }
    }
}

/// Physical fatigue level after a session
public enum FatigueLevel: String, Codable, CaseIterable, Sendable {
    case none = "none"
    case mild = "mild"
    case moderate = "moderate"
    case significant = "significant"
    case exhausted = "exhausted"

    public var displayName: String {
        switch self {
        case .none: return "Not tired"
        case .mild: return "A little tired"
        case .moderate: return "Moderately tired"
        case .significant: return "Very tired"
        case .exhausted: return "Completely exhausted"
        }
    }

    public var suggestsRest: Bool {
        switch self {
        case .significant, .exhausted:
            return true
        default:
            return false
        }
    }
}

/// What the user did after their session
public enum PostSessionActivity: String, Codable, CaseIterable, Sendable {
    case nap = "nap"
    case rest = "rest"
    case walk = "walk"
    case ate = "ate"
    case workedOut = "worked_out"
    case watchedTV = "watched_tv"
    case readBook = "read_book"
    case talkedToFriend = "talked_to_friend"
    case journaled = "journaled"
    case meditated = "meditated"
    case wentToWork = "went_to_work"
    case spentTimeWithFamily = "spent_time_with_family"
    case other = "other"

    public var displayName: String {
        switch self {
        case .nap: return "Took a nap"
        case .rest: return "Rested quietly"
        case .walk: return "Went for a walk"
        case .ate: return "Had a meal"
        case .workedOut: return "Exercised"
        case .watchedTV: return "Watched TV"
        case .readBook: return "Read a book"
        case .talkedToFriend: return "Talked to a friend"
        case .journaled: return "Journaled"
        case .meditated: return "Meditated"
        case .wentToWork: return "Went to work"
        case .spentTimeWithFamily: return "Spent time with family"
        case .other: return "Something else"
        }
    }
}

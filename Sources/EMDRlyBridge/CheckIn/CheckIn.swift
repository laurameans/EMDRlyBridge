import Foundation

/// Represents a check-in conversation with the user
public enum CheckIn {

    /// Minimal check-in info
    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var date: Date
        public var type: CheckInType
        public var completed: Bool
        public var userInitiated: Bool

        public init(
            id: UUID? = nil,
            date: Date = Date(),
            type: CheckInType = .routine,
            completed: Bool = false,
            userInitiated: Bool = false
        ) {
            self.id = id
            self.date = date
            self.type = type
            self.completed = completed
            self.userInitiated = userInitiated
        }
    }

    /// Full check-in with conversation
    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var relatedSessionId: UUID?
        public var messages: [ConversationMessage]
        public var currentFeeling: FeelingLevel?
        public var distressLevel: DistressLevel?
        public var memoriesSurfaced: [UUID]
        public var dreamsMentioned: [UUID]
        public var needsFollowUp: Bool
        public var crisisTriggered: Bool
        public var outcome: CheckInOutcome?

        public init(
            micro: Micro,
            relatedSessionId: UUID? = nil,
            messages: [ConversationMessage] = [],
            currentFeeling: FeelingLevel? = nil,
            distressLevel: DistressLevel? = nil,
            memoriesSurfaced: [UUID] = [],
            dreamsMentioned: [UUID] = [],
            needsFollowUp: Bool = false,
            crisisTriggered: Bool = false,
            outcome: CheckInOutcome? = nil
        ) {
            self.micro = micro
            self.relatedSessionId = relatedSessionId
            self.messages = messages
            self.currentFeeling = currentFeeling
            self.distressLevel = distressLevel
            self.memoriesSurfaced = memoriesSurfaced
            self.dreamsMentioned = dreamsMentioned
            self.needsFollowUp = needsFollowUp
            self.crisisTriggered = crisisTriggered
            self.outcome = outcome
        }
    }
}

/// Types of check-ins
public enum CheckInType: String, Codable, CaseIterable, Sendable {
    case postSession = "post_session" // After a therapy session
    case routine = "routine" // Scheduled daily/weekly
    case followUp = "follow_up" // Follow-up to concerning check-in
    case preSession = "pre_session" // Before upcoming session
    case dreamPrompt = "dream_prompt" // Morning dream capture
    case memoryPrompt = "memory_prompt" // Gentle memory exploration
    case celebration = "celebration" // Milestone acknowledgment
    case userInitiated = "user_initiated" // User opened the app to talk

    public var displayName: String {
        switch self {
        case .postSession: return "Post-Session Check-In"
        case .routine: return "Daily Check-In"
        case .followUp: return "Follow-Up"
        case .preSession: return "Pre-Session Prep"
        case .dreamPrompt: return "Morning Dream Check"
        case .memoryPrompt: return "Memory Exploration"
        case .celebration: return "Celebration"
        case .userInitiated: return "Chat"
        }
    }

    public var openingMessage: String {
        switch self {
        case .postSession:
            return "Hey, how are you doing after your session today? That was a lot of work."
        case .routine:
            return "Hi there. Just checking in - how are you feeling today?"
        case .followUp:
            return "Hey, I wanted to check back in with you. How are things going since we last talked?"
        case .preSession:
            return "You have a session coming up. How are you feeling about it? Is there anything on your mind you want to bring up?"
        case .dreamPrompt:
            return "Good morning. Did you have any dreams last night you'd like to capture while they're fresh?"
        case .memoryPrompt:
            return "I was thinking about your timeline. Would you be up for exploring some memories a bit more? Only if you're in a good space for it."
        case .celebration:
            return "I just wanted to say - look how far you've come. You're doing amazing work."
        case .userInitiated:
            return "Hey, I'm here. What's on your mind?"
        }
    }
}

/// A message in the check-in conversation
public struct ConversationMessage: Codable, Hashable, Identifiable, Sendable {
    public var id: UUID
    public var timestamp: Date
    public var role: MessageRole
    public var content: String
    public var quickRepliesOffered: [QuickReply]?
    public var quickReplySelected: QuickReply?
    public var wasTypedResponse: Bool

    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        role: MessageRole,
        content: String,
        quickRepliesOffered: [QuickReply]? = nil,
        quickReplySelected: QuickReply? = nil,
        wasTypedResponse: Bool = false
    ) {
        self.id = id
        self.timestamp = timestamp
        self.role = role
        self.content = content
        self.quickRepliesOffered = quickRepliesOffered
        self.quickReplySelected = quickReplySelected
        self.wasTypedResponse = wasTypedResponse
    }
}

/// Who sent the message
public enum MessageRole: String, Codable, Sendable {
    case assistant = "assistant"
    case user = "user"
}

/// Quick reply options for common responses
public struct QuickReply: Codable, Hashable, Identifiable, Sendable {
    public var id: UUID
    public var text: String
    public var sentiment: QuickReplySentiment
    public var action: QuickReplyAction?

    public init(
        id: UUID = UUID(),
        text: String,
        sentiment: QuickReplySentiment = .neutral,
        action: QuickReplyAction? = nil
    ) {
        self.id = id
        self.text = text
        self.sentiment = sentiment
        self.action = action
    }

    public enum QuickReplySentiment: String, Codable, Sendable {
        case positive, neutral, negative, needsSupport
    }

    public enum QuickReplyAction: String, Codable, Sendable {
        case endConversation
        case escalateToCrisis
        case scheduleFollowUp
        case recordMemory
        case recordDream
        case contactTherapist
        case showResources
    }
}

/// Standard quick replies for different situations
public enum QuickReplies {

    public static var howAreYou: [QuickReply] {
        [
            QuickReply(text: "I'm doing okay", sentiment: .positive),
            QuickReply(text: "Hanging in there", sentiment: .neutral),
            QuickReply(text: "It's been hard", sentiment: .negative),
            QuickReply(text: "I need to talk", sentiment: .needsSupport)
        ]
    }

    public static var wantToTalk: [QuickReply] {
        [
            QuickReply(text: "Yes, I'd like that", sentiment: .positive),
            QuickReply(text: "Maybe later", sentiment: .neutral, action: .scheduleFollowUp),
            QuickReply(text: "Not right now", sentiment: .neutral, action: .endConversation),
            QuickReply(text: "This is too much", sentiment: .needsSupport, action: .escalateToCrisis)
        ]
    }

    public static var memorySurfaced: [QuickReply] {
        [
            QuickReply(text: "Yes, I want to write it down", sentiment: .positive, action: .recordMemory),
            QuickReply(text: "Yes, but I'm not ready to record it", sentiment: .neutral),
            QuickReply(text: "No, nothing new", sentiment: .neutral),
            QuickReply(text: "I'd rather not think about it", sentiment: .negative)
        ]
    }

    public static var howWasSession: [QuickReply] {
        [
            QuickReply(text: "It was productive", sentiment: .positive),
            QuickReply(text: "It was intense", sentiment: .neutral),
            QuickReply(text: "It was really hard", sentiment: .negative),
            QuickReply(text: "I'm exhausted", sentiment: .negative)
        ]
    }

    public static var needsRest: [QuickReply] {
        [
            QuickReply(text: "You're right, I'll rest", sentiment: .positive, action: .endConversation),
            QuickReply(text: "I want to talk a bit more", sentiment: .neutral),
            QuickReply(text: "I can't rest right now", sentiment: .negative)
        ]
    }

    public static var crisis: [QuickReply] {
        [
            QuickReply(text: "I'm safe, just overwhelmed", sentiment: .neutral),
            QuickReply(text: "I need crisis support", sentiment: .needsSupport, action: .escalateToCrisis),
            QuickReply(text: "Can you contact my therapist?", sentiment: .needsSupport, action: .contactTherapist),
            QuickReply(text: "Show me calming resources", sentiment: .neutral, action: .showResources)
        ]
    }
}

/// Distress level assessment
public enum DistressLevel: Int, Codable, CaseIterable, Sendable {
    case none = 0
    case mild = 1
    case moderate = 2
    case significant = 3
    case severe = 4
    case crisis = 5

    public var requiresAction: Bool {
        self.rawValue >= DistressLevel.severe.rawValue
    }

    public var suggestRest: Bool {
        self.rawValue >= DistressLevel.moderate.rawValue
    }
}

/// How the check-in ended
public enum CheckInOutcome: String, Codable, Sendable {
    case completedPositive = "completed_positive"
    case completedNeutral = "completed_neutral"
    case userRequestedEnd = "user_requested_end"
    case scheduledFollowUp = "scheduled_follow_up"
    case escalatedToCrisis = "escalated_to_crisis"
    case therapistContacted = "therapist_contacted"
    case memoryRecorded = "memory_recorded"
    case dreamRecorded = "dream_recorded"
}

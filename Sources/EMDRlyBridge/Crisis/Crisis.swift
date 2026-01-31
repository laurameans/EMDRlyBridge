import Foundation

/// Crisis support and safety features
public enum Crisis {

    /// Crisis contact information
    public struct Contact: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var name: String
        public var phone: String
        public var type: ContactType
        public var is24Hours: Bool
        public var notes: String?

        public init(
            id: UUID? = nil,
            name: String,
            phone: String,
            type: ContactType,
            is24Hours: Bool = true,
            notes: String? = nil
        ) {
            self.id = id
            self.name = name
            self.phone = phone
            self.type = type
            self.is24Hours = is24Hours
            self.notes = notes
        }
    }

    public enum ContactType: String, Codable, CaseIterable, Sendable {
        case hotline = "hotline"
        case therapist = "therapist"
        case emergencyContact = "emergency_contact"
        case hospital = "hospital"
        case textLine = "text_line"

        public var displayName: String {
            switch self {
            case .hotline: return "Crisis Hotline"
            case .therapist: return "Therapist"
            case .emergencyContact: return "Emergency Contact"
            case .hospital: return "Hospital"
            case .textLine: return "Text Line"
            }
        }
    }

    /// Built-in crisis resources
    public static var defaultResources: [Contact] {
        [
            Contact(
                name: "988 Suicide & Crisis Lifeline",
                phone: "988",
                type: .hotline,
                is24Hours: true,
                notes: "Call or text 988. Free, confidential support."
            ),
            Contact(
                name: "Crisis Text Line",
                phone: "741741",
                type: .textLine,
                is24Hours: true,
                notes: "Text HOME to 741741"
            ),
            Contact(
                name: "SAMHSA National Helpline",
                phone: "1-800-662-4357",
                type: .hotline,
                is24Hours: true,
                notes: "Treatment referral and information"
            ),
            Contact(
                name: "Emergency Services",
                phone: "911",
                type: .hospital,
                is24Hours: true,
                notes: "For immediate danger to yourself or others"
            )
        ]
    }

    /// Safety check-in structure
    public struct SafetyCheck: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var timestamp: Date
        public var distressLevel: DistressLevel
        public var feelingSafe: Bool?
        public var hasSafetyPlan: Bool
        public var memoriesContained: Bool?
        public var groundingWorking: Bool?
        public var needsSupport: SupportNeeded
        public var outcome: SafetyOutcome?

        public init(
            id: UUID? = nil,
            timestamp: Date = Date(),
            distressLevel: DistressLevel = .none,
            feelingSafe: Bool? = nil,
            hasSafetyPlan: Bool = false,
            memoriesContained: Bool? = nil,
            groundingWorking: Bool? = nil,
            needsSupport: SupportNeeded = .none,
            outcome: SafetyOutcome? = nil
        ) {
            self.id = id
            self.timestamp = timestamp
            self.distressLevel = distressLevel
            self.feelingSafe = feelingSafe
            self.hasSafetyPlan = hasSafetyPlan
            self.memoriesContained = memoriesContained
            self.groundingWorking = groundingWorking
            self.needsSupport = needsSupport
            self.outcome = outcome
        }
    }

    public enum SupportNeeded: String, Codable, CaseIterable, Sendable {
        case none = "none"
        case grounding = "grounding"
        case breathing = "breathing"
        case distraction = "distraction"
        case talkToSomeone = "talk_to_someone"
        case professionalHelp = "professional_help"
        case emergencyServices = "emergency_services"

        public var displayName: String {
            switch self {
            case .none: return "I'm okay"
            case .grounding: return "Grounding exercises"
            case .breathing: return "Breathing exercises"
            case .distraction: return "Distraction activities"
            case .talkToSomeone: return "Talk to someone"
            case .professionalHelp: return "Contact my therapist"
            case .emergencyServices: return "Emergency services"
            }
        }
    }

    public enum SafetyOutcome: String, Codable, Sendable {
        case stabilized = "stabilized"
        case usedGrounding = "used_grounding"
        case contactedSupport = "contacted_support"
        case contactedTherapist = "contacted_therapist"
        case calledHotline = "called_hotline"
        case called911 = "called_911"
        case scheduledFollowUp = "scheduled_follow_up"
    }
}

/// Grounding exercises for crisis moments
public struct GroundingExercise: Codable, Hashable, Identifiable, Sendable {
    public var id: UUID
    public var name: String
    public var category: GroundingCategory
    public var shortDescription: String
    public var steps: [String]
    public var durationMinutes: Int

    public init(
        id: UUID = UUID(),
        name: String,
        category: GroundingCategory,
        shortDescription: String,
        steps: [String],
        durationMinutes: Int = 5
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.shortDescription = shortDescription
        self.steps = steps
        self.durationMinutes = durationMinutes
    }

    public enum GroundingCategory: String, Codable, CaseIterable, Sendable {
        case sensory = "sensory"
        case breathing = "breathing"
        case mental = "mental"
        case physical = "physical"
    }
}

/// Built-in grounding exercises
public struct GroundingExercises {

    public static var all: [GroundingExercise] {
        [fiveFourThreeTwo, boxBreathing, bodyAwareness, safePlaceVisualization, countingBreath]
    }

    public static var fiveFourThreeTwo: GroundingExercise {
        GroundingExercise(
            name: "5-4-3-2-1",
            category: .sensory,
            shortDescription: "Use your senses to ground yourself in the present moment",
            steps: [
                "Look around and name 5 things you can see",
                "Touch 4 things near you and notice how they feel",
                "Listen for 3 sounds you can hear right now",
                "Notice 2 things you can smell",
                "Focus on 1 thing you can taste"
            ],
            durationMinutes: 5
        )
    }

    public static var boxBreathing: GroundingExercise {
        GroundingExercise(
            name: "Box Breathing",
            category: .breathing,
            shortDescription: "A calming breathing technique used by Navy SEALs",
            steps: [
                "Breathe in slowly for 4 seconds",
                "Hold your breath for 4 seconds",
                "Breathe out slowly for 4 seconds",
                "Hold your breath for 4 seconds",
                "Repeat this cycle 4-6 times"
            ],
            durationMinutes: 3
        )
    }

    public static var bodyAwareness: GroundingExercise {
        GroundingExercise(
            name: "Body Awareness",
            category: .physical,
            shortDescription: "Feel your body's connection to the present",
            steps: [
                "Feel your feet on the ground - press them down gently",
                "Notice where your body touches the chair or surface",
                "Relax your shoulders - let them drop",
                "Unclench your jaw",
                "Take a slow, deep breath"
            ],
            durationMinutes: 3
        )
    }

    public static var safePlaceVisualization: GroundingExercise {
        GroundingExercise(
            name: "Safe Place",
            category: .mental,
            shortDescription: "Visit a calm, safe place in your mind",
            steps: [
                "Close your eyes if comfortable, or soften your gaze",
                "Picture a place where you feel completely safe and calm",
                "Notice the details - colors, sounds, smells",
                "Feel the safety of this place surrounding you",
                "Stay here for a few moments, breathing slowly",
                "When ready, slowly open your eyes"
            ],
            durationMinutes: 5
        )
    }

    public static var countingBreath: GroundingExercise {
        GroundingExercise(
            name: "Counting Breath",
            category: .breathing,
            shortDescription: "Simple counting to calm your nervous system",
            steps: [
                "Breathe in and count 1",
                "Breathe out and count 2",
                "Continue counting each breath up to 10",
                "Start over at 1",
                "If you lose count, just start again at 1 - that's okay"
            ],
            durationMinutes: 3
        )
    }
}

/// Dangerous thought detection keywords (for crisis screening)
public struct SafetyScreening {

    /// Words that may indicate the user needs crisis support
    /// This is NOT diagnostic - just triggers a gentle check-in
    public static var concerningPatterns: [String] {
        [
            "want to die",
            "kill myself",
            "end it",
            "can't go on",
            "no point",
            "better off without me",
            "hurt myself",
            "don't want to be here",
            "give up",
            "no reason to live",
            "too much to handle",
            "can't take it",
            "hopeless"
        ]
    }

    /// Check if text contains concerning patterns
    public static func containsConcerningContent(_ text: String) -> Bool {
        let lowered = text.lowercased()
        return concerningPatterns.contains { lowered.contains($0) }
    }

    /// Gentle response for concerning content
    public static var gentleCrisisResponse: String {
        "I hear that you're going through something really difficult right now. Your feelings are valid, and you don't have to face this alone. Would it help to talk about what's happening? I'm here, and so are people who can help."
    }
}

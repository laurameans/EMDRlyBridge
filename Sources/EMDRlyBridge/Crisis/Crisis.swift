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

/// Crisis severity levels for tiered response
public enum CrisisSeverity: String, Codable, Sendable {
    /// Active methods or planning - immediate danger
    case immediate
    /// Direct suicidal ideation or self-harm intent
    case elevated
    /// Hopelessness, passive ideation, or overwhelming distress
    case distressed
}

/// Dangerous thought detection keywords (for crisis screening)
public struct SafetyScreening {

    // MARK: - Immediate severity (methods, planning, active intent)

    private static let immediatePatterns: [String] = [
        // Methods
        "jump off", "jump from", "jump off a bridge",
        "slit my wrists", "cut my wrists",
        "overdose", "take all my pills", "take all the pills",
        "hang myself", "hanging myself",
        "shoot myself", "shooting myself",
        "drown myself", "drowning myself",
        "step in front of", "throw myself",
        "stab myself",
        // Planning indicators
        "writing a note", "wrote a note", "goodbye letter",
        "giving away my things", "gave away my stuff",
        "saying goodbye to everyone", "said my goodbyes",
        "making arrangements", "made arrangements",
        "before i go", "when i'm gone", "after i'm gone",
        "i've decided to end", "decided to kill",
        "made up my mind", "i have a plan",
        "bought a gun", "found a way"
    ]

    // MARK: - Elevated severity (direct ideation, self-harm)

    private static let elevatedPatterns: [String] = [
        // Direct suicidal ideation
        "want to die", "i want to die",
        "kill myself", "killing myself",
        "end my life", "end it all", "take my own life", "take my life",
        "suicide", "suicidal",
        "better off dead", "rather be dead",
        "wish i was dead", "wish i were dead", "wish i wasn't alive",
        "don't want to live", "don't want to be alive",
        "not worth living", "life isn't worth",
        // Self-harm
        "hurt myself", "hurting myself", "harm myself", "harming myself",
        "cutting myself", "cut myself",
        "burn myself", "burning myself",
        "punish myself", "punishing myself",
        "hitting myself", "hit myself"
    ]

    // MARK: - Distressed severity (hopelessness, passive ideation, crisis state)

    private static let distressedPatterns: [String] = [
        // Passive ideation
        "can't go on", "cannot go on",
        "no point", "no point in living", "no point in trying",
        "better off without me", "world would be better without",
        "don't want to be here", "don't want to wake up",
        "wish i wasn't here", "wish i could disappear",
        "nobody would care if", "nobody would miss me",
        "nobody would notice", "no one would care",
        "wouldn't matter if i", "the world would be better",
        // Hopelessness
        "hopeless", "completely hopeless",
        "no way out", "trapped forever", "never get better",
        "nothing will change", "nothing ever changes",
        "given up", "give up", "giving up on everything",
        "what's the point", "there's no point",
        "can't take it", "can't take it anymore",
        "too much to handle", "too much to bear",
        "can't do this anymore", "i can't anymore",
        "no reason to live", "no reason to keep going",
        // Crisis state
        "panic attack", "having a panic attack",
        "flashback", "having a flashback",
        "dissociating", "i'm dissociating",
        "not in my body", "can't feel my body",
        "losing control", "losing my mind",
        "can't breathe", "i can't breathe"
    ]

    /// All concerning patterns combined (kept for backward compatibility)
    public static var concerningPatterns: [String] {
        immediatePatterns + elevatedPatterns + distressedPatterns
    }

    /// Check if text contains concerning patterns (backward compatible)
    public static func containsConcerningContent(_ text: String) -> Bool {
        classifySeverity(text) != nil
    }

    /// Classify the severity of concerning content in text
    /// Returns nil if no concerning content is detected
    public static func classifySeverity(_ text: String) -> CrisisSeverity? {
        let lowered = text.lowercased()

        if immediatePatterns.contains(where: { lowered.contains($0) }) {
            return .immediate
        }
        if elevatedPatterns.contains(where: { lowered.contains($0) }) {
            return .elevated
        }
        if distressedPatterns.contains(where: { lowered.contains($0) }) {
            return .distressed
        }
        return nil
    }

    /// Tiered crisis response based on severity
    public static func crisisResponse(severity: CrisisSeverity) -> String {
        switch severity {
        case .immediate:
            return """
            I'm really concerned about what you're sharing, and I'm glad you told me. You don't have to go through this alone.

            Please reach out now:
            \u{2022} Call or text 988 (Suicide & Crisis Lifeline) \u{2014} free, confidential, 24/7
            \u{2022} Text HOME to 741741 (Crisis Text Line)
            \u{2022} Call 911 if you're in immediate danger

            Would you like me to notify your therapist or emergency contact?
            """
        case .elevated:
            return """
            I hear that you're going through something really difficult right now. Your feelings are valid, and you don't have to face this alone.

            If you need support right now: call or text 988 (Suicide & Crisis Lifeline) \u{2014} it's free and available 24/7.

            Would it help to talk about what's happening, or would you like to try a grounding exercise?
            """
        case .distressed:
            return """
            That sounds really overwhelming. I'm here with you.

            If things feel like too much, the 988 Lifeline is always available (call or text 988).

            What would feel most helpful right now?
            """
        }
    }

    /// Gentle response for concerning content (backward compatible, uses elevated level)
    public static var gentleCrisisResponse: String {
        crisisResponse(severity: .elevated)
    }
}

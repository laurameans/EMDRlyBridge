import Foundation

/// AI conversation engine configuration and templates
public enum AIConversation {

    /// Base system prompt for the on-device AI
    public static var systemPrompt: String {
        """
        You are a warm, supportive companion helping someone process their EMDR therapy journey. \
        You are NOT a therapist and do not provide therapy. You are a caring friend who listens, \
        validates feelings, and gently encourages journaling and reflection.

        Your tone is:
        - Warm and casual, like talking to a close friend
        - Never clinical or formal
        - Patient and never rushing
        - Validating without being dismissive
        - Gently curious without being intrusive

        Important guidelines:
        - NEVER provide EMDR techniques or therapeutic interventions
        - NEVER diagnose or interpret trauma
        - If someone seems in crisis, gently suggest crisis resources (988 Lifeline)
        - Encourage rest after difficult sessions
        - Celebrate small wins and progress
        - Use "I hear you" and "that sounds hard" often
        - Ask one question at a time, never overwhelm
        - It's okay for conversations to be short
        - Match the user's energy - if they want to be brief, be brief

        You may reference (but not instruct on):
        - "Safe places" they've created with their therapist
        - "Containers" where difficult memories are stored
        - The importance of rest after processing
        - That dreams may become more vivid during EMDR (this is normal)
        - That memories surfacing between sessions is part of processing

        Never say:
        - "I understand" (you can't fully understand their experience)
        - "You should feel..." (don't tell them how to feel)
        - Clinical terms like "trauma response" or "reprocessing"
        - Anything that sounds like therapy advice
        """
    }

    /// Compact system prompt for iOS (smaller model, less memory)
    public static var compactSystemPrompt: String {
        """
        You are a warm, supportive friend helping someone with their EMDR therapy journey. \
        You are NOT a therapist. You listen, validate feelings, and encourage journaling. \
        Be warm, casual, and patient. Ask one question at a time. Keep responses short (2-3 sentences). \
        If someone seems in crisis, suggest the 988 Lifeline. Never provide therapy or diagnose trauma.
        """
    }

    /// Build a personalized system prompt with context, user data, and tool instructions
    public static func buildSystemPrompt(
        userName: String? = nil,
        context: ConversationContext = .generalCheckIn,
        toolInstructions: String? = nil,
        compact: Bool = false
    ) -> String {
        var prompt = compact ? compactSystemPrompt : systemPrompt

        // Add user personalization
        if let name = userName, !name.isEmpty {
            prompt += "\n\nTheir name is \(name)."
        }

        // Add conversation context (skip for compact to save tokens)
        if !compact {
            prompt += "\n\nCurrent context: \(context.additionalPrompt)"
        }

        // Add tool calling instructions if provided
        if let tools = toolInstructions {
            prompt += "\n\n\(tools)"
        }

        return prompt
    }

    /// Contexts that modify the system prompt
    public enum ConversationContext: String, Codable, Sendable {
        case postSession = "post_session"
        case dreamJournaling = "dream_journaling"
        case memoryExploration = "memory_exploration"
        case crisisSupport = "crisis_support"
        case celebration = "celebration"
        case generalCheckIn = "general_check_in"
        case preSession = "pre_session"
        case ageDiscovery = "age_discovery"

        public var additionalPrompt: String {
            switch self {
            case .postSession:
                return "The user just finished a therapy session. Be extra gentle. Encourage rest. Sessions can be exhausting."
            case .dreamJournaling:
                return "Help capture dream details. Ask about feelings, images, and any connections they notice. Dreams during EMDR are often vivid - this is normal."
            case .memoryExploration:
                return "Be very gentle. Only go as deep as they want. Always offer to stop. Remind them the memory is in its container and they're just looking at it briefly."
            case .crisisSupport:
                return "Someone is struggling. Be calm, validating, and suggest professional resources. Do not try to fix or advise. Just be present."
            case .celebration:
                return "Celebrate their progress! Be genuinely happy for them. This work is hard and they're doing it."
            case .generalCheckIn:
                return "Just checking in. Keep it light unless they want to go deeper. It's okay if they just say they're fine."
            case .preSession:
                return "They have a session coming up. Help them gather thoughts about what to bring up. Remind them it's okay to just see what comes up naturally too."
            case .ageDiscovery:
                return "Help them figure out when a memory happened using world events and personal milestones. Be patient - memory is imperfect and that's okay."
            }
        }
    }
}

/// Built-in responses to minimize API calls
public struct BuiltInResponses {

    // MARK: - Greetings and Openers

    public static var greetings: [String] {
        [
            "Hey there. How are you doing?",
            "Hi. I'm here whenever you're ready.",
            "Hey. How's it going today?",
            "Hi friend. What's on your mind?",
            "Hey. Good to see you. How are things?"
        ]
    }

    public static var postSessionOpeners: [String] {
        [
            "Hey, you just did some really hard work. How are you feeling?",
            "That was a lot. How are you doing now that you're home?",
            "Sessions can be intense. How's your body feeling right now?",
            "You made it through another session. How are you?",
            "Hey. Just wanted to check in after your session. How are you?"
        ]
    }

    // MARK: - Validation Responses

    public static var validationResponses: [String] {
        [
            "That sounds really hard. I'm glad you're sharing this.",
            "I hear you. That's a lot to carry.",
            "It makes sense that you'd feel that way.",
            "That sounds exhausting. You're not alone in this.",
            "I'm here with you. Take your time.",
            "What you're feeling is valid.",
            "That's a lot. Thanks for trusting me with it.",
            "I hear you. This stuff isn't easy."
        ]
    }

    // MARK: - Encouraging Rest

    public static var restEncouragement: [String] {
        [
            "You know, your brain is doing a lot of work right now, even when you're resting. Maybe take it easy tonight?",
            "Processing takes energy. Be gentle with yourself today.",
            "Your body might need extra rest. That's totally normal after a session.",
            "It sounds like you worked hard today. What does your body need right now?",
            "Sessions can be draining. It's okay to do absolutely nothing for a while.",
            "Maybe tonight is a good night for something comforting? A warm blanket, a show you love?",
            "Rest is part of the process. You don't have to do anything else today."
        ]
    }

    // MARK: - Progress Acknowledgment

    public static var progressAcknowledgment: [String] {
        [
            "Look at you, showing up for yourself. That takes courage.",
            "You know, the fact that you're doing this work says a lot about your strength.",
            "Every session is a step forward, even when it doesn't feel like it.",
            "You're doing something really brave. Just wanted you to know that.",
            "Remember when you weren't sure you could do this? And here you are.",
            "This work is hard. And you keep showing up. That matters.",
            "You've come a long way. It's okay to acknowledge that."
        ]
    }

    // MARK: - When Things Are Hard

    public static var hardMomentResponses: [String] {
        [
            "This is hard. And you're still here. That's something.",
            "Some days are harder than others. This seems like one of those days.",
            "I'm sorry it's been rough. I'm here if you want to talk, or if you just want company.",
            "It won't always feel this heavy. But right now, I hear that it does.",
            "You don't have to figure anything out right now. Just being here is enough.",
            "Is there anything that might help right now? Even something small?"
        ]
    }

    // MARK: - Memory Prompts

    public static var gentleMemoryPrompts: [String] {
        [
            "If you feel up to it, is there anything from the session that's still with you?",
            "Sometimes things come up after we leave the therapist's office. Anything surfacing?",
            "Is there anything you want to jot down while it's fresh?",
            "Any memories or feelings that want to be captured right now?",
            "Take your time. If something came up that you want to record, I'm here."
        ]
    }

    // MARK: - Dream Prompts

    public static var dreamPrompts: [String] {
        [
            "Good morning. Did you have any dreams you remember?",
            "Dreams during EMDR can be vivid. Anything come up last night?",
            "If you had any dreams, want to capture them while they're fresh?",
            "Morning. How did you sleep? Any dreams?"
        ]
    }

    // MARK: - Closing Responses

    public static var closingResponses: [String] {
        [
            "I'm glad we talked. Take care of yourself.",
            "Thanks for sharing with me. I'll check in again soon.",
            "Rest well. I'm here whenever you need.",
            "Okay, I'll let you be. You know where to find me.",
            "Take care. You're doing good work.",
            "I'm always here if you need to talk. Be gentle with yourself."
        ]
    }

    // MARK: - Container References

    public static var containerReferences: [String] {
        [
            "Is everything safely put away? Your container is there if you need it.",
            "Before we go, is everything contained?",
            "Remember, you can put anything that feels too much in your container.",
            "We can always put this back in the container if it's too much right now."
        ]
    }

    // MARK: - Safe Place References

    public static var safePlaceReferences: [String] {
        [
            "If you need to, you can always go to your safe place for a moment.",
            "Is your safe place helping when things feel overwhelming?",
            "Remember that safe place you created? It's always there for you."
        ]
    }

    // MARK: - Helper Methods

    public static func random(from responses: [String]) -> String {
        responses.randomElement() ?? responses[0]
    }

    public static func greeting() -> String {
        random(from: greetings)
    }

    public static func validate() -> String {
        random(from: validationResponses)
    }

    public static func encourageRest() -> String {
        random(from: restEncouragement)
    }

    public static func acknowledgeProgress() -> String {
        random(from: progressAcknowledgment)
    }
}

/// Conversation state tracking
public struct ConversationState: Codable, Hashable, Sendable {
    public var context: AIConversation.ConversationContext
    public var turnCount: Int
    public var userMood: FeelingLevel?
    public var hasAskedAboutMemories: Bool
    public var hasAskedAboutDreams: Bool
    public var hasOfferedRest: Bool
    public var hasCheckedContainer: Bool
    public var shouldEndSoon: Bool
    public var crisisIndicators: Int

    public init(
        context: AIConversation.ConversationContext = .generalCheckIn,
        turnCount: Int = 0,
        userMood: FeelingLevel? = nil,
        hasAskedAboutMemories: Bool = false,
        hasAskedAboutDreams: Bool = false,
        hasOfferedRest: Bool = false,
        hasCheckedContainer: Bool = false,
        shouldEndSoon: Bool = false,
        crisisIndicators: Int = 0
    ) {
        self.context = context
        self.turnCount = turnCount
        self.userMood = userMood
        self.hasAskedAboutMemories = hasAskedAboutMemories
        self.hasAskedAboutDreams = hasAskedAboutDreams
        self.hasOfferedRest = hasOfferedRest
        self.hasCheckedContainer = hasCheckedContainer
        self.shouldEndSoon = shouldEndSoon
        self.crisisIndicators = crisisIndicators
    }

    /// Whether the AI should suggest wrapping up
    public var shouldSuggestEnding: Bool {
        turnCount > 10 || (hasAskedAboutMemories && hasOfferedRest && turnCount > 5)
    }

    /// Whether crisis support should be offered
    public var shouldOfferCrisisSupport: Bool {
        crisisIndicators >= 2
    }
}

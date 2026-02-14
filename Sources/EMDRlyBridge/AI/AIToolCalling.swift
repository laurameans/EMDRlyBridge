import Foundation

// MARK: - AI Tool Definitions

/// Tools the AI chatbot can call to interact with user data
public enum AITool: String, Codable, CaseIterable, Sendable {
    case writeDream = "write_dream"
    case writeMemory = "write_memory"
    case interpretDream = "interpret_dream"
    case searchContext = "search_context"
    case recordPattern = "record_pattern"
    case setUserFact = "set_user_fact"

    /// Description for the system prompt
    public var promptDescription: String {
        switch self {
        case .writeDream:
            return """
            write_dream(title, description, intensity, wasNightmare, emotions)
            - Save a dream the user described to their dream journal
            - ALWAYS ask the user "Would you like me to save this dream to your journal?" before calling
            - Only call after they confirm
            """
        case .writeMemory:
            return """
            write_memory(title, description, intensity, emotions)
            - Save a memory the user shared to their memory timeline
            - ALWAYS ask the user "Would you like me to save this memory?" before calling
            - Only call after they confirm
            """
        case .interpretDream:
            return """
            interpret_dream(dreamTitle, framework)
            - Interpret a dream using a therapeutic framework
            - framework can be: jungian, gestalt, emdr_processing
            - Use when the user asks about dream meaning or significance
            """
        case .searchContext:
            return """
            search_context(query)
            - Search the user's past dreams, memories, sessions, and conversations
            - Use when the conversation references past experiences or you want to find patterns
            """
        case .recordPattern:
            return """
            record_pattern(patternType, description)
            - Record a behavioral or emotional pattern you've noticed
            - patternType: behavioral, emotional, avoidance, growth, trigger
            """
        case .setUserFact:
            return """
            set_user_fact(key, value)
            - Remember a fact about the user for future conversations
            - Examples: therapist_name, safe_place, session_day, preferred_name
            """
        }
    }
}

/// A parsed tool call from LLM output
public struct AIToolCall: Codable, Sendable {
    public let tool: String
    public let arguments: [String: String]

    public init(tool: String, arguments: [String: String]) {
        self.tool = tool
        self.arguments = arguments
    }

    /// Get the AITool enum value
    public var toolType: AITool? {
        AITool(rawValue: tool)
    }
}

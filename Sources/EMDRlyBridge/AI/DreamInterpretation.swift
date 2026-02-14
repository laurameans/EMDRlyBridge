import Foundation

// MARK: - Dream Interpreter

/// Builds dream interpretation prompts using therapeutic frameworks
public struct DreamInterpreter {

    /// Therapeutic framework for dream interpretation
    public enum Framework: String, Codable, Sendable {
        case jungian
        case gestalt
        case emdrProcessing

        public var displayName: String {
            switch self {
            case .jungian: return "Jungian"
            case .gestalt: return "Gestalt"
            case .emdrProcessing: return "EMDR Processing"
            }
        }

        public var description: String {
            switch self {
            case .jungian:
                return """
                In Jungian dream analysis, dreams are messages from the unconscious mind. \
                Elements in the dream may represent archetypes (the shadow, the anima/animus, the self). \
                Focus on what each symbol might represent about the dreamer's inner world and personal growth.
                """
            case .gestalt:
                return """
                In Gestalt dream work, every element of the dream represents a part of the dreamer. \
                The dreamer is encouraged to "become" each element and speak from its perspective. \
                Focus on what each part of the dream might be expressing about the dreamer's current experience.
                """
            case .emdrProcessing:
                return """
                In EMDR context, dreams are often the brain's way of processing difficult material. \
                Vivid or disturbing dreams may increase during active EMDR treatment as the brain reprocesses memories. \
                Focus on themes of safety, control, and resolution as signs of healthy processing.
                """
            }
        }
    }

    /// Build an interpretation prompt for the LLM
    public static func buildInterpretationPrompt(
        dream: Dream.Global,
        framework: Framework
    ) -> String {
        // Gather theme insights
        let themeInsights: String
        if !dream.themes.isEmpty {
            let insights = dream.themes.map { theme in
                "- \(theme.displayName): \(theme.processingSignificance)"
            }.joined(separator: "\n")
            themeInsights = "\n\nTheme insights from EMDR perspective:\n\(insights)"
        } else {
            themeInsights = ""
        }

        // Gather emotion context
        let emotionContext: String
        if !dream.emotionsPresent.isEmpty {
            let emotions = dream.emotionsPresent.map { $0.displayName }.joined(separator: ", ")
            emotionContext = "\nEmotions present: \(emotions)"
        } else {
            emotionContext = ""
        }

        return """
        The user shared this dream: "\(dream.description)"

        Dream title: "\(dream.micro.title)"
        Intensity: \(dream.micro.intensity.displayName)
        Was nightmare: \(dream.micro.wasNightmare ? "Yes" : "No")\(emotionContext)
        Themes: \(dream.themes.map(\.displayName).joined(separator: ", "))\(themeInsights)

        Using a \(framework.displayName) perspective:
        \(framework.description)

        Provide a brief, gentle interpretation in 2-3 sentences. \
        Frame your insights as possibilities, not certainties. Use language like "this might connect to..." \
        or "some people find that..." \
        Remember: you are NOT a therapist. Encourage them to explore this with their therapist. \
        End with a gentle question to invite reflection.
        """
    }

    /// Extract likely dream themes from free-text dream description
    public static func detectThemes(from description: String) -> [DreamTheme] {
        let lowered = description.lowercased()
        var themes: [DreamTheme] = []

        let themeKeywords: [(DreamTheme, [String])] = [
            (.beingChased, ["chased", "chasing", "running from", "pursuing", "followed"]),
            (.falling, ["falling", "fell", "dropped", "plummeting"]),
            (.flying, ["flying", "floating", "soaring", "hovering"]),
            (.water, ["water", "ocean", "sea", "river", "lake", "swimming", "drowning", "waves", "rain", "flood"]),
            (.fire, ["fire", "burning", "flames", "smoke"]),
            (.death, ["death", "dying", "dead", "funeral", "killed"]),
            (.lostOrTrapped, ["lost", "trapped", "stuck", "can't find", "maze", "locked"]),
            (.beingAttacked, ["attacked", "hit", "punched", "hurt", "assaulted"]),
            (.teethFalling, ["teeth", "tooth"]),
            (.unableToMove, ["can't move", "couldn't move", "paralyzed", "frozen"]),
            (.unableToSpeak, ["can't speak", "couldn't speak", "voiceless", "couldn't scream", "couldn't yell"]),
            (.protectingSomeone, ["protecting", "saving", "shielding", "guarding"]),
            (.beingProtected, ["protected", "saved", "safe", "sheltered"]),
            (.confrontingAbuser, ["confronted", "stood up to", "faced"]),
            (.escaping, ["escaped", "escaping", "ran away", "got out", "broke free"]),
            (.findingSafety, ["found safety", "safe place", "shelter", "refuge"]),
            (.transformation, ["transformed", "changed", "becoming", "metamorphosis"]),
            (.healing, ["healed", "healing", "recovered", "peaceful", "serene"]),
            (.childhoodHome, ["childhood", "grew up", "old house", "parents house", "kid again"]),
            (.school, ["school", "classroom", "teacher", "exam", "test"]),
            (.workplace, ["work", "office", "boss", "job", "meeting"]),
            (.familyMembers, ["mom", "dad", "mother", "father", "sister", "brother", "family", "grandmother", "grandfather"])
        ]

        for (theme, keywords) in themeKeywords {
            if keywords.contains(where: { lowered.contains($0) }) {
                themes.append(theme)
            }
        }

        return themes
    }
}

import Foundation

/// Life story and timeline generation
public enum LifeStory {

    /// A chapter in the user's life story
    public struct Chapter: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var title: String
        public var period: TimelinePosition.LifePeriod
        public var startYear: Int?
        public var endYear: Int?
        public var summary: String?
        public var memories: [Memory.Micro]
        public var milestones: [PersonalMilestone.Micro]
        public var themes: [LifeTheme]
        public var growthNotes: String?

        public init(
            id: UUID = UUID(),
            title: String,
            period: TimelinePosition.LifePeriod,
            startYear: Int? = nil,
            endYear: Int? = nil,
            summary: String? = nil,
            memories: [Memory.Micro] = [],
            milestones: [PersonalMilestone.Micro] = [],
            themes: [LifeTheme] = [],
            growthNotes: String? = nil
        ) {
            self.id = id
            self.title = title
            self.period = period
            self.startYear = startYear
            self.endYear = endYear
            self.summary = summary
            self.memories = memories
            self.milestones = milestones
            self.themes = themes
            self.growthNotes = growthNotes
        }
    }

    /// The complete life story
    public struct Story: Codable, Hashable, Sendable {
        public var chapters: [Chapter]
        public var overallThemes: [LifeTheme]
        public var strengthsDiscovered: [String]
        public var healingMilestones: [HealingMilestone]
        public var lastUpdated: Date

        public init(
            chapters: [Chapter] = [],
            overallThemes: [LifeTheme] = [],
            strengthsDiscovered: [String] = [],
            healingMilestones: [HealingMilestone] = [],
            lastUpdated: Date = Date()
        ) {
            self.chapters = chapters
            self.overallThemes = overallThemes
            self.strengthsDiscovered = strengthsDiscovered
            self.healingMilestones = healingMilestones
            self.lastUpdated = lastUpdated
        }

        /// Gaps in the timeline that could be explored
        public var timelineGaps: [TimelineGap] {
            var gaps: [TimelineGap] = []

            // Check for periods without memories
            for period in TimelinePosition.LifePeriod.allCases {
                let hasMemories = chapters.contains { $0.period == period && !$0.memories.isEmpty }
                if !hasMemories {
                    gaps.append(TimelineGap(period: period, type: .noMemories))
                }
            }

            return gaps
        }
    }

    /// A gap in the timeline
    public struct TimelineGap: Codable, Hashable, Sendable {
        public var period: TimelinePosition.LifePeriod
        public var type: GapType
        public var suggestedPrompt: String?

        public init(
            period: TimelinePosition.LifePeriod,
            type: GapType,
            suggestedPrompt: String? = nil
        ) {
            self.period = period
            self.type = type
            self.suggestedPrompt = suggestedPrompt
        }

        public enum GapType: String, Codable, Sendable {
            case noMemories = "no_memories"
            case sparseMemories = "sparse_memories"
            case missingContext = "missing_context"
        }
    }

    /// Healing milestone in the EMDR journey
    public struct HealingMilestone: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var date: Date
        public var type: MilestoneType
        public var description: String
        public var sessionNumber: Int?

        public init(
            id: UUID = UUID(),
            date: Date = Date(),
            type: MilestoneType,
            description: String,
            sessionNumber: Int? = nil
        ) {
            self.id = id
            self.date = date
            self.type = type
            self.description = description
            self.sessionNumber = sessionNumber
        }

        public enum MilestoneType: String, Codable, CaseIterable, Sendable {
            case firstSession = "first_session"
            case breakthroughMoment = "breakthrough"
            case processedMemory = "processed_memory"
            case reducedSymptom = "reduced_symptom"
            case newInsight = "new_insight"
            case completedTarget = "completed_target"
            case sessionMilestone = "session_milestone" // 5, 10, 25 sessions etc.
            case feelingBetter = "feeling_better"

            public var displayName: String {
                switch self {
                case .firstSession: return "First Session"
                case .breakthroughMoment: return "Breakthrough"
                case .processedMemory: return "Memory Processed"
                case .reducedSymptom: return "Symptom Reduced"
                case .newInsight: return "New Insight"
                case .completedTarget: return "Target Completed"
                case .sessionMilestone: return "Session Milestone"
                case .feelingBetter: return "Feeling Better"
                }
            }
        }
    }
}

/// Themes that emerge across life experiences
public enum LifeTheme: String, Codable, CaseIterable, Sendable {
    case resilience = "resilience"
    case survival = "survival"
    case protection = "protection"
    case connection = "connection"
    case loss = "loss"
    case growth = "growth"
    case healing = "healing"
    case strength = "strength"
    case adaptation = "adaptation"
    case transformation = "transformation"

    public var displayName: String {
        rawValue.capitalized
    }

    public var description: String {
        switch self {
        case .resilience:
            return "The ability to bounce back from difficult experiences"
        case .survival:
            return "Finding ways to make it through challenging times"
        case .protection:
            return "Keeping yourself or others safe"
        case .connection:
            return "Relationships and bonds with others"
        case .loss:
            return "Experiences of losing people, places, or parts of yourself"
        case .growth:
            return "Learning and becoming stronger through experiences"
        case .healing:
            return "The process of recovery and repair"
        case .strength:
            return "Inner resources and capabilities"
        case .adaptation:
            return "Adjusting to new circumstances"
        case .transformation:
            return "Fundamental changes in self or life"
        }
    }
}

/// Prompts for exploring timeline gaps
public struct TimelineExplorationPrompts {

    public static func promptsFor(period: TimelinePosition.LifePeriod) -> [String] {
        switch period {
        case .earlyChildhood:
            return [
                "Do you have any early memories from before you started school?",
                "What have family members told you about when you were very young?",
                "Are there any photos from that time that bring up feelings or stories?",
                "Do you remember any places you lived before age 5?"
            ]
        case .childhood:
            return [
                "What do you remember about elementary school?",
                "Who were the important people in your life between ages 6-11?",
                "What was your home life like during those years?",
                "Are there any specific events from childhood that stand out?",
                "What activities or hobbies did you have?"
            ]
        case .adolescence:
            return [
                "What was middle school and high school like for you?",
                "What was happening at home during your teenage years?",
                "Were there any significant friendships or relationships?",
                "What were you interested in as a teenager?",
                "How did you feel about yourself during those years?"
            ]
        case .youngAdult:
            return [
                "What was life like after high school?",
                "Did you go to college or start working?",
                "What were your relationships like in your early 20s?",
                "Where were you living during this time?",
                "What were your hopes and dreams?"
            ]
        case .adult:
            return [
                "What major life changes happened in your late 20s and 30s?",
                "How did your relationships evolve?",
                "What was your career path like?",
                "Were there any significant moves or life events?"
            ]
        case .middleAge:
            return [
                "How did life change in your 40s and 50s?",
                "What perspective shifts did you experience?",
                "How did your family relationships change?",
                "What brought you meaning during this time?"
            ]
        case .laterLife:
            return [
                "What has later life been like?",
                "How have you found meaning and purpose?",
                "What wisdom have you gained?",
                "What relationships are most important now?"
            ]
        }
    }
}

import Foundation

/// Represents a memory that surfaced during or after EMDR therapy
public enum Memory {

    /// Minimal memory info for lists
    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var title: String
        public var createdDate: Date
        public var approximateAge: AgeEstimate?
        public var isContained: Bool // Has this memory been "put in the container"?

        public init(
            id: UUID? = nil,
            title: String = "",
            createdDate: Date = Date(),
            approximateAge: AgeEstimate? = nil,
            isContained: Bool = true
        ) {
            self.id = id
            self.title = title
            self.createdDate = createdDate
            self.approximateAge = approximateAge
            self.isContained = isContained
        }
    }

    /// Full memory data
    public struct Global: Codable, Hashable, Sendable, Identifiable {
        public var id: UUID? { micro.id }
        public var micro: Micro
        public var description: String
        public var emotionsPresent: [EmotionType]
        public var bodyLocations: [BodyLocation] // Where do you feel it in your body?
        public var intensity: Int // 1-10 scale
        public var relatedSessionId: UUID?
        public var relatedMemoryIds: [UUID] // Other memories that connect
        public var location: String? // Where were you living?
        public var peopleInvolved: [String] // Anonymized references
        public var worldEventsAround: [UUID] // WorldEvent references for dating
        public var timelinePosition: TimelinePosition?
        public var hasBeenDiscussedWithTherapist: Bool
        public var flaggedForNextSession: Bool
        public var additionalNotes: String?
        public var lastUpdated: Date

        public init(
            micro: Micro,
            description: String = "",
            emotionsPresent: [EmotionType] = [],
            bodyLocations: [BodyLocation] = [],
            intensity: Int = 5,
            relatedSessionId: UUID? = nil,
            relatedMemoryIds: [UUID] = [],
            location: String? = nil,
            peopleInvolved: [String] = [],
            worldEventsAround: [UUID] = [],
            timelinePosition: TimelinePosition? = nil,
            hasBeenDiscussedWithTherapist: Bool = false,
            flaggedForNextSession: Bool = false,
            additionalNotes: String? = nil,
            lastUpdated: Date = Date()
        ) {
            self.micro = micro
            self.description = description
            self.emotionsPresent = emotionsPresent
            self.bodyLocations = bodyLocations
            self.intensity = intensity
            self.relatedSessionId = relatedSessionId
            self.relatedMemoryIds = relatedMemoryIds
            self.location = location
            self.peopleInvolved = peopleInvolved
            self.worldEventsAround = worldEventsAround
            self.timelinePosition = timelinePosition
            self.hasBeenDiscussedWithTherapist = hasBeenDiscussedWithTherapist
            self.flaggedForNextSession = flaggedForNextSession
            self.additionalNotes = additionalNotes
            self.lastUpdated = lastUpdated
        }
    }

    /// Data for creating a new memory
    public struct CreateData: Codable, Sendable {
        public var title: String
        public var description: String
        public var approximateAge: AgeEstimate?
        public var emotionsPresent: [EmotionType]
        public var intensity: Int
        public var relatedSessionId: UUID?

        public init(
            title: String = "",
            description: String = "",
            approximateAge: AgeEstimate? = nil,
            emotionsPresent: [EmotionType] = [],
            intensity: Int = 5,
            relatedSessionId: UUID? = nil
        ) {
            self.title = title
            self.description = description
            self.approximateAge = approximateAge
            self.emotionsPresent = emotionsPresent
            self.intensity = intensity
            self.relatedSessionId = relatedSessionId
        }
    }
}

/// Estimate of age when memory occurred
public struct AgeEstimate: Codable, Hashable, Sendable {
    public var lowerBound: Int? // Could have been as young as
    public var upperBound: Int? // Could have been as old as
    public var bestGuess: Int? // Most likely age
    public var confidence: Confidence

    public init(
        lowerBound: Int? = nil,
        upperBound: Int? = nil,
        bestGuess: Int? = nil,
        confidence: Confidence = .uncertain
    ) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.bestGuess = bestGuess
        self.confidence = confidence
    }

    public enum Confidence: String, Codable, Sendable {
        case certain = "certain"
        case likely = "likely"
        case uncertain = "uncertain"
        case veryUncertain = "very_uncertain"
    }

    public var displayString: String {
        if let best = bestGuess {
            return "Around age \(best)"
        } else if let lower = lowerBound, let upper = upperBound {
            return "Between ages \(lower) and \(upper)"
        } else if let lower = lowerBound {
            return "Older than \(lower)"
        } else if let upper = upperBound {
            return "Younger than \(upper)"
        }
        return "Age unknown"
    }
}

/// Position in the user's life timeline
public struct TimelinePosition: Codable, Hashable, Sendable {
    public var year: Int?
    public var season: Season?
    public var ageAtTime: AgeEstimate?
    public var lifePeriod: LifePeriod?

    public init(
        year: Int? = nil,
        season: Season? = nil,
        ageAtTime: AgeEstimate? = nil,
        lifePeriod: LifePeriod? = nil
    ) {
        self.year = year
        self.season = season
        self.ageAtTime = ageAtTime
        self.lifePeriod = lifePeriod
    }

    public enum Season: String, Codable, CaseIterable, Sendable {
        case spring, summer, fall, winter
    }

    public enum LifePeriod: String, Codable, CaseIterable, Sendable {
        case earlyChildhood = "early_childhood" // 0-5
        case childhood = "childhood" // 6-11
        case adolescence = "adolescence" // 12-17
        case youngAdult = "young_adult" // 18-25
        case adult = "adult" // 26-40
        case middleAge = "middle_age" // 41-60
        case laterLife = "later_life" // 61+

        public var displayName: String {
            switch self {
            case .earlyChildhood: return "Early Childhood (0-5)"
            case .childhood: return "Childhood (6-11)"
            case .adolescence: return "Adolescence (12-17)"
            case .youngAdult: return "Young Adult (18-25)"
            case .adult: return "Adulthood (26-40)"
            case .middleAge: return "Middle Age (41-60)"
            case .laterLife: return "Later Life (61+)"
            }
        }
    }
}

/// Types of emotions that might be present in a memory
public enum EmotionType: String, Codable, CaseIterable, Sendable {
    case fear = "fear"
    case anger = "anger"
    case sadness = "sadness"
    case shame = "shame"
    case guilt = "guilt"
    case helplessness = "helplessness"
    case confusion = "confusion"
    case betrayal = "betrayal"
    case abandonment = "abandonment"
    case loneliness = "loneliness"
    case terror = "terror"
    case grief = "grief"
    case love = "love"
    case joy = "joy"
    case relief = "relief"
    case safety = "safety"
    case pride = "pride"
    case hope = "hope"

    public var displayName: String {
        rawValue.capitalized
    }

    public var isPositive: Bool {
        switch self {
        case .love, .joy, .relief, .safety, .pride, .hope:
            return true
        default:
            return false
        }
    }
}

/// Body locations where trauma might be felt
public enum BodyLocation: String, Codable, CaseIterable, Sendable {
    case head = "head"
    case throat = "throat"
    case chest = "chest"
    case stomach = "stomach"
    case shoulders = "shoulders"
    case back = "back"
    case arms = "arms"
    case hands = "hands"
    case legs = "legs"
    case feet = "feet"
    case wholeBody = "whole_body"

    public var displayName: String {
        switch self {
        case .wholeBody: return "Whole Body"
        default: return rawValue.capitalized
        }
    }
}

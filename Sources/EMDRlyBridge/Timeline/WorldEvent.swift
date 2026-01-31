import Foundation

/// World events used to help users date their memories
public enum WorldEvent {

    /// Minimal event info
    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var name: String
        public var year: Int
        public var month: Int?
        public var category: EventCategory

        public init(
            id: UUID? = nil,
            name: String,
            year: Int,
            month: Int? = nil,
            category: EventCategory = .cultural
        ) {
            self.id = id
            self.name = name
            self.year = year
            self.month = month
            self.category = category
        }
    }

    /// Full event with additional context
    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var description: String?
        public var endYear: Int? // For ongoing events
        public var region: String? // Geographic relevance
        public var agePrompt: String // "Were you in school when this happened?"

        public init(
            micro: Micro,
            description: String? = nil,
            endYear: Int? = nil,
            region: String? = nil,
            agePrompt: String = ""
        ) {
            self.micro = micro
            self.description = description
            self.endYear = endYear
            self.region = region
            self.agePrompt = agePrompt
        }
    }
}

/// Categories of world events
public enum EventCategory: String, Codable, CaseIterable, Sendable {
    case cultural = "cultural" // Movies, music, TV shows
    case political = "political" // Elections, major political events
    case disaster = "disaster" // Natural disasters, major accidents
    case technology = "technology" // Tech launches, internet milestones
    case sports = "sports" // Major sporting events
    case social = "social" // Social movements, cultural shifts
    case personal = "personal" // User-added personal milestones

    public var displayName: String {
        rawValue.capitalized
    }
}

/// Built-in world events database for reference
public struct WorldEventsDatabase {

    /// Sample events - in production this would be a much larger curated database
    public static var events: [WorldEvent.Global] {
        [
            // 1980s
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "MTV Launched", year: 1981, month: 8, category: .cultural),
                description: "Music Television began broadcasting",
                agePrompt: "Do you remember when MTV first came on? Were you watching music videos?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Space Shuttle Challenger", year: 1986, month: 1, category: .disaster),
                description: "Space Shuttle Challenger disaster",
                agePrompt: "Were you in school when the Challenger exploded? Many people remember watching it in class."
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Berlin Wall Falls", year: 1989, month: 11, category: .political),
                description: "The Berlin Wall came down",
                agePrompt: "Do you remember seeing the Berlin Wall come down on TV?"
            ),

            // 1990s
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Gulf War Begins", year: 1991, month: 1, category: .political),
                description: "Operation Desert Storm",
                agePrompt: "Do you remember the Gulf War coverage on TV?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "OJ Simpson Trial", year: 1995, category: .cultural),
                description: "OJ Simpson murder trial verdict",
                agePrompt: "Were you watching when the OJ verdict was announced?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Princess Diana Dies", year: 1997, month: 8, category: .cultural),
                description: "Princess Diana died in Paris car crash",
                agePrompt: "Do you remember when Princess Diana died? Where were you?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Columbine", year: 1999, month: 4, category: .disaster),
                description: "Columbine High School shooting",
                agePrompt: "Were you in school during Columbine? How did it affect your school?"
            ),

            // 2000s
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Y2K", year: 2000, month: 1, category: .technology),
                description: "Y2K New Year's Eve",
                agePrompt: "Do you remember Y2K? Were people worried about computers failing?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "September 11", year: 2001, month: 9, category: .disaster),
                description: "September 11 terrorist attacks",
                agePrompt: "Where were you on September 11, 2001? Most people remember exactly where they were."
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Hurricane Katrina", year: 2005, month: 8, category: .disaster),
                description: "Hurricane Katrina devastates Gulf Coast",
                agePrompt: "Do you remember Hurricane Katrina? Were you or anyone you know affected?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "iPhone Released", year: 2007, month: 6, category: .technology),
                description: "First iPhone released",
                agePrompt: "Do you remember when the first iPhone came out? Did you or anyone you know get one?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Obama Elected", year: 2008, month: 11, category: .political),
                description: "Barack Obama elected president",
                agePrompt: "Were you old enough to vote when Obama was first elected? Do you remember that night?"
            ),

            // 2010s
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Sandy Hook", year: 2012, month: 12, category: .disaster),
                description: "Sandy Hook Elementary School shooting",
                agePrompt: "Do you remember Sandy Hook? How did it affect you?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Marriage Equality", year: 2015, month: 6, category: .social),
                description: "Same-sex marriage legalized nationwide",
                agePrompt: "Do you remember when marriage equality passed? What was that time like for you?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "Trump Elected", year: 2016, month: 11, category: .political),
                description: "Donald Trump elected president",
                agePrompt: "Do you remember the 2016 election? How did you feel about the result?"
            ),

            // 2020s
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "COVID-19 Pandemic", year: 2020, month: 3, category: .disaster),
                description: "COVID-19 pandemic begins, lockdowns start",
                endYear: 2023,
                agePrompt: "Where were you when the pandemic started? What was lockdown like for you?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "George Floyd Protests", year: 2020, month: 5, category: .social),
                description: "George Floyd killed, nationwide protests",
                agePrompt: "Do you remember the summer of 2020? Were you involved in any protests?"
            ),
            WorldEvent.Global(
                micro: WorldEvent.Micro(name: "January 6", year: 2021, month: 1, category: .political),
                description: "Capitol building stormed",
                agePrompt: "Were you watching the news on January 6th? How did you feel?"
            ),
        ]
    }

    /// Get events near a specific year
    public static func eventsAround(year: Int, range: Int = 2) -> [WorldEvent.Global] {
        events.filter { event in
            abs(event.micro.year - year) <= range
        }
    }

    /// Get events for a life period based on birth year
    public static func eventsForLifePeriod(_ period: TimelinePosition.LifePeriod, birthYear: Int) -> [WorldEvent.Global] {
        let ageRange: ClosedRange<Int>
        switch period {
        case .earlyChildhood: ageRange = 0...5
        case .childhood: ageRange = 6...11
        case .adolescence: ageRange = 12...17
        case .youngAdult: ageRange = 18...25
        case .adult: ageRange = 26...40
        case .middleAge: ageRange = 41...60
        case .laterLife: ageRange = 61...100
        }

        let yearRange = (birthYear + ageRange.lowerBound)...(birthYear + ageRange.upperBound)

        return events.filter { yearRange.contains($0.micro.year) }
    }
}

/// User's personal timeline events
public enum PersonalMilestone {

    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var name: String
        public var year: Int
        public var month: Int?
        public var type: MilestoneType

        public init(
            id: UUID? = nil,
            name: String,
            year: Int,
            month: Int? = nil,
            type: MilestoneType = .other
        ) {
            self.id = id
            self.name = name
            self.year = year
            self.month = month
            self.type = type
        }
    }

    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var ageAtTime: Int?
        public var notes: String?
        public var relatedMemoryIds: [UUID]

        public init(
            micro: Micro,
            ageAtTime: Int? = nil,
            notes: String? = nil,
            relatedMemoryIds: [UUID] = []
        ) {
            self.micro = micro
            self.ageAtTime = ageAtTime
            self.notes = notes
            self.relatedMemoryIds = relatedMemoryIds
        }
    }

    public enum MilestoneType: String, Codable, CaseIterable, Sendable {
        case birth = "birth"
        case school = "school"
        case graduation = "graduation"
        case move = "move"
        case marriage = "marriage"
        case divorce = "divorce"
        case childBorn = "child_born"
        case jobChange = "job_change"
        case loss = "loss"
        case medical = "medical"
        case other = "other"

        public var displayName: String {
            switch self {
            case .birth: return "Birth"
            case .school: return "Started school"
            case .graduation: return "Graduation"
            case .move: return "Moved"
            case .marriage: return "Marriage"
            case .divorce: return "Divorce"
            case .childBorn: return "Child born"
            case .jobChange: return "Job change"
            case .loss: return "Loss"
            case .medical: return "Medical event"
            case .other: return "Other"
            }
        }
    }
}

import Foundation

/// Represents a dream recorded by the user
public enum Dream {

    /// Minimal dream info for lists
    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var title: String
        public var date: Date
        public var intensity: DreamIntensity
        public var wasNightmare: Bool

        public init(
            id: UUID? = nil,
            title: String = "",
            date: Date = Date(),
            intensity: DreamIntensity = .moderate,
            wasNightmare: Bool = false
        ) {
            self.id = id
            self.title = title
            self.date = date
            self.intensity = intensity
            self.wasNightmare = wasNightmare
        }
    }

    /// Full dream data with interpretation
    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var description: String
        public var emotionsPresent: [EmotionType]
        public var themes: [DreamTheme]
        public var recurringElements: [String]
        public var relatedMemoryIds: [UUID]
        public var relatedSessionId: UUID?
        public var aiInterpretation: String?
        public var userReflection: String?
        public var flaggedForTherapist: Bool
        public var lastUpdated: Date

        public init(
            micro: Micro,
            description: String = "",
            emotionsPresent: [EmotionType] = [],
            themes: [DreamTheme] = [],
            recurringElements: [String] = [],
            relatedMemoryIds: [UUID] = [],
            relatedSessionId: UUID? = nil,
            aiInterpretation: String? = nil,
            userReflection: String? = nil,
            flaggedForTherapist: Bool = false,
            lastUpdated: Date = Date()
        ) {
            self.micro = micro
            self.description = description
            self.emotionsPresent = emotionsPresent
            self.themes = themes
            self.recurringElements = recurringElements
            self.relatedMemoryIds = relatedMemoryIds
            self.relatedSessionId = relatedSessionId
            self.aiInterpretation = aiInterpretation
            self.userReflection = userReflection
            self.flaggedForTherapist = flaggedForTherapist
            self.lastUpdated = lastUpdated
        }
    }

    /// Data for creating a new dream entry
    public struct CreateData: Codable, Sendable {
        public var title: String
        public var description: String
        public var date: Date
        public var intensity: DreamIntensity
        public var wasNightmare: Bool
        public var emotionsPresent: [EmotionType]

        public init(
            title: String = "",
            description: String = "",
            date: Date = Date(),
            intensity: DreamIntensity = .moderate,
            wasNightmare: Bool = false,
            emotionsPresent: [EmotionType] = []
        ) {
            self.title = title
            self.description = description
            self.date = date
            self.intensity = intensity
            self.wasNightmare = wasNightmare
            self.emotionsPresent = emotionsPresent
        }
    }
}

/// How vivid/intense the dream was
public enum DreamIntensity: String, Codable, CaseIterable, Sendable {
    case mild = "mild"
    case moderate = "moderate"
    case vivid = "vivid"
    case extremelyVivid = "extremely_vivid"

    public var displayName: String {
        switch self {
        case .mild: return "Mild - Faint images"
        case .moderate: return "Moderate - Clear but normal"
        case .vivid: return "Vivid - Very clear and detailed"
        case .extremelyVivid: return "Extremely Vivid - Felt completely real"
        }
    }
}

/// Common themes that appear in dreams during EMDR processing
public enum DreamTheme: String, Codable, CaseIterable, Sendable {
    case beingChased = "being_chased"
    case falling = "falling"
    case flying = "flying"
    case water = "water"
    case fire = "fire"
    case death = "death"
    case lostOrTrapped = "lost_or_trapped"
    case beingAttacked = "being_attacked"
    case publicNakedness = "public_nakedness"
    case teethFalling = "teeth_falling"
    case unableToMove = "unable_to_move"
    case unableToSpeak = "unable_to_speak"
    case protectingSomeone = "protecting_someone"
    case beingProtected = "being_protected"
    case reunionWithLoved = "reunion_with_loved"
    case confrontingAbuser = "confronting_abuser"
    case escaping = "escaping"
    case findingSafety = "finding_safety"
    case transformation = "transformation"
    case healing = "healing"
    case childhoodHome = "childhood_home"
    case school = "school"
    case workplace = "workplace"
    case familyMembers = "family_members"
    case other = "other"

    public var displayName: String {
        switch self {
        case .beingChased: return "Being chased"
        case .falling: return "Falling"
        case .flying: return "Flying"
        case .water: return "Water"
        case .fire: return "Fire"
        case .death: return "Death"
        case .lostOrTrapped: return "Lost or trapped"
        case .beingAttacked: return "Being attacked"
        case .publicNakedness: return "Public nakedness"
        case .teethFalling: return "Teeth falling out"
        case .unableToMove: return "Unable to move"
        case .unableToSpeak: return "Unable to speak"
        case .protectingSomeone: return "Protecting someone"
        case .beingProtected: return "Being protected"
        case .reunionWithLoved: return "Reunion with loved ones"
        case .confrontingAbuser: return "Confronting abuser"
        case .escaping: return "Escaping"
        case .findingSafety: return "Finding safety"
        case .transformation: return "Transformation"
        case .healing: return "Healing"
        case .childhoodHome: return "Childhood home"
        case .school: return "School"
        case .workplace: return "Workplace"
        case .familyMembers: return "Family members"
        case .other: return "Other"
        }
    }

    public var processingSignificance: String {
        switch self {
        case .beingChased:
            return "Often represents avoidance of difficult emotions or memories. Your mind may be processing something you've been running from."
        case .falling:
            return "Can indicate feelings of loss of control or anxiety. During EMDR, this may relate to processing moments when you felt powerless."
        case .flying:
            return "Often represents freedom, empowerment, or escape. This can be a positive sign of processing and gaining new perspectives."
        case .water:
            return "Water often represents emotions. Clear water may indicate clarity; turbulent water may represent emotional processing in progress."
        case .fire:
            return "Can represent transformation, anger, or destruction. Your mind may be processing intense emotions or significant changes."
        case .death:
            return "Often represents endings and new beginnings rather than literal death. May indicate processing of major life changes or losses."
        case .lostOrTrapped:
            return "May relate to feeling stuck in your healing journey or processing memories where you felt trapped."
        case .beingAttacked:
            return "Your mind may be processing traumatic experiences. This is common during EMDR and often decreases as processing continues."
        case .unableToMove, .unableToSpeak:
            return "Often connects to moments of helplessness or times when you couldn't protect yourself. Processing these feelings is important."
        case .protectingSomeone:
            return "May represent your strength and protective instincts, or processing times when you wished you could have protected yourself or others."
        case .beingProtected:
            return "A positive sign - your mind may be integrating feelings of safety and support into your healing."
        case .confrontingAbuser:
            return "This can be part of healthy processing, allowing your mind to work through unfinished business in a safe way."
        case .escaping, .findingSafety:
            return "Positive processing signs - your mind is working toward resolution and safety."
        case .transformation, .healing:
            return "Wonderful signs that your mind is integrating your healing work. These often increase as EMDR progresses."
        case .childhoodHome:
            return "Your mind may be processing memories from that time. Notice what felt familiar or different in the dream."
        default:
            return "Dreams during EMDR are often more vivid as your brain processes difficult material. This is normal and usually decreases over time."
        }
    }
}

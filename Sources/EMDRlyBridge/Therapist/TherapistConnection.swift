import Foundation

public typealias TherapistSharingPreferences = TherapistConnection.SharingPreferences

public enum TherapistConnection {

    public typealias EncouragementType = Encouragement.EncouragementType
    public typealias FlaggedItemType = FlaggedItem.ItemType

    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var displayName: String
        public var isConnected: Bool
        public var connectionCode: String?

        public init(
            id: UUID? = nil,
            displayName: String = "My Therapist",
            isConnected: Bool = false,
            connectionCode: String? = nil
        ) {
            self.id = id
            self.displayName = displayName
            self.isConnected = isConnected
            self.connectionCode = connectionCode
        }
    }

    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var canSendEncouragement: Bool
        public var canViewMetrics: Bool
        public var lastActive: Date?
        public var sharingPreferences: SharingPreferences

        public init(
            micro: Micro,
            canSendEncouragement: Bool = true,
            canViewMetrics: Bool = true,
            lastActive: Date? = nil,
            sharingPreferences: SharingPreferences = .full
        ) {
            self.micro = micro
            self.canSendEncouragement = canSendEncouragement
            self.canViewMetrics = canViewMetrics
            self.lastActive = lastActive
            self.sharingPreferences = sharingPreferences
        }
    }

    public struct CreateData: Codable, Hashable, Sendable {
        public var displayName: String
        public var connectionCode: String

        public init(displayName: String, connectionCode: String) {
            self.displayName = displayName
            self.connectionCode = connectionCode
        }
    }

    public struct SharingPreferences: Codable, Hashable, Sendable {
        public var shareSessionMetrics: Bool
        public var shareMemoryCount: Bool
        public var shareDreamCount: Bool
        public var shareCrisisEvents: Bool
        public var shareFeelingTrends: Bool
        public var allowEncouragements: Bool
        public var allowTherapistContact: Bool

        public init(
            shareSessionMetrics: Bool = true,
            shareMemoryCount: Bool = true,
            shareDreamCount: Bool = true,
            shareCrisisEvents: Bool = true,
            shareFeelingTrends: Bool = true,
            allowEncouragements: Bool = true,
            allowTherapistContact: Bool = true
        ) {
            self.shareSessionMetrics = shareSessionMetrics
            self.shareMemoryCount = shareMemoryCount
            self.shareDreamCount = shareDreamCount
            self.shareCrisisEvents = shareCrisisEvents
            self.shareFeelingTrends = shareFeelingTrends
            self.allowEncouragements = allowEncouragements
            self.allowTherapistContact = allowTherapistContact
        }

        public static var minimal: SharingPreferences {
            SharingPreferences(
                shareSessionMetrics: false,
                shareMemoryCount: false,
                shareDreamCount: false,
                shareCrisisEvents: true,
                shareFeelingTrends: false,
                allowEncouragements: true,
                allowTherapistContact: true
            )
        }

        public static var full: SharingPreferences {
            SharingPreferences()
        }
    }
}

public enum ClientMetrics {

    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID?
        public var clientCode: String
        public var sessionCount: Int
        public var lastSessionDate: Date?

        public init(
            id: UUID? = nil,
            clientCode: String,
            sessionCount: Int = 0,
            lastSessionDate: Date? = nil
        ) {
            self.id = id
            self.clientCode = clientCode
            self.sessionCount = sessionCount
            self.lastSessionDate = lastSessionDate
        }
    }

    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var averagePostSessionFeeling: FeelingLevel?
        public var averageFatigueLevel: FatigueLevel?
        public var memoriesLogged: Int
        public var dreamsLogged: Int
        public var crisisEventsCount: Int
        public var checkInCompletionRate: Double
        public var flaggedForDiscussion: [FlaggedItem.Global]
        public var recentTrend: Trend

        public init(
            micro: Micro,
            averagePostSessionFeeling: FeelingLevel? = nil,
            averageFatigueLevel: FatigueLevel? = nil,
            memoriesLogged: Int = 0,
            dreamsLogged: Int = 0,
            crisisEventsCount: Int = 0,
            checkInCompletionRate: Double = 0,
            flaggedForDiscussion: [FlaggedItem.Global] = [],
            recentTrend: Trend = .stable
        ) {
            self.micro = micro
            self.averagePostSessionFeeling = averagePostSessionFeeling
            self.averageFatigueLevel = averageFatigueLevel
            self.memoriesLogged = memoriesLogged
            self.dreamsLogged = dreamsLogged
            self.crisisEventsCount = crisisEventsCount
            self.checkInCompletionRate = checkInCompletionRate
            self.flaggedForDiscussion = flaggedForDiscussion
            self.recentTrend = recentTrend
        }
    }

    public enum Trend: String, Codable, CaseIterable, Sendable {
        case improving = "improving"
        case stable = "stable"
        case declining = "declining"
        case variable = "variable"

        public var displayName: String {
            rawValue.capitalized
        }
    }
}

public enum FlaggedItem {

    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var type: ItemType
        public var title: String
        public var dateLogged: Date

        public init(
            id: UUID = UUID(),
            type: ItemType,
            title: String,
            dateLogged: Date = Date()
        ) {
            self.id = id
            self.type = type
            self.title = title
            self.dateLogged = dateLogged
        }
    }

    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var clientNotes: String?
        public var therapistViewed: Bool
        public var therapistAcknowledged: Bool

        public init(
            micro: Micro,
            clientNotes: String? = nil,
            therapistViewed: Bool = false,
            therapistAcknowledged: Bool = false
        ) {
            self.micro = micro
            self.clientNotes = clientNotes
            self.therapistViewed = therapistViewed
            self.therapistAcknowledged = therapistAcknowledged
        }
    }

    public struct CreateData: Codable, Hashable, Sendable {
        public var type: ItemType
        public var title: String
        public var clientNotes: String?

        public init(type: ItemType, title: String, clientNotes: String? = nil) {
            self.type = type
            self.title = title
            self.clientNotes = clientNotes
        }
    }

    public enum ItemType: String, Codable, CaseIterable, Sendable {
        case memory = "memory"
        case dream = "dream"
        case feeling = "feeling"
        case question = "question"
        case concern = "concern"

        public var displayName: String {
            rawValue.capitalized
        }
    }
}

public enum Encouragement {

    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var type: EncouragementType
        public var timestamp: Date
        public var seen: Bool

        public init(
            id: UUID = UUID(),
            type: EncouragementType,
            timestamp: Date = Date(),
            seen: Bool = false
        ) {
            self.id = id
            self.type = type
            self.timestamp = timestamp
            self.seen = seen
        }
    }

    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var message: String?

        public init(micro: Micro, message: String? = nil) {
            self.micro = micro
            self.message = message
        }
    }

    public struct CreateData: Codable, Hashable, Sendable {
        public var type: EncouragementType
        public var message: String?

        public init(type: EncouragementType, message: String? = nil) {
            self.type = type
            self.message = message
        }
    }

    public enum EncouragementType: String, Codable, CaseIterable, Sendable {
        case hug = "hug"
        case like = "like"
        case proud = "proud"
        case thinking = "thinking"
        case support = "support"
        case custom = "custom"

        public var displayName: String {
            switch self {
            case .hug: return "Sending a hug"
            case .like: return "Liked your entry"
            case .proud: return "Proud of you"
            case .thinking: return "Thinking of you"
            case .support: return "Here for you"
            case .custom: return "Message"
            }
        }

        public var symbolName: String {
            switch self {
            case .hug: return "hands.clap.fill"
            case .like: return "heart.fill"
            case .proud: return "star.fill"
            case .thinking: return "bubble.left.fill"
            case .support: return "person.2.fill"
            case .custom: return "text.bubble.fill"
            }
        }
    }
}

public enum BuzzerDevice {

    public enum Model: String, Codable, CaseIterable, Sendable {
        case standardTac = "standard_tac"
        case advancedTac = "advanced_tac"
        case deluxeTac = "deluxe_tac"
        case deluxeTacMusic = "deluxe_tac_music"

        public var displayName: String {
            switch self {
            case .standardTac: return "Standard Tac/AudioScan"
            case .advancedTac: return "Advanced Tac/AudioScan"
            case .deluxeTac: return "Deluxe Tac/AudioScan"
            case .deluxeTacMusic: return "Deluxe Tac/AudioScan with Music"
            }
        }

        public var hasMusic: Bool {
            self == .deluxeTacMusic
        }

        public var maxSpeed: Int {
            switch self {
            case .standardTac: return 15
            default: return 20
            }
        }
    }

    public enum SoundType: String, Codable, CaseIterable, Sendable {
        case tone = "tone"
        case click = "click"
        case doubleClick = "double_click"
        case arcade = "arcade"
        case externalMusic = "external_music"

        public var displayName: String {
            switch self {
            case .tone: return "Tone"
            case .click: return "Click"
            case .doubleClick: return "Double Click"
            case .arcade: return "Arcade"
            case .externalMusic: return "External Music"
            }
        }
    }

    public enum PulserType: String, Codable, CaseIterable, Sendable {
        case smallTactile = "small_tactile"
        case largeTactile = "large_tactile"
        case led = "led"
        case wireless = "wireless"

        public var displayName: String {
            switch self {
            case .smallTactile: return "Small Tactile Pulsers"
            case .largeTactile: return "Large Tactile Pulsers"
            case .led: return "LED Light Bar"
            case .wireless: return "Wireless Pulsers"
            }
        }
    }

    public struct Settings: Codable, Hashable, Sendable {
        public var deviceModel: Model
        public var speed: Int
        public var volume: Int
        public var tactileIntensity: Int
        public var soundType: SoundType
        public var pulserType: PulserType

        public init(
            deviceModel: Model = .standardTac,
            speed: Int = 10,
            volume: Int = 10,
            tactileIntensity: Int = 10,
            soundType: SoundType = .tone,
            pulserType: PulserType = .smallTactile
        ) {
            self.deviceModel = deviceModel
            self.speed = min(max(speed, 1), deviceModel.maxSpeed)
            self.volume = min(max(volume, 1), 20)
            self.tactileIntensity = min(max(tactileIntensity, 1), 20)
            self.soundType = soundType
            self.pulserType = pulserType
        }

        public static var `default`: Settings {
            Settings()
        }

        // MARK: - Clinical Display Helpers

        /// Clinical speed label as practitioners document in session notes
        /// Slow (1-7): ~1.1-1.7s between pulses, used for Safe Place/RDI
        /// Medium (8-13): ~0.8-1.1s between pulses
        /// Fast (14-20): ~0.5-0.8s between pulses, used for reprocessing
        public var speedLabel: String {
            switch speed {
            case 1...7: return "Slow"
            case 8...13: return "Medium"
            default: return "Fast"
            }
        }

        /// Approximate seconds between pulses, derived from device speed setting
        public var secondsBetweenPulses: Double {
            // Maps 1-20 to approximately 1.7s - 0.5s
            let normalized = Double(speed - 1) / 19.0
            return 1.7 - (normalized * 1.2)
        }

        /// Clinical intensity label as practitioners document in session notes
        public var intensityLabel: String {
            switch tactileIntensity {
            case 1...7: return "Low"
            case 8...13: return "Medium"
            default: return "High"
            }
        }

        /// Clinical volume label as practitioners document in session notes
        public var volumeLabel: String {
            switch volume {
            case 1...7: return "Low"
            case 8...13: return "Medium"
            default: return "High"
            }
        }

        /// Approximate passes per set for a given set duration in seconds
        public func passesPerSet(setDuration: Int) -> Int {
            guard secondsBetweenPulses > 0 else { return 0 }
            return Int(Double(setDuration) / secondsBetweenPulses)
        }

        /// Clinical summary as practitioners would write in session notes
        /// e.g. "Tactile (Small Pulsers), Fast speed (~0.7s), Medium intensity, ~30 passes/set"
        public func clinicalSummary(setDuration: Int = 30) -> String {
            let passes = passesPerSet(setDuration: setDuration)
            return "\(pulserType.displayName), \(speedLabel) speed (~\(String(format: "%.1f", secondsBetweenPulses))s), \(intensityLabel) intensity, ~\(passes) passes/\(setDuration)s set"
        }
    }
}

public enum BuzzerSession {

    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var sessionId: UUID?
        public var sessionDate: Date
        public var bilateralSets: Int
        public var durationSeconds: Int

        public init(
            id: UUID = UUID(),
            sessionId: UUID? = nil,
            sessionDate: Date = Date(),
            bilateralSets: Int = 0,
            durationSeconds: Int = 0
        ) {
            self.id = id
            self.sessionId = sessionId
            self.sessionDate = sessionDate
            self.bilateralSets = bilateralSets
            self.durationSeconds = durationSeconds
        }

        public var durationFormatted: String {
            let minutes = durationSeconds / 60
            let seconds = durationSeconds % 60
            if minutes > 0 {
                return "\(minutes)m \(seconds)s"
            }
            return "\(seconds)s"
        }
    }

    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var settings: BuzzerDevice.Settings
        public var notes: String?
        public var createdDate: Date

        public init(
            micro: Micro,
            settings: BuzzerDevice.Settings = .default,
            notes: String? = nil,
            createdDate: Date = Date()
        ) {
            self.micro = micro
            self.settings = settings
            self.notes = notes
            self.createdDate = createdDate
        }
    }

    public struct CreateData: Codable, Hashable, Sendable {
        public var sessionId: UUID?
        public var settings: BuzzerDevice.Settings
        public var notes: String?

        public init(
            sessionId: UUID? = nil,
            settings: BuzzerDevice.Settings = .default,
            notes: String? = nil
        ) {
            self.sessionId = sessionId
            self.settings = settings
            self.notes = notes
        }
    }
}

public enum CrisisAlert {

    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var clientCode: String
        public var severity: Severity
        public var notificationSentAt: Date

        public init(
            id: UUID = UUID(),
            clientCode: String,
            severity: Severity,
            notificationSentAt: Date = Date()
        ) {
            self.id = id
            self.clientCode = clientCode
            self.severity = severity
            self.notificationSentAt = notificationSentAt
        }

        public var isViewed: Bool { false }
        public var isResolved: Bool { false }
    }

    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var triggerReason: String
        public var checkInId: UUID?
        public var viewedAt: Date?
        public var resolvedAt: Date?
        public var resolutionNotes: String?

        public init(
            micro: Micro,
            triggerReason: String,
            checkInId: UUID? = nil,
            viewedAt: Date? = nil,
            resolvedAt: Date? = nil,
            resolutionNotes: String? = nil
        ) {
            self.micro = micro
            self.triggerReason = triggerReason
            self.checkInId = checkInId
            self.viewedAt = viewedAt
            self.resolvedAt = resolvedAt
            self.resolutionNotes = resolutionNotes
        }

        public var isViewed: Bool {
            viewedAt != nil
        }

        public var isResolved: Bool {
            resolvedAt != nil
        }
    }

    public struct CreateData: Codable, Hashable, Sendable {
        public var clientCode: String
        public var severity: Severity
        public var triggerReason: String
        public var checkInId: UUID?

        public init(
            clientCode: String,
            severity: Severity,
            triggerReason: String,
            checkInId: UUID? = nil
        ) {
            self.clientCode = clientCode
            self.severity = severity
            self.triggerReason = triggerReason
            self.checkInId = checkInId
        }
    }

    public enum Severity: String, Codable, CaseIterable, Sendable {
        case low = "low"
        case moderate = "moderate"
        case high = "high"
        case severe = "severe"
        case critical = "critical"

        public var displayName: String {
            rawValue.capitalized
        }

        public var color: String {
            switch self {
            case .low: return "green"
            case .moderate: return "yellow"
            case .high: return "orange"
            case .severe: return "orange"
            case .critical: return "red"
            }
        }
    }
}

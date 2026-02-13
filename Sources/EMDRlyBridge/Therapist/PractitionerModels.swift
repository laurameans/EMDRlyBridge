import Foundation

// MARK: - Client Status

public enum ClientStatus: String, Codable, CaseIterable, Sendable {
    case active = "active"
    case inactive = "inactive"
    case newClient = "new_client"
    case discharged = "discharged"

    public var displayName: String {
        switch self {
        case .active: return "Active"
        case .inactive: return "Inactive"
        case .newClient: return "New Client"
        case .discharged: return "Discharged"
        }
    }
}

// MARK: - Practitioner Client

public enum PractitionerClient {

    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var user: User.Micro
        public var clientCode: String
        public var status: ClientStatus
        public var currentPhase: Int
        public var hasCrisisAlert: Bool

        public init(
            id: UUID = UUID(),
            user: User.Micro,
            clientCode: String,
            status: ClientStatus = .active,
            currentPhase: Int = 1,
            hasCrisisAlert: Bool = false
        ) {
            self.id = id
            self.user = user
            self.clientCode = clientCode
            self.status = status
            self.currentPhase = min(max(currentPhase, 1), 8)
            self.hasCrisisAlert = hasCrisisAlert
        }
    }

    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var metrics: ClientMetrics.Global
        public var buzzerSettings: BuzzerDevice.Settings
        public var safePlaceCueWord: String?
        public var safePlaceDescription: String?
        public var containerDescription: String?
        public var sudScore: Int?
        public var vocScore: Int?
        public var lastCheckIn: Date?
        public var newMemories: Int
        public var newDreams: Int

        public init(
            micro: Micro,
            metrics: ClientMetrics.Global,
            buzzerSettings: BuzzerDevice.Settings = .default,
            safePlaceCueWord: String? = nil,
            safePlaceDescription: String? = nil,
            containerDescription: String? = nil,
            sudScore: Int? = nil,
            vocScore: Int? = nil,
            lastCheckIn: Date? = nil,
            newMemories: Int = 0,
            newDreams: Int = 0
        ) {
            self.micro = micro
            self.metrics = metrics
            self.buzzerSettings = buzzerSettings
            self.safePlaceCueWord = safePlaceCueWord
            self.safePlaceDescription = safePlaceDescription
            self.containerDescription = containerDescription
            self.sudScore = sudScore
            self.vocScore = vocScore
            self.lastCheckIn = lastCheckIn
            self.newMemories = newMemories
            self.newDreams = newDreams
        }
    }
}

// MARK: - Targeting Sequence

public enum TargetingSequence {

    public enum TargetStatus: String, Codable, CaseIterable, Sendable {
        case pending = "pending"
        case inProgress = "in_progress"
        case complete = "complete"

        public var displayName: String {
            rawValue.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }

    public enum TargetProng: String, Codable, CaseIterable, Sendable {
        case past = "past"
        case present = "present"
        case future = "future"

        public var displayName: String {
            rawValue.capitalized
        }
    }

    public struct Target: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var orderIndex: Int
        public var prong: TargetProng
        public var description: String
        public var ageAtEvent: Int?
        public var negativeCognition: String
        public var positiveCognition: String
        public var cognitionCategory: String?
        public var sudScore: Int
        public var vocScore: Int
        public var status: TargetStatus
        public var completedDate: Date?

        public init(
            id: UUID = UUID(),
            orderIndex: Int,
            prong: TargetProng,
            description: String,
            ageAtEvent: Int? = nil,
            negativeCognition: String,
            positiveCognition: String,
            cognitionCategory: String? = nil,
            sudScore: Int = 0,
            vocScore: Int = 1,
            status: TargetStatus = .pending,
            completedDate: Date? = nil
        ) {
            self.id = id
            self.orderIndex = orderIndex
            self.prong = prong
            self.description = description
            self.ageAtEvent = ageAtEvent
            self.negativeCognition = negativeCognition
            self.positiveCognition = positiveCognition
            self.cognitionCategory = cognitionCategory
            self.sudScore = min(max(sudScore, 0), 10)
            self.vocScore = min(max(vocScore, 1), 7)
            self.status = status
            self.completedDate = completedDate
        }
    }

    public struct Plan: Codable, Hashable, Sendable {
        public var id: UUID
        public var clientCode: String
        public var targets: [Target]
        public var lastUpdated: Date

        public init(
            id: UUID = UUID(),
            clientCode: String,
            targets: [Target] = [],
            lastUpdated: Date = Date()
        ) {
            self.id = id
            self.clientCode = clientCode
            self.targets = targets
            self.lastUpdated = lastUpdated
        }

        public var pastTargets: [Target] {
            targets.filter { $0.prong == .past }.sorted { $0.orderIndex < $1.orderIndex }
        }

        public var presentTargets: [Target] {
            targets.filter { $0.prong == .present }.sorted { $0.orderIndex < $1.orderIndex }
        }

        public var futureTargets: [Target] {
            targets.filter { $0.prong == .future }.sorted { $0.orderIndex < $1.orderIndex }
        }
    }
}

// MARK: - RDI Resource

public enum RDIResource {

    public enum ResourceType: String, Codable, CaseIterable, Sendable {
        case safePlace = "safe_place"
        case container = "container"
        case nurturingFigure = "nurturing_figure"
        case protectiveFigure = "protective_figure"
        case confidence = "confidence"
        case calmPlace = "calm_place"
        case custom = "custom"

        public var displayName: String {
            switch self {
            case .safePlace: return "Safe Place"
            case .container: return "Container"
            case .nurturingFigure: return "Nurturing Figure"
            case .protectiveFigure: return "Protective Figure"
            case .confidence: return "Confidence"
            case .calmPlace: return "Calm Place"
            case .custom: return "Custom"
            }
        }
    }

    public struct Resource: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var type: ResourceType
        public var title: String
        public var imageDescription: String?
        public var cueWord: String?
        public var sensoryDetails: SensoryDetails?
        public var installationStrength: Int
        public var installedDate: Date?
        public var notes: String?

        public init(
            id: UUID = UUID(),
            type: ResourceType,
            title: String,
            imageDescription: String? = nil,
            cueWord: String? = nil,
            sensoryDetails: SensoryDetails? = nil,
            installationStrength: Int = 1,
            installedDate: Date? = nil,
            notes: String? = nil
        ) {
            self.id = id
            self.type = type
            self.title = title
            self.imageDescription = imageDescription
            self.cueWord = cueWord
            self.sensoryDetails = sensoryDetails
            self.installationStrength = min(max(installationStrength, 1), 7)
            self.installedDate = installedDate
            self.notes = notes
        }
    }

    public struct SensoryDetails: Codable, Hashable, Sendable {
        public var visual: String?
        public var auditory: String?
        public var tactile: String?
        public var olfactory: String?

        public init(
            visual: String? = nil,
            auditory: String? = nil,
            tactile: String? = nil,
            olfactory: String? = nil
        ) {
            self.visual = visual
            self.auditory = auditory
            self.tactile = tactile
            self.olfactory = olfactory
        }
    }
}

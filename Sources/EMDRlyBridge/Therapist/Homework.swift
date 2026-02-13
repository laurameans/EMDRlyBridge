import Foundation

public enum HomeworkType: String, Codable, CaseIterable, Sendable {
    case safePlacePractice = "safe_place_practice"
    case containerExercise = "container_exercise"
    case ticesLog = "tices_log"
    case grounding = "grounding"
    case journaling = "journaling"
    case moodLog = "mood_log"
    case breathingExercise = "breathing_exercise"
    case custom = "custom"

    public var displayName: String {
        switch self {
        case .safePlacePractice: return "Safe Place Practice"
        case .containerExercise: return "Container Exercise"
        case .ticesLog: return "TICES Log"
        case .grounding: return "Grounding"
        case .journaling: return "Journaling"
        case .moodLog: return "Mood Log"
        case .breathingExercise: return "Breathing Exercise"
        case .custom: return "Custom"
        }
    }

    public var symbolName: String {
        switch self {
        case .safePlacePractice: return "house.fill"
        case .containerExercise: return "shippingbox.fill"
        case .ticesLog: return "doc.text.magnifyingglass"
        case .grounding: return "leaf.fill"
        case .journaling: return "book.fill"
        case .moodLog: return "chart.line.uptrend.xyaxis"
        case .breathingExercise: return "wind"
        case .custom: return "square.and.pencil"
        }
    }
}

public enum HomeworkStatus: String, Codable, CaseIterable, Sendable {
    case pending = "pending"
    case inProgress = "in_progress"
    case completed = "completed"
    case overdue = "overdue"

    public var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .overdue: return "Overdue"
        }
    }
}

public enum Homework {

    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var title: String
        public var type: HomeworkType
        public var status: HomeworkStatus
        public var assignedDate: Date
        public var dueDescription: String

        public init(
            id: UUID = UUID(),
            title: String,
            type: HomeworkType,
            status: HomeworkStatus = .pending,
            assignedDate: Date = Date(),
            dueDescription: String = "As needed (ongoing)"
        ) {
            self.id = id
            self.title = title
            self.type = type
            self.status = status
            self.assignedDate = assignedDate
            self.dueDescription = dueDescription
        }
    }

    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var description: String?
        public var assignedByTherapist: Bool
        public var completedDate: Date?
        public var notes: String?

        public init(
            micro: Micro,
            description: String? = nil,
            assignedByTherapist: Bool = true,
            completedDate: Date? = nil,
            notes: String? = nil
        ) {
            self.micro = micro
            self.description = description
            self.assignedByTherapist = assignedByTherapist
            self.completedDate = completedDate
            self.notes = notes
        }
    }

    public struct CreateData: Codable, Hashable, Sendable {
        public var title: String
        public var type: HomeworkType
        public var description: String?
        public var dueDescription: String

        public init(
            title: String,
            type: HomeworkType,
            description: String? = nil,
            dueDescription: String = "As needed (ongoing)"
        ) {
            self.title = title
            self.type = type
            self.description = description
            self.dueDescription = dueDescription
        }
    }
}

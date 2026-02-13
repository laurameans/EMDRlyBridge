import Foundation

public enum AssessmentType: String, Codable, CaseIterable, Sendable {
    case pcl5 = "pcl5"
    case phq9 = "phq9"
    case gad7 = "gad7"

    public var displayName: String {
        switch self {
        case .pcl5: return "PCL-5"
        case .phq9: return "PHQ-9"
        case .gad7: return "GAD-7"
        }
    }

    public var itemCount: Int {
        switch self {
        case .pcl5: return 20
        case .phq9: return 9
        case .gad7: return 7
        }
    }

    public var maxScore: Int {
        switch self {
        case .pcl5: return 80
        case .phq9: return 27
        case .gad7: return 21
        }
    }

    public var scaleMax: Int {
        switch self {
        case .pcl5: return 4
        case .phq9: return 3
        case .gad7: return 3
        }
    }
}

public enum ClinicalAssessment {

    public struct Micro: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var type: AssessmentType
        public var totalScore: Int
        public var administeredDate: Date
        public var clientCode: String?

        public init(
            id: UUID = UUID(),
            type: AssessmentType,
            totalScore: Int,
            administeredDate: Date = Date(),
            clientCode: String? = nil
        ) {
            self.id = id
            self.type = type
            self.totalScore = totalScore
            self.administeredDate = administeredDate
            self.clientCode = clientCode
        }
    }

    public struct Global: Codable, Hashable, Sendable {
        public var micro: Micro
        public var responses: [Int]
        public var severity: String
        public var notes: String?
        public var previousScore: Int?

        public init(
            micro: Micro,
            responses: [Int],
            severity: String,
            notes: String? = nil,
            previousScore: Int? = nil
        ) {
            self.micro = micro
            self.responses = responses
            self.severity = severity
            self.notes = notes
            self.previousScore = previousScore
        }
    }

    public struct CreateData: Codable, Hashable, Sendable {
        public var type: AssessmentType
        public var responses: [Int]
        public var clientCode: String?
        public var notes: String?

        public init(
            type: AssessmentType,
            responses: [Int],
            clientCode: String? = nil,
            notes: String? = nil
        ) {
            self.type = type
            self.responses = responses
            self.clientCode = clientCode
            self.notes = notes
        }
    }
}

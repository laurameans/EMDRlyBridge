import Foundation

public enum TICESAssessment {

    public struct Entry: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var date: Date
        public var trigger: String
        public var image: String
        public var cognition: String
        public var emotion: String
        public var sensation: String
        public var sudLevel: Int
        public var vocLevel: Int?
        public var notes: String?

        public init(
            id: UUID = UUID(),
            date: Date = Date(),
            trigger: String,
            image: String,
            cognition: String,
            emotion: String,
            sensation: String,
            sudLevel: Int,
            vocLevel: Int? = nil,
            notes: String? = nil
        ) {
            self.id = id
            self.date = date
            self.trigger = trigger
            self.image = image
            self.cognition = cognition
            self.emotion = emotion
            self.sensation = sensation
            self.sudLevel = min(max(sudLevel, 0), 10)
            self.vocLevel = vocLevel.map { min(max($0, 1), 7) }
            self.notes = notes
        }
    }
}

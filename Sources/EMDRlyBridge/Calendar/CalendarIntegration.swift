import Foundation

/// Calendar integration for therapy session detection
public enum CalendarIntegration {

    /// A detected therapy appointment
    public struct TherapyAppointment: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var calendarEventId: String?
        public var title: String
        public var startDate: Date
        public var endDate: Date
        public var location: String?
        public var isConfirmed: Bool
        public var source: AppointmentSource
        public var linkedSessionId: UUID?

        public init(
            id: UUID = UUID(),
            calendarEventId: String? = nil,
            title: String,
            startDate: Date,
            endDate: Date,
            location: String? = nil,
            isConfirmed: Bool = true,
            source: AppointmentSource = .manual,
            linkedSessionId: UUID? = nil
        ) {
            self.id = id
            self.calendarEventId = calendarEventId
            self.title = title
            self.startDate = startDate
            self.endDate = endDate
            self.location = location
            self.isConfirmed = isConfirmed
            self.source = source
            self.linkedSessionId = linkedSessionId
        }

        public var isPast: Bool {
            endDate < Date()
        }

        public var isToday: Bool {
            Calendar.current.isDateInToday(startDate)
        }

        public var isUpcoming: Bool {
            startDate > Date()
        }
    }

    public enum AppointmentSource: String, Codable, Sendable {
        case calendar = "calendar"
        case manual = "manual"
        case recurring = "recurring"
    }

    /// Reminder for an upcoming appointment
    public struct Reminder: Codable, Hashable, Identifiable, Sendable {
        public var id: UUID
        public var appointmentId: UUID
        public var scheduledFor: Date
        public var type: ReminderType
        public var message: String
        public var delivered: Bool
        public var dismissed: Bool

        public init(
            id: UUID = UUID(),
            appointmentId: UUID,
            scheduledFor: Date,
            type: ReminderType,
            message: String = "",
            delivered: Bool = false,
            dismissed: Bool = false
        ) {
            self.id = id
            self.appointmentId = appointmentId
            self.scheduledFor = scheduledFor
            self.type = type
            self.message = message
            self.delivered = delivered
            self.dismissed = dismissed
        }
    }

    public enum ReminderType: String, Codable, CaseIterable, Sendable {
        case dayBefore = "day_before"
        case hoursBefore = "hours_before"
        case encouragement = "encouragement"
        case postSession = "post_session"

        public var displayName: String {
            switch self {
            case .dayBefore: return "Day Before"
            case .hoursBefore: return "Hours Before"
            case .encouragement: return "Encouragement"
            case .postSession: return "Post-Session Check-In"
            }
        }
    }
}

/// Messages for appointment reminders
public struct ReminderMessages {

    public static var dayBeforeMessages: [String] {
        [
            "You have a session tomorrow. How are you feeling about it?",
            "Tomorrow is your therapy day. Is there anything on your mind you want to bring up?",
            "Just a heads up - your session is tomorrow. You've got this.",
            "Checking in before your session tomorrow. How are you doing?"
        ]
    }

    public static var hoursBeforeMessages: [String] {
        [
            "Your session is in a few hours. Remember, you don't have to have anything prepared.",
            "Session coming up. Take a breath - you're doing important work.",
            "Almost time for your appointment. Whatever comes up, you can handle it.",
            "Your session is soon. Remember why you started this journey."
        ]
    }

    public static var encouragementMessages: [String] {
        [
            "You're about to do something brave. I'm proud of you.",
            "Showing up is the hardest part, and you're doing it.",
            "Remember all the progress you've made. This session is another step forward.",
            "You've gotten through every session so far. You'll get through this one too.",
            "Whatever happens in there, you're building something important.",
            "Trust yourself. You know more than you think you do."
        ]
    }

    public static var postSessionMessages: [String] {
        [
            "Hey, how did your session go?",
            "You made it through. How are you feeling?",
            "Session's done. How are you doing?",
            "Checking in after your session. How are you?",
            "You did it. How was it today?"
        ]
    }

    public static func random(for type: CalendarIntegration.ReminderType) -> String {
        let messages: [String]
        switch type {
        case .dayBefore:
            messages = dayBeforeMessages
        case .hoursBefore:
            messages = hoursBeforeMessages
        case .encouragement:
            messages = encouragementMessages
        case .postSession:
            messages = postSessionMessages
        }
        return messages.randomElement() ?? messages[0]
    }
}

/// Calendar search configuration
public struct CalendarSearchConfig: Codable, Hashable, Sendable {
    public var searchTerms: [String]
    public var lookAheadDays: Int
    public var lookBackDays: Int
    public var excludeAllDayEvents: Bool
    public var minimumDurationMinutes: Int
    public var maximumDurationMinutes: Int

    public init(
        searchTerms: [String] = ["therapy", "EMDR", "therapist", "counseling", "counselor", "psychologist", "mental health"],
        lookAheadDays: Int = 30,
        lookBackDays: Int = 7,
        excludeAllDayEvents: Bool = true,
        minimumDurationMinutes: Int = 30,
        maximumDurationMinutes: Int = 120
    ) {
        self.searchTerms = searchTerms
        self.lookAheadDays = lookAheadDays
        self.lookBackDays = lookBackDays
        self.excludeAllDayEvents = excludeAllDayEvents
        self.minimumDurationMinutes = minimumDurationMinutes
        self.maximumDurationMinutes = maximumDurationMinutes
    }

    public static var `default`: CalendarSearchConfig {
        CalendarSearchConfig()
    }
}

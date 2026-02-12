import Foundation

public struct AppSettings: Codable, Hashable, Sendable {
    public var birthYear: Int?
    public var clientCode: String
    public var displayName: String?
    public var checkInEnabled: Bool
    public var checkInTimeAfterSession: TimeInterval
    public var morningCheckInTime: Date?
    public var eveningCheckInTime: Date?
    public var weeklyCheckInDay: Weekday?
    public var calendarIntegrationEnabled: Bool
    public var calendarSearchTerms: [String]
    public var preSessionReminderHours: Int
    public var preSessionReminderEnabled: Bool
    public var notificationsEnabled: Bool
    public var quietHoursStart: Date?
    public var quietHoursEnd: Date?
    public var therapistSharingPreferences: TherapistConnection.SharingPreferences
    public var useLocalAIOnly: Bool
    public var preferredColorScheme: ColorSchemePreference
    public var useLargeText: Bool
    public var reducedMotion: Bool
    public var crisisContactsConfigured: Bool
    public var therapistAsEmergencyContact: Bool
    public var showCrisisButtonAlways: Bool
    public var safePlaceCueWord: String?
    public var safePlaceDescription: String?
    public var containerDescription: String?

    public init(
        birthYear: Int? = nil,
        clientCode: String = UUID().uuidString.prefix(8).uppercased().description,
        displayName: String? = nil,
        checkInEnabled: Bool = true,
        checkInTimeAfterSession: TimeInterval = 3 * 3600,
        morningCheckInTime: Date? = nil,
        eveningCheckInTime: Date? = nil,
        weeklyCheckInDay: Weekday? = nil,
        calendarIntegrationEnabled: Bool = false,
        calendarSearchTerms: [String] = ["therapy", "EMDR", "therapist", "counseling"],
        preSessionReminderHours: Int = 24,
        preSessionReminderEnabled: Bool = true,
        notificationsEnabled: Bool = true,
        quietHoursStart: Date? = nil,
        quietHoursEnd: Date? = nil,
        therapistSharingPreferences: TherapistConnection.SharingPreferences = TherapistConnection.SharingPreferences(),
        useLocalAIOnly: Bool = true,
        preferredColorScheme: ColorSchemePreference = .system,
        useLargeText: Bool = false,
        reducedMotion: Bool = false,
        crisisContactsConfigured: Bool = false,
        therapistAsEmergencyContact: Bool = false,
        showCrisisButtonAlways: Bool = true,
        safePlaceCueWord: String? = nil,
        safePlaceDescription: String? = nil,
        containerDescription: String? = nil
    ) {
        self.birthYear = birthYear
        self.clientCode = clientCode
        self.displayName = displayName
        self.checkInEnabled = checkInEnabled
        self.checkInTimeAfterSession = checkInTimeAfterSession
        self.morningCheckInTime = morningCheckInTime
        self.eveningCheckInTime = eveningCheckInTime
        self.weeklyCheckInDay = weeklyCheckInDay
        self.calendarIntegrationEnabled = calendarIntegrationEnabled
        self.calendarSearchTerms = calendarSearchTerms
        self.preSessionReminderHours = preSessionReminderHours
        self.preSessionReminderEnabled = preSessionReminderEnabled
        self.notificationsEnabled = notificationsEnabled
        self.quietHoursStart = quietHoursStart
        self.quietHoursEnd = quietHoursEnd
        self.therapistSharingPreferences = therapistSharingPreferences
        self.useLocalAIOnly = useLocalAIOnly
        self.preferredColorScheme = preferredColorScheme
        self.useLargeText = useLargeText
        self.reducedMotion = reducedMotion
        self.crisisContactsConfigured = crisisContactsConfigured
        self.therapistAsEmergencyContact = therapistAsEmergencyContact
        self.showCrisisButtonAlways = showCrisisButtonAlways
        self.safePlaceCueWord = safePlaceCueWord
        self.safePlaceDescription = safePlaceDescription
        self.containerDescription = containerDescription
    }

    public static var `default`: AppSettings {
        AppSettings()
    }
}

public enum Weekday: Int, Codable, CaseIterable, Sendable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    public var displayName: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}

public enum ColorSchemePreference: String, Codable, CaseIterable, Sendable {
    case light = "light"
    case dark = "dark"
    case system = "system"

    public var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
}

public struct OnboardingState: Codable, Hashable, Sendable {
    public var hasCompletedOnboarding: Bool
    public var hasAcknowledgedPrivacy: Bool
    public var hasSetupCrisisContacts: Bool
    public var hasConnectedCalendar: Bool
    public var hasConnectedTherapist: Bool
    public var hasCompletedFirstSession: Bool

    public init(
        hasCompletedOnboarding: Bool = false,
        hasAcknowledgedPrivacy: Bool = false,
        hasSetupCrisisContacts: Bool = false,
        hasConnectedCalendar: Bool = false,
        hasConnectedTherapist: Bool = false,
        hasCompletedFirstSession: Bool = false
    ) {
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.hasAcknowledgedPrivacy = hasAcknowledgedPrivacy
        self.hasSetupCrisisContacts = hasSetupCrisisContacts
        self.hasConnectedCalendar = hasConnectedCalendar
        self.hasConnectedTherapist = hasConnectedTherapist
        self.hasCompletedFirstSession = hasCompletedFirstSession
    }

    public var isComplete: Bool {
        hasCompletedOnboarding && hasAcknowledgedPrivacy
    }
}

public struct AppStatistics: Codable, Hashable, Sendable {
    public var totalSessions: Int
    public var totalMemories: Int
    public var totalDreams: Int
    public var totalCheckIns: Int
    public var streakDays: Int
    public var longestStreak: Int
    public var firstSessionDate: Date?
    public var lastActiveDate: Date?

    public init(
        totalSessions: Int = 0,
        totalMemories: Int = 0,
        totalDreams: Int = 0,
        totalCheckIns: Int = 0,
        streakDays: Int = 0,
        longestStreak: Int = 0,
        firstSessionDate: Date? = nil,
        lastActiveDate: Date? = nil
    ) {
        self.totalSessions = totalSessions
        self.totalMemories = totalMemories
        self.totalDreams = totalDreams
        self.totalCheckIns = totalCheckIns
        self.streakDays = streakDays
        self.longestStreak = longestStreak
        self.firstSessionDate = firstSessionDate
        self.lastActiveDate = lastActiveDate
    }
}

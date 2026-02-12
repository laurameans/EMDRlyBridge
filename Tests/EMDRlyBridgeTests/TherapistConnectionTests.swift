import Foundation
import Testing
@testable import EMDRlyBridge

@Suite("TherapistConnection.Micro Tests")
struct TherapistConnectionMicroTests {

    @Test("Micro initializes with defaults")
    func initializationDefaults() {
        let micro = TherapistConnection.Micro()

        #expect(micro.id == nil)
        #expect(micro.displayName == "My Therapist")
        #expect(micro.isConnected == false)
        #expect(micro.connectionCode == nil)
    }

    @Test("Micro initializes with custom values")
    func initializationCustom() {
        let id = UUID()
        let micro = TherapistConnection.Micro(
            id: id,
            displayName: "Dr. Smith",
            isConnected: true,
            connectionCode: "ABC123"
        )

        #expect(micro.id == id)
        #expect(micro.displayName == "Dr. Smith")
        #expect(micro.isConnected == true)
        #expect(micro.connectionCode == "ABC123")
    }

    @Test("Micro encodes to JSON")
    func encoding() throws {
        let micro = TherapistConnection.Micro(
            id: UUID(),
            displayName: "Dr. Smith",
            isConnected: true
        )

        let data = try JSONEncoder().encode(micro)
        #expect(!data.isEmpty)
    }

    @Test("Micro decodes from JSON")
    func decoding() throws {
        let json = """
        {
            "displayName": "Dr. Jones",
            "isConnected": true
        }
        """

        let micro = try JSONDecoder().decode(TherapistConnection.Micro.self, from: json.data(using: .utf8)!)
        #expect(micro.displayName == "Dr. Jones")
        #expect(micro.isConnected == true)
    }

    @Test("Micro conforms to Identifiable")
    func identifiable() {
        let id = UUID()
        let micro = TherapistConnection.Micro(id: id)
        #expect(micro.id == id)
    }
}

@Suite("TherapistConnection.Global Tests")
struct TherapistConnectionGlobalTests {

    @Test("Global initializes with defaults")
    func initializationDefaults() {
        let micro = TherapistConnection.Micro()
        let global = TherapistConnection.Global(micro: micro)

        #expect(global.canSendEncouragement == true)
        #expect(global.canViewMetrics == true)
        #expect(global.lastActive == nil)
    }

    @Test("Global initializes with custom values")
    func initializationCustom() {
        let micro = TherapistConnection.Micro(displayName: "Dr. Smith")
        let lastActive = Date()
        let global = TherapistConnection.Global(
            micro: micro,
            canSendEncouragement: false,
            canViewMetrics: false,
            lastActive: lastActive,
            sharingPreferences: .minimal
        )

        #expect(global.micro.displayName == "Dr. Smith")
        #expect(global.canSendEncouragement == false)
        #expect(global.canViewMetrics == false)
        #expect(global.lastActive == lastActive)
        #expect(global.sharingPreferences.shareSessionMetrics == false)
    }

    @Test("Global encodes to JSON")
    func encoding() throws {
        let global = TherapistConnection.Global(
            micro: TherapistConnection.Micro(displayName: "Test")
        )

        let data = try JSONEncoder().encode(global)
        #expect(!data.isEmpty)
    }

    @Test("Global decodes from JSON")
    func decoding() throws {
        let json = """
        {
            "micro": {
                "displayName": "Dr. Jones",
                "isConnected": false
            },
            "canSendEncouragement": true,
            "canViewMetrics": false,
            "sharingPreferences": {
                "shareSessionMetrics": true,
                "shareMemoryCount": true,
                "shareDreamCount": true,
                "shareCrisisEvents": true,
                "shareFeelingTrends": true,
                "allowEncouragements": true,
                "allowTherapistContact": true
            }
        }
        """

        let global = try JSONDecoder().decode(TherapistConnection.Global.self, from: json.data(using: .utf8)!)
        #expect(global.micro.displayName == "Dr. Jones")
        #expect(global.canViewMetrics == false)
    }
}

@Suite("TherapistConnection.SharingPreferences Tests")
struct TherapistConnectionSharingPreferencesTests {

    @Test("SharingPreferences initializes with defaults")
    func initializationDefaults() {
        let prefs = TherapistConnection.SharingPreferences()

        #expect(prefs.shareSessionMetrics == true)
        #expect(prefs.shareMemoryCount == true)
        #expect(prefs.shareDreamCount == true)
        #expect(prefs.shareCrisisEvents == true)
        #expect(prefs.shareFeelingTrends == true)
        #expect(prefs.allowEncouragements == true)
        #expect(prefs.allowTherapistContact == true)
    }

    @Test("SharingPreferences minimal preset")
    func minimalPreset() {
        let prefs = TherapistConnection.SharingPreferences.minimal

        #expect(prefs.shareSessionMetrics == false)
        #expect(prefs.shareMemoryCount == false)
        #expect(prefs.shareDreamCount == false)
        #expect(prefs.shareCrisisEvents == true)
        #expect(prefs.shareFeelingTrends == false)
        #expect(prefs.allowEncouragements == true)
        #expect(prefs.allowTherapistContact == true)
    }

    @Test("SharingPreferences full preset")
    func fullPreset() {
        let prefs = TherapistConnection.SharingPreferences.full

        #expect(prefs.shareSessionMetrics == true)
        #expect(prefs.shareMemoryCount == true)
        #expect(prefs.shareDreamCount == true)
        #expect(prefs.shareCrisisEvents == true)
        #expect(prefs.shareFeelingTrends == true)
        #expect(prefs.allowEncouragements == true)
        #expect(prefs.allowTherapistContact == true)
    }

    @Test("SharingPreferences encodes to JSON")
    func encoding() throws {
        let prefs = TherapistConnection.SharingPreferences.minimal

        let data = try JSONEncoder().encode(prefs)
        #expect(!data.isEmpty)
    }

    @Test("SharingPreferences decodes from JSON")
    func decoding() throws {
        let json = """
        {
            "shareSessionMetrics": true,
            "shareMemoryCount": false,
            "shareDreamCount": false,
            "shareCrisisEvents": true,
            "shareFeelingTrends": true,
            "allowEncouragements": false,
            "allowTherapistContact": true
        }
        """

        let prefs = try JSONDecoder().decode(TherapistConnection.SharingPreferences.self, from: json.data(using: .utf8)!)
        #expect(prefs.shareSessionMetrics == true)
        #expect(prefs.shareMemoryCount == false)
        #expect(prefs.allowEncouragements == false)
    }
}

@Suite("ClientMetrics.Micro Tests")
struct ClientMetricsMicroTests {

    @Test("Micro initializes with defaults")
    func initializationDefaults() {
        let micro = ClientMetrics.Micro(clientCode: "CLIENT001")

        #expect(micro.id == nil)
        #expect(micro.clientCode == "CLIENT001")
        #expect(micro.sessionCount == 0)
        #expect(micro.lastSessionDate == nil)
    }

    @Test("Micro initializes with custom values")
    func initializationCustom() {
        let id = UUID()
        let lastSession = Date()
        let micro = ClientMetrics.Micro(
            id: id,
            clientCode: "CLIENT002",
            sessionCount: 10,
            lastSessionDate: lastSession
        )

        #expect(micro.id == id)
        #expect(micro.clientCode == "CLIENT002")
        #expect(micro.sessionCount == 10)
        #expect(micro.lastSessionDate == lastSession)
    }

    @Test("Micro encodes to JSON")
    func encoding() throws {
        let micro = ClientMetrics.Micro(clientCode: "TEST001", sessionCount: 5)

        let data = try JSONEncoder().encode(micro)
        #expect(!data.isEmpty)
    }

    @Test("Micro decodes from JSON")
    func decoding() throws {
        let json = """
        {
            "clientCode": "DEC001",
            "sessionCount": 15
        }
        """

        let micro = try JSONDecoder().decode(ClientMetrics.Micro.self, from: json.data(using: .utf8)!)
        #expect(micro.clientCode == "DEC001")
        #expect(micro.sessionCount == 15)
    }
}

@Suite("ClientMetrics.Global Tests")
struct ClientMetricsGlobalTests {

    @Test("Global initializes with defaults")
    func initializationDefaults() {
        let micro = ClientMetrics.Micro(clientCode: "C1")
        let global = ClientMetrics.Global(micro: micro)

        #expect(global.averagePostSessionFeeling == nil)
        #expect(global.averageFatigueLevel == nil)
        #expect(global.memoriesLogged == 0)
        #expect(global.dreamsLogged == 0)
        #expect(global.crisisEventsCount == 0)
        #expect(global.checkInCompletionRate == 0)
        #expect(global.flaggedForDiscussion.isEmpty)
        #expect(global.recentTrend == .stable)
    }

    @Test("Global initializes with custom values")
    func initializationCustom() {
        let micro = ClientMetrics.Micro(clientCode: "C2", sessionCount: 10)
        let flaggedMicro = FlaggedItem.Micro(type: .memory, title: "Event")
        let flaggedGlobal = FlaggedItem.Global(micro: flaggedMicro)
        let global = ClientMetrics.Global(
            micro: micro,
            averagePostSessionFeeling: .calm,
            averageFatigueLevel: .moderate,
            memoriesLogged: 5,
            dreamsLogged: 3,
            crisisEventsCount: 1,
            checkInCompletionRate: 0.85,
            flaggedForDiscussion: [flaggedGlobal],
            recentTrend: .improving
        )

        #expect(global.micro.sessionCount == 10)
        #expect(global.averagePostSessionFeeling == .calm)
        #expect(global.averageFatigueLevel == .moderate)
        #expect(global.memoriesLogged == 5)
        #expect(global.dreamsLogged == 3)
        #expect(global.crisisEventsCount == 1)
        #expect(global.checkInCompletionRate == 0.85)
        #expect(global.flaggedForDiscussion.count == 1)
        #expect(global.recentTrend == .improving)
    }

    @Test("Global encodes to JSON")
    func encoding() throws {
        let micro = ClientMetrics.Micro(clientCode: "E1")
        let global = ClientMetrics.Global(micro: micro)

        let data = try JSONEncoder().encode(global)
        #expect(!data.isEmpty)
    }
}

@Suite("ClientMetrics.Trend Tests")
struct ClientMetricsTrendTests {

    @Test("Trend has all cases")
    func allCases() {
        let trends = ClientMetrics.Trend.allCases
        #expect(trends.contains(.improving))
        #expect(trends.contains(.stable))
        #expect(trends.contains(.declining))
        #expect(trends.contains(.variable))
    }

    @Test("Trend has display names")
    func displayNames() {
        #expect(ClientMetrics.Trend.improving.displayName == "Improving")
        #expect(ClientMetrics.Trend.stable.displayName == "Stable")
        #expect(ClientMetrics.Trend.declining.displayName == "Declining")
        #expect(ClientMetrics.Trend.variable.displayName == "Variable")
    }

    @Test("Trend encodes to JSON")
    func encoding() throws {
        let trend = ClientMetrics.Trend.improving

        let data = try JSONEncoder().encode(trend)
        #expect(!data.isEmpty)
    }

    @Test("Trend decodes from JSON")
    func decoding() throws {
        let json = "\"declining\""

        let trend = try JSONDecoder().decode(ClientMetrics.Trend.self, from: json.data(using: .utf8)!)
        #expect(trend == .declining)
    }
}

@Suite("FlaggedItem.Micro Tests")
struct FlaggedItemMicroTests {

    @Test("Micro initializes correctly")
    func initialization() {
        let item = FlaggedItem.Micro(type: .memory, title: "Important memory")

        #expect(item.type == .memory)
        #expect(item.title == "Important memory")
    }

    @Test("Micro initializes with all values")
    func initializationFull() {
        let id = UUID()
        let dateLogged = Date()
        let item = FlaggedItem.Micro(
            id: id,
            type: .concern,
            title: "Recurring nightmares",
            dateLogged: dateLogged
        )

        #expect(item.id == id)
        #expect(item.type == .concern)
        #expect(item.title == "Recurring nightmares")
        #expect(item.dateLogged == dateLogged)
    }

    @Test("Micro encodes to JSON")
    func encoding() throws {
        let item = FlaggedItem.Micro(type: .dream, title: "Vivid dream")

        let data = try JSONEncoder().encode(item)
        #expect(!data.isEmpty)
    }

    @Test("Micro decodes from JSON")
    func decoding() throws {
        let json = """
        {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "type": "question",
            "title": "About EMDR technique",
            "dateLogged": 0
        }
        """

        let item = try JSONDecoder().decode(FlaggedItem.Micro.self, from: json.data(using: .utf8)!)
        #expect(item.type == .question)
        #expect(item.title == "About EMDR technique")
    }
}

@Suite("FlaggedItem.Global Tests")
struct FlaggedItemGlobalTests {

    @Test("Global initializes with defaults")
    func initializationDefaults() {
        let micro = FlaggedItem.Micro(type: .feeling, title: "Test")
        let global = FlaggedItem.Global(micro: micro)

        #expect(global.clientNotes == nil)
        #expect(global.therapistViewed == false)
        #expect(global.therapistAcknowledged == false)
    }

    @Test("Global initializes with all values")
    func initializationFull() {
        let micro = FlaggedItem.Micro(type: .memory, title: "Childhood event")
        let global = FlaggedItem.Global(
            micro: micro,
            clientNotes: "Happening more frequently",
            therapistViewed: true,
            therapistAcknowledged: true
        )

        #expect(global.micro.type == .memory)
        #expect(global.clientNotes == "Happening more frequently")
        #expect(global.therapistViewed == true)
        #expect(global.therapistAcknowledged == true)
    }

    @Test("Global encodes to JSON")
    func encoding() throws {
        let micro = FlaggedItem.Micro(type: .dream, title: "Test")
        let global = FlaggedItem.Global(micro: micro)

        let data = try JSONEncoder().encode(global)
        #expect(!data.isEmpty)
    }
}

@Suite("FlaggedItem.ItemType Tests")
struct FlaggedItemTypeTests {

    @Test("ItemType has all cases")
    func allCases() {
        let types = FlaggedItem.ItemType.allCases
        #expect(types.contains(.memory))
        #expect(types.contains(.dream))
        #expect(types.contains(.feeling))
        #expect(types.contains(.question))
        #expect(types.contains(.concern))
    }

    @Test("ItemType has display names")
    func displayNames() {
        #expect(FlaggedItem.ItemType.memory.displayName == "Memory")
        #expect(FlaggedItem.ItemType.concern.displayName == "Concern")
    }

    @Test("ItemType encodes to JSON")
    func encoding() throws {
        let data = try JSONEncoder().encode(FlaggedItem.ItemType.dream)
        #expect(!data.isEmpty)
    }

    @Test("ItemType decodes from JSON")
    func decoding() throws {
        let json = "\"question\""
        let type = try JSONDecoder().decode(FlaggedItem.ItemType.self, from: json.data(using: .utf8)!)
        #expect(type == .question)
    }
}

@Suite("Encouragement.Micro Tests")
struct EncouragementMicroTests {

    @Test("Micro initializes with defaults")
    func initializationDefaults() {
        let micro = Encouragement.Micro(type: .hug)

        #expect(micro.type == .hug)
        #expect(micro.seen == false)
    }

    @Test("Micro initializes with custom values")
    func initializationCustom() {
        let id = UUID()
        let timestamp = Date()
        let micro = Encouragement.Micro(
            id: id,
            type: .proud,
            timestamp: timestamp,
            seen: true
        )

        #expect(micro.id == id)
        #expect(micro.type == .proud)
        #expect(micro.timestamp == timestamp)
        #expect(micro.seen == true)
    }

    @Test("Micro encodes to JSON")
    func encoding() throws {
        let micro = Encouragement.Micro(type: .support)

        let data = try JSONEncoder().encode(micro)
        #expect(!data.isEmpty)
    }

    @Test("Micro decodes from JSON")
    func decoding() throws {
        let json = """
        {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "type": "thinking",
            "timestamp": 0,
            "seen": false
        }
        """

        let micro = try JSONDecoder().decode(Encouragement.Micro.self, from: json.data(using: .utf8)!)
        #expect(micro.type == .thinking)
        #expect(micro.seen == false)
    }
}

@Suite("Encouragement.Global Tests")
struct EncouragementGlobalTests {

    @Test("Global initializes with defaults")
    func initializationDefaults() {
        let micro = Encouragement.Micro(type: .like)
        let global = Encouragement.Global(micro: micro)

        #expect(global.message == nil)
    }

    @Test("Global initializes with message")
    func initializationWithMessage() {
        let micro = Encouragement.Micro(type: .custom)
        let global = Encouragement.Global(
            micro: micro,
            message: "You're doing great work!"
        )

        #expect(global.micro.type == .custom)
        #expect(global.message == "You're doing great work!")
    }

    @Test("Global encodes to JSON")
    func encoding() throws {
        let micro = Encouragement.Micro(type: .proud)
        let global = Encouragement.Global(micro: micro, message: "Great progress")

        let data = try JSONEncoder().encode(global)
        #expect(!data.isEmpty)
    }
}

@Suite("Encouragement.EncouragementType Tests")
struct EncouragementTypeTests {

    @Test("EncouragementType has all cases")
    func allCases() {
        let types = Encouragement.EncouragementType.allCases
        #expect(types.contains(.hug))
        #expect(types.contains(.like))
        #expect(types.contains(.proud))
        #expect(types.contains(.thinking))
        #expect(types.contains(.support))
        #expect(types.contains(.custom))
    }

    @Test("EncouragementType has display names")
    func displayNames() {
        #expect(Encouragement.EncouragementType.hug.displayName == "Sending a hug")
        #expect(Encouragement.EncouragementType.proud.displayName == "Proud of you")
    }

    @Test("EncouragementType has SF Symbols")
    func symbolNames() {
        for type in Encouragement.EncouragementType.allCases {
            #expect(!type.symbolName.isEmpty)
        }
    }

    @Test("EncouragementType encodes to JSON")
    func encoding() throws {
        let data = try JSONEncoder().encode(Encouragement.EncouragementType.support)
        #expect(!data.isEmpty)
    }

    @Test("EncouragementType decodes from JSON")
    func decoding() throws {
        let json = "\"hug\""
        let type = try JSONDecoder().decode(Encouragement.EncouragementType.self, from: json.data(using: .utf8)!)
        #expect(type == .hug)
    }
}

@Suite("BuzzerDevice.Model Tests")
struct BuzzerDeviceModelTests {

    @Test("Model has all cases")
    func allCases() {
        let models = BuzzerDevice.Model.allCases
        #expect(models.contains(.standardTac))
        #expect(models.contains(.advancedTac))
        #expect(models.contains(.deluxeTac))
        #expect(models.contains(.deluxeTacMusic))
    }

    @Test("Model has display names")
    func displayNames() {
        #expect(BuzzerDevice.Model.standardTac.displayName == "Standard Tac/AudioScan")
        #expect(BuzzerDevice.Model.deluxeTacMusic.displayName == "Deluxe Tac/AudioScan with Music")
    }

    @Test("Model hasMusic")
    func hasMusic() {
        #expect(BuzzerDevice.Model.deluxeTacMusic.hasMusic == true)
        #expect(BuzzerDevice.Model.standardTac.hasMusic == false)
        #expect(BuzzerDevice.Model.advancedTac.hasMusic == false)
        #expect(BuzzerDevice.Model.deluxeTac.hasMusic == false)
    }

    @Test("Model maxSpeed")
    func maxSpeed() {
        #expect(BuzzerDevice.Model.standardTac.maxSpeed == 15)
        #expect(BuzzerDevice.Model.advancedTac.maxSpeed == 20)
        #expect(BuzzerDevice.Model.deluxeTac.maxSpeed == 20)
        #expect(BuzzerDevice.Model.deluxeTacMusic.maxSpeed == 20)
    }

    @Test("Model encodes to JSON")
    func encoding() throws {
        let data = try JSONEncoder().encode(BuzzerDevice.Model.advancedTac)
        #expect(!data.isEmpty)
    }

    @Test("Model decodes from JSON")
    func decoding() throws {
        let json = "\"deluxe_tac\""
        let model = try JSONDecoder().decode(BuzzerDevice.Model.self, from: json.data(using: .utf8)!)
        #expect(model == .deluxeTac)
    }
}

@Suite("BuzzerDevice.SoundType Tests")
struct BuzzerDeviceSoundTypeTests {

    @Test("SoundType has all cases")
    func allCases() {
        let types = BuzzerDevice.SoundType.allCases
        #expect(types.contains(.tone))
        #expect(types.contains(.click))
        #expect(types.contains(.doubleClick))
        #expect(types.contains(.arcade))
        #expect(types.contains(.externalMusic))
    }

    @Test("SoundType has display names")
    func displayNames() {
        #expect(BuzzerDevice.SoundType.tone.displayName == "Tone")
        #expect(BuzzerDevice.SoundType.doubleClick.displayName == "Double Click")
        #expect(BuzzerDevice.SoundType.externalMusic.displayName == "External Music")
    }

    @Test("SoundType encodes to JSON")
    func encoding() throws {
        let data = try JSONEncoder().encode(BuzzerDevice.SoundType.arcade)
        #expect(!data.isEmpty)
    }

    @Test("SoundType decodes from JSON")
    func decoding() throws {
        let json = "\"double_click\""
        let type = try JSONDecoder().decode(BuzzerDevice.SoundType.self, from: json.data(using: .utf8)!)
        #expect(type == .doubleClick)
    }
}

@Suite("BuzzerDevice.PulserType Tests")
struct BuzzerDevicePulserTypeTests {

    @Test("PulserType has all cases")
    func allCases() {
        let types = BuzzerDevice.PulserType.allCases
        #expect(types.contains(.smallTactile))
        #expect(types.contains(.largeTactile))
        #expect(types.contains(.led))
        #expect(types.contains(.wireless))
    }

    @Test("PulserType has display names")
    func displayNames() {
        #expect(BuzzerDevice.PulserType.smallTactile.displayName == "Small Tactile Pulsers")
        #expect(BuzzerDevice.PulserType.led.displayName == "LED Light Bar")
        #expect(BuzzerDevice.PulserType.wireless.displayName == "Wireless Pulsers")
    }

    @Test("PulserType encodes to JSON")
    func encoding() throws {
        let data = try JSONEncoder().encode(BuzzerDevice.PulserType.largeTactile)
        #expect(!data.isEmpty)
    }

    @Test("PulserType decodes from JSON")
    func decoding() throws {
        let json = "\"wireless\""
        let type = try JSONDecoder().decode(BuzzerDevice.PulserType.self, from: json.data(using: .utf8)!)
        #expect(type == .wireless)
    }
}

@Suite("BuzzerDevice.Settings Tests")
struct BuzzerDeviceSettingsTests {

    @Test("Settings initializes with defaults")
    func initializationDefaults() {
        let settings = BuzzerDevice.Settings()

        #expect(settings.deviceModel == .standardTac)
        #expect(settings.speed == 10)
        #expect(settings.volume == 10)
        #expect(settings.tactileIntensity == 10)
        #expect(settings.soundType == .tone)
        #expect(settings.pulserType == .smallTactile)
    }

    @Test("Settings initializes with custom values")
    func initializationCustom() {
        let settings = BuzzerDevice.Settings(
            deviceModel: .advancedTac,
            speed: 15,
            volume: 12,
            tactileIntensity: 8,
            soundType: .click,
            pulserType: .wireless
        )

        #expect(settings.deviceModel == .advancedTac)
        #expect(settings.speed == 15)
        #expect(settings.volume == 12)
        #expect(settings.tactileIntensity == 8)
        #expect(settings.soundType == .click)
        #expect(settings.pulserType == .wireless)
    }

    @Test("Settings clamps speed to device max")
    func speedClampedToDeviceMax() {
        let settingsStandard = BuzzerDevice.Settings(deviceModel: .standardTac, speed: 20)
        #expect(settingsStandard.speed == 15)

        let settingsAdvanced = BuzzerDevice.Settings(deviceModel: .advancedTac, speed: 20)
        #expect(settingsAdvanced.speed == 20)
    }

    @Test("Settings clamps values to valid range")
    func valuesClampedToRange() {
        let settingsLow = BuzzerDevice.Settings(speed: 0, volume: 0, tactileIntensity: 0)
        #expect(settingsLow.speed == 1)
        #expect(settingsLow.volume == 1)
        #expect(settingsLow.tactileIntensity == 1)

        let settingsHigh = BuzzerDevice.Settings(speed: 100, volume: 100, tactileIntensity: 100)
        #expect(settingsHigh.speed == 15)
        #expect(settingsHigh.volume == 20)
        #expect(settingsHigh.tactileIntensity == 20)
    }

    @Test("Settings default preset")
    func defaultPreset() {
        let settings = BuzzerDevice.Settings.default

        #expect(settings.deviceModel == .standardTac)
        #expect(settings.speed == 10)
        #expect(settings.volume == 10)
    }

    @Test("Settings encodes to JSON")
    func encoding() throws {
        let settings = BuzzerDevice.Settings(
            deviceModel: .deluxeTac,
            speed: 18,
            volume: 15
        )

        let data = try JSONEncoder().encode(settings)
        #expect(!data.isEmpty)
    }

    @Test("Settings decodes from JSON")
    func decoding() throws {
        let json = """
        {
            "deviceModel": "advanced_tac",
            "speed": 12,
            "volume": 14,
            "tactileIntensity": 10,
            "soundType": "click",
            "pulserType": "large_tactile"
        }
        """

        let settings = try JSONDecoder().decode(BuzzerDevice.Settings.self, from: json.data(using: .utf8)!)
        #expect(settings.deviceModel == .advancedTac)
        #expect(settings.speed == 12)
        #expect(settings.volume == 14)
        #expect(settings.soundType == .click)
        #expect(settings.pulserType == .largeTactile)
    }
}

@Suite("BuzzerSession.Micro Tests")
struct BuzzerSessionMicroTests {

    @Test("Micro initializes with defaults")
    func initializationDefaults() {
        let micro = BuzzerSession.Micro()

        #expect(micro.sessionId == nil)
        #expect(micro.bilateralSets == 0)
        #expect(micro.durationSeconds == 0)
    }

    @Test("Micro initializes with custom values")
    func initializationCustom() {
        let id = UUID()
        let sessionId = UUID()
        let sessionDate = Date()

        let micro = BuzzerSession.Micro(
            id: id,
            sessionId: sessionId,
            sessionDate: sessionDate,
            bilateralSets: 24,
            durationSeconds: 1800
        )

        #expect(micro.id == id)
        #expect(micro.sessionId == sessionId)
        #expect(micro.sessionDate == sessionDate)
        #expect(micro.bilateralSets == 24)
        #expect(micro.durationSeconds == 1800)
    }

    @Test("Micro durationFormatted with minutes")
    func durationFormattedWithMinutes() {
        let micro = BuzzerSession.Micro(durationSeconds: 125)
        #expect(micro.durationFormatted == "2m 5s")
    }

    @Test("Micro durationFormatted seconds only")
    func durationFormattedSecondsOnly() {
        let micro = BuzzerSession.Micro(durationSeconds: 45)
        #expect(micro.durationFormatted == "45s")
    }

    @Test("Micro encodes to JSON")
    func encoding() throws {
        let micro = BuzzerSession.Micro(bilateralSets: 12, durationSeconds: 600)

        let data = try JSONEncoder().encode(micro)
        #expect(!data.isEmpty)
    }

    @Test("Micro decodes from JSON")
    func decoding() throws {
        let json = """
        {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "sessionDate": 0,
            "bilateralSets": 18,
            "durationSeconds": 900
        }
        """

        let micro = try JSONDecoder().decode(BuzzerSession.Micro.self, from: json.data(using: .utf8)!)
        #expect(micro.bilateralSets == 18)
        #expect(micro.durationSeconds == 900)
    }
}

@Suite("BuzzerSession.Global Tests")
struct BuzzerSessionGlobalTests {

    @Test("Global initializes with defaults")
    func initializationDefaults() {
        let micro = BuzzerSession.Micro()
        let global = BuzzerSession.Global(micro: micro)

        #expect(global.notes == nil)
    }

    @Test("Global initializes with custom values")
    func initializationCustom() {
        let micro = BuzzerSession.Micro(bilateralSets: 20)
        let settings = BuzzerDevice.Settings(deviceModel: .deluxeTacMusic)
        let createdDate = Date()

        let global = BuzzerSession.Global(
            micro: micro,
            settings: settings,
            notes: "Good session",
            createdDate: createdDate
        )

        #expect(global.micro.bilateralSets == 20)
        #expect(global.settings.deviceModel == .deluxeTacMusic)
        #expect(global.notes == "Good session")
        #expect(global.createdDate == createdDate)
    }

    @Test("Global encodes to JSON")
    func encoding() throws {
        let micro = BuzzerSession.Micro()
        let global = BuzzerSession.Global(micro: micro)

        let data = try JSONEncoder().encode(global)
        #expect(!data.isEmpty)
    }
}

@Suite("CrisisAlert.Micro Tests")
struct CrisisAlertMicroTests {

    @Test("Micro initializes with required values")
    func initialization() {
        let micro = CrisisAlert.Micro(
            clientCode: "CLIENT001",
            severity: .moderate
        )

        #expect(micro.clientCode == "CLIENT001")
        #expect(micro.severity == .moderate)
    }

    @Test("Micro initializes with all values")
    func initializationFull() {
        let id = UUID()
        let notificationSent = Date()

        let micro = CrisisAlert.Micro(
            id: id,
            clientCode: "CLIENT002",
            severity: .critical,
            notificationSentAt: notificationSent
        )

        #expect(micro.id == id)
        #expect(micro.clientCode == "CLIENT002")
        #expect(micro.severity == .critical)
        #expect(micro.notificationSentAt == notificationSent)
    }

    @Test("Micro encodes to JSON")
    func encoding() throws {
        let micro = CrisisAlert.Micro(
            clientCode: "TEST001",
            severity: .severe
        )

        let data = try JSONEncoder().encode(micro)
        #expect(!data.isEmpty)
    }

    @Test("Micro decodes from JSON")
    func decoding() throws {
        let json = """
        {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "clientCode": "DEC001",
            "severity": "critical",
            "notificationSentAt": 0
        }
        """

        let micro = try JSONDecoder().decode(CrisisAlert.Micro.self, from: json.data(using: .utf8)!)
        #expect(micro.clientCode == "DEC001")
        #expect(micro.severity == .critical)
    }
}

@Suite("CrisisAlert.Global Tests")
struct CrisisAlertGlobalTests {

    @Test("Global initializes with required values")
    func initialization() {
        let micro = CrisisAlert.Micro(clientCode: "C1", severity: .moderate)
        let global = CrisisAlert.Global(
            micro: micro,
            triggerReason: "High distress reported"
        )

        #expect(global.triggerReason == "High distress reported")
        #expect(global.checkInId == nil)
        #expect(global.viewedAt == nil)
        #expect(global.resolvedAt == nil)
        #expect(global.resolutionNotes == nil)
    }

    @Test("Global initializes with all values")
    func initializationFull() {
        let micro = CrisisAlert.Micro(clientCode: "C2", severity: .critical)
        let checkInId = UUID()
        let viewed = Date()
        let resolved = Date()

        let global = CrisisAlert.Global(
            micro: micro,
            triggerReason: "Suicidal ideation mentioned",
            checkInId: checkInId,
            viewedAt: viewed,
            resolvedAt: resolved,
            resolutionNotes: "Client contacted and safe"
        )

        #expect(global.triggerReason == "Suicidal ideation mentioned")
        #expect(global.checkInId == checkInId)
        #expect(global.viewedAt == viewed)
        #expect(global.resolvedAt == resolved)
        #expect(global.resolutionNotes == "Client contacted and safe")
    }

    @Test("Global isViewed computed property")
    func isViewed() {
        let micro = CrisisAlert.Micro(clientCode: "C1", severity: .moderate)

        let notViewed = CrisisAlert.Global(micro: micro, triggerReason: "Test")
        #expect(notViewed.isViewed == false)

        let viewed = CrisisAlert.Global(micro: micro, triggerReason: "Test", viewedAt: Date())
        #expect(viewed.isViewed == true)
    }

    @Test("Global isResolved computed property")
    func isResolved() {
        let micro = CrisisAlert.Micro(clientCode: "C1", severity: .severe)

        let unresolved = CrisisAlert.Global(micro: micro, triggerReason: "Test")
        #expect(unresolved.isResolved == false)

        let resolved = CrisisAlert.Global(micro: micro, triggerReason: "Test", resolvedAt: Date())
        #expect(resolved.isResolved == true)
    }

    @Test("Global encodes to JSON")
    func encoding() throws {
        let micro = CrisisAlert.Micro(clientCode: "E1", severity: .moderate)
        let global = CrisisAlert.Global(micro: micro, triggerReason: "Test reason")

        let data = try JSONEncoder().encode(global)
        #expect(!data.isEmpty)
    }
}

@Suite("CrisisAlert.Severity Tests")
struct CrisisAlertSeverityTests {

    @Test("Severity has all cases")
    func allCases() {
        let severities = CrisisAlert.Severity.allCases
        #expect(severities.contains(.moderate))
        #expect(severities.contains(.severe))
        #expect(severities.contains(.critical))
    }

    @Test("Severity has display names")
    func displayNames() {
        #expect(CrisisAlert.Severity.moderate.displayName == "Moderate")
        #expect(CrisisAlert.Severity.severe.displayName == "Severe")
        #expect(CrisisAlert.Severity.critical.displayName == "Critical")
    }

    @Test("Severity has colors")
    func colors() {
        #expect(CrisisAlert.Severity.moderate.color == "yellow")
        #expect(CrisisAlert.Severity.severe.color == "orange")
        #expect(CrisisAlert.Severity.critical.color == "red")
    }

    @Test("Severity encodes to JSON")
    func encoding() throws {
        let data = try JSONEncoder().encode(CrisisAlert.Severity.critical)
        #expect(!data.isEmpty)
    }

    @Test("Severity decodes from JSON")
    func decoding() throws {
        let json = "\"severe\""
        let severity = try JSONDecoder().decode(CrisisAlert.Severity.self, from: json.data(using: .utf8)!)
        #expect(severity == .severe)
    }
}

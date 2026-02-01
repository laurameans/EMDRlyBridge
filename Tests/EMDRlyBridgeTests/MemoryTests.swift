import Foundation
import Testing
@testable import EMDRlyBridge

@Suite("Memory Model Tests")
struct MemoryTests {

    @Test("Memory.Micro initializes with defaults")
    func microInitialization() {
        let memory = Memory.Micro()

        #expect(memory.title == "")
        #expect(memory.isContained == true)
    }

    @Test("Memory.Micro initializes with custom values")
    func microCustomInitialization() {
        let id = UUID()
        let ageEstimate = AgeEstimate(bestGuess: 8, confidence: .likely)
        let memory = Memory.Micro(
            id: id,
            title: "First day of school",
            approximateAge: ageEstimate,
            isContained: false
        )

        #expect(memory.id == id)
        #expect(memory.title == "First day of school")
        #expect(memory.approximateAge?.bestGuess == 8)
        #expect(memory.isContained == false)
    }

    @Test("Memory.Global tracks all metadata")
    func globalInitialization() {
        let micro = Memory.Micro(title: "Test memory")
        let global = Memory.Global(
            micro: micro,
            description: "Detailed description",
            emotionsPresent: [.fear, .sadness],
            bodyLocations: [.chest, .stomach],
            intensity: 7,
            flaggedForNextSession: true
        )

        #expect(global.description == "Detailed description")
        #expect(global.emotionsPresent.count == 2)
        #expect(global.bodyLocations.count == 2)
        #expect(global.intensity == 7)
        #expect(global.flaggedForNextSession == true)
    }

    @Test("Memory encodes to JSON")
    func memoryEncodes() throws {
        let memory = Memory.Global(
            micro: Memory.Micro(id: UUID(), title: "Test"),
            emotionsPresent: [.fear]
        )

        let data = try JSONEncoder().encode(memory)
        #expect(!data.isEmpty)
    }
}

@Suite("AgeEstimate Tests")
struct AgeEstimateTests {

    @Test("AgeEstimate displays best guess")
    func displaysBestGuess() {
        let estimate = AgeEstimate(bestGuess: 10)
        #expect(estimate.displayString == "Around age 10")
    }

    @Test("AgeEstimate displays range")
    func displaysRange() {
        let estimate = AgeEstimate(lowerBound: 8, upperBound: 12)
        #expect(estimate.displayString == "Between ages 8 and 12")
    }

    @Test("AgeEstimate displays lower bound only")
    func displaysLowerBound() {
        let estimate = AgeEstimate(lowerBound: 5)
        #expect(estimate.displayString == "Older than 5")
    }

    @Test("AgeEstimate displays upper bound only")
    func displaysUpperBound() {
        let estimate = AgeEstimate(upperBound: 15)
        #expect(estimate.displayString == "Younger than 15")
    }

    @Test("AgeEstimate displays unknown")
    func displaysUnknown() {
        let estimate = AgeEstimate()
        #expect(estimate.displayString == "Age unknown")
    }
}

@Suite("EmotionType Tests")
struct EmotionTypeTests {

    @Test("EmotionType identifies positive emotions")
    func positiveEmotions() {
        #expect(EmotionType.love.isPositive == true)
        #expect(EmotionType.joy.isPositive == true)
        #expect(EmotionType.relief.isPositive == true)
        #expect(EmotionType.hope.isPositive == true)
    }

    @Test("EmotionType identifies negative emotions")
    func negativeEmotions() {
        #expect(EmotionType.fear.isPositive == false)
        #expect(EmotionType.anger.isPositive == false)
        #expect(EmotionType.shame.isPositive == false)
        #expect(EmotionType.terror.isPositive == false)
    }
}

@Suite("BodyLocation Tests")
struct BodyLocationTests {

    @Test("BodyLocation covers common locations")
    func coversCommonLocations() {
        let locations = BodyLocation.allCases
        #expect(locations.contains(.chest))
        #expect(locations.contains(.stomach))
        #expect(locations.contains(.throat))
        #expect(locations.contains(.wholeBody))
    }

    @Test("BodyLocation has display names")
    func hasDisplayNames() {
        #expect(BodyLocation.wholeBody.displayName == "Whole Body")
        #expect(BodyLocation.chest.displayName == "Chest")
    }
}

@Suite("TimelinePosition Tests")
struct TimelinePositionTests {

    @Test("LifePeriod covers all life stages")
    func coversAllStages() {
        let periods = TimelinePosition.LifePeriod.allCases
        #expect(periods.count == 7)
        #expect(periods.contains(.earlyChildhood))
        #expect(periods.contains(.adolescence))
        #expect(periods.contains(.laterLife))
    }

    @Test("LifePeriod has descriptive display names")
    func hasDescriptiveNames() {
        #expect(TimelinePosition.LifePeriod.earlyChildhood.displayName.contains("0-5"))
        #expect(TimelinePosition.LifePeriod.adolescence.displayName.contains("12-17"))
    }
}

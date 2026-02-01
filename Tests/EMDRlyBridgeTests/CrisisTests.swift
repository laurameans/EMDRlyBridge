import Foundation
import Testing
@testable import EMDRlyBridge

@Suite("Crisis Model Tests")
struct CrisisTests {

    @Test("Crisis.Contact initializes properly")
    func contactInitialization() {
        let contact = Crisis.Contact(
            name: "988 Lifeline",
            phone: "988",
            type: .hotline,
            is24Hours: true
        )

        #expect(contact.name == "988 Lifeline")
        #expect(contact.phone == "988")
        #expect(contact.type == .hotline)
        #expect(contact.is24Hours == true)
    }

    @Test("Crisis has default resources")
    func hasDefaultResources() {
        let resources = Crisis.defaultResources
        #expect(resources.count >= 3)

        // Should include 988
        let has988 = resources.contains { $0.phone == "988" }
        #expect(has988 == true)

        // Should include 911
        let has911 = resources.contains { $0.phone == "911" }
        #expect(has911 == true)
    }

    @Test("Crisis.SafetyCheck tracks distress")
    func safetyCheckTracksDistress() {
        let check = Crisis.SafetyCheck(
            distressLevel: .severe,
            feelingSafe: false,
            needsSupport: .professionalHelp
        )

        #expect(check.distressLevel == .severe)
        #expect(check.feelingSafe == false)
        #expect(check.needsSupport == .professionalHelp)
    }
}

@Suite("GroundingExercise Tests")
struct GroundingExerciseTests {

    @Test("GroundingExercises has built-in exercises")
    func hasBuiltInExercises() {
        let exercises = GroundingExercises.all
        #expect(exercises.count >= 4)
    }

    @Test("5-4-3-2-1 exercise has steps")
    func fiveFourThreeTwoHasSteps() {
        let exercise = GroundingExercises.fiveFourThreeTwo
        #expect(exercise.steps.count == 5)
        #expect(exercise.category == .sensory)
    }

    @Test("Box breathing has steps")
    func boxBreathingHasSteps() {
        let exercise = GroundingExercises.boxBreathing
        #expect(exercise.steps.count >= 4)
        #expect(exercise.category == .breathing)
    }

    @Test("All exercises have duration")
    func allHaveDuration() {
        for exercise in GroundingExercises.all {
            #expect(exercise.durationMinutes > 0)
        }
    }
}

@Suite("SafetyScreening Tests")
struct SafetyScreeningTests {

    @Test("SafetyScreening detects concerning content")
    func detectsConcerning() {
        #expect(SafetyScreening.containsConcerningContent("I want to die") == true)
        #expect(SafetyScreening.containsConcerningContent("I can't go on like this") == true)
        #expect(SafetyScreening.containsConcerningContent("I feel hopeless") == true)
    }

    @Test("SafetyScreening allows normal content")
    func allowsNormal() {
        #expect(SafetyScreening.containsConcerningContent("I had a hard day") == false)
        #expect(SafetyScreening.containsConcerningContent("I'm feeling sad") == false)
        #expect(SafetyScreening.containsConcerningContent("Session was intense") == false)
    }

    @Test("SafetyScreening has gentle crisis response")
    func hasGentleResponse() {
        let response = SafetyScreening.gentleCrisisResponse
        #expect(response.lowercased().contains("not alone") || response.lowercased().contains("here"))
    }
}

@Suite("SupportNeeded Tests")
struct SupportNeededTests {

    @Test("SupportNeeded covers escalation levels")
    func coversEscalation() {
        let levels = Crisis.SupportNeeded.allCases
        #expect(levels.contains(.none))
        #expect(levels.contains(.grounding))
        #expect(levels.contains(.professionalHelp))
        #expect(levels.contains(.emergencyServices))
    }

    @Test("SupportNeeded has display names")
    func hasDisplayNames() {
        for level in Crisis.SupportNeeded.allCases {
            #expect(!level.displayName.isEmpty)
        }
    }
}

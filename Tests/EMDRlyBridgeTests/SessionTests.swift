import Foundation
import Testing
@testable import EMDRlyBridge

@Suite("Session Model Tests")
struct SessionTests {

    @Test("Session.Micro initializes with defaults")
    func microInitialization() {
        let session = Session.Micro()

        #expect(session.id == nil)
        #expect(session.sessionNumber == 1)
        #expect(session.completed == false)
    }

    @Test("Session.Micro initializes with custom values")
    func microCustomInitialization() {
        let id = UUID()
        let date = Date()
        let session = Session.Micro(
            id: id,
            date: date,
            sessionNumber: 5,
            completed: true
        )

        #expect(session.id == id)
        #expect(session.date == date)
        #expect(session.sessionNumber == 5)
        #expect(session.completed == true)
    }

    @Test("Session.Global contains all tracking fields")
    func globalInitialization() {
        let micro = Session.Micro(sessionNumber: 3)
        let global = Session.Global(
            micro: micro,
            postSessionFeeling: .calm,
            fatigueLevel: .moderate,
            needsRest: true,
            activitiesAfter: [.nap, .rest]
        )

        #expect(global.micro.sessionNumber == 3)
        #expect(global.postSessionFeeling == .calm)
        #expect(global.fatigueLevel == .moderate)
        #expect(global.needsRest == true)
        #expect(global.activitiesAfter.count == 2)
    }

    @Test("Session encodes to JSON")
    func sessionEncodes() throws {
        let session = Session.Global(
            micro: Session.Micro(id: UUID(), sessionNumber: 1),
            postSessionFeeling: .hopeful,
            fatigueLevel: .mild
        )

        let data = try JSONEncoder().encode(session)
        #expect(!data.isEmpty)
    }
}

@Suite("FeelingLevel Tests")
struct FeelingLevelTests {

    @Test("FeelingLevel has correct display names")
    func displayNames() {
        #expect(FeelingLevel.veryCalm.displayName == "Very Calm")
        #expect(FeelingLevel.overwhelmed.displayName == "Overwhelmed")
    }

    @Test("FeelingLevel identifies needs for extra support")
    func extraSupportNeeded() {
        #expect(FeelingLevel.veryAnxious.needsExtraSupport == true)
        #expect(FeelingLevel.verySad.needsExtraSupport == true)
        #expect(FeelingLevel.overwhelmed.needsExtraSupport == true)
        #expect(FeelingLevel.calm.needsExtraSupport == false)
        #expect(FeelingLevel.neutral.needsExtraSupport == false)
    }

    @Test("FeelingLevel has emojis")
    func hasEmojis() {
        for feeling in FeelingLevel.allCases {
            #expect(!feeling.emoji.isEmpty)
        }
    }
}

@Suite("FatigueLevel Tests")
struct FatigueLevelTests {

    @Test("FatigueLevel suggests rest appropriately")
    func suggestsRest() {
        #expect(FatigueLevel.exhausted.suggestsRest == true)
        #expect(FatigueLevel.significant.suggestsRest == true)
        #expect(FatigueLevel.moderate.suggestsRest == false)
        #expect(FatigueLevel.mild.suggestsRest == false)
        #expect(FatigueLevel.none.suggestsRest == false)
    }

    @Test("FatigueLevel has display names")
    func displayNames() {
        #expect(FatigueLevel.exhausted.displayName == "Completely exhausted")
        #expect(FatigueLevel.none.displayName == "Not tired")
    }
}

@Suite("PostSessionActivity Tests")
struct PostSessionActivityTests {

    @Test("PostSessionActivity covers common activities")
    func hasCommonActivities() {
        let activities = PostSessionActivity.allCases
        #expect(activities.contains(.nap))
        #expect(activities.contains(.rest))
        #expect(activities.contains(.walk))
        #expect(activities.contains(.journaled))
        #expect(activities.contains(.meditated))
    }

    @Test("PostSessionActivity has display names")
    func displayNames() {
        #expect(PostSessionActivity.nap.displayName == "Took a nap")
        #expect(PostSessionActivity.talkedToFriend.displayName == "Talked to a friend")
    }
}

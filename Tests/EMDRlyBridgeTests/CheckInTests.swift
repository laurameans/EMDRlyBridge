import Foundation
import Testing
@testable import EMDRlyBridge

@Suite("CheckIn Model Tests")
struct CheckInTests {

    @Test("CheckIn.Micro initializes with defaults")
    func microInitialization() {
        let checkIn = CheckIn.Micro()

        #expect(checkIn.type == .routine)
        #expect(checkIn.completed == false)
        #expect(checkIn.userInitiated == false)
    }

    @Test("CheckIn.Global tracks conversation")
    func globalTracksConversation() {
        let micro = CheckIn.Micro(type: .postSession)
        let message = ConversationMessage(
            role: .assistant,
            content: "How are you?"
        )
        let global = CheckIn.Global(
            micro: micro,
            messages: [message],
            currentFeeling: .calm
        )

        #expect(global.messages.count == 1)
        #expect(global.currentFeeling == .calm)
    }
}

@Suite("CheckInType Tests")
struct CheckInTypeTests {

    @Test("CheckInType has opening messages")
    func hasOpeningMessages() {
        for type in CheckInType.allCases {
            #expect(!type.openingMessage.isEmpty)
        }
    }

    @Test("PostSession opening is gentle")
    func postSessionIsGentle() {
        let opening = CheckInType.postSession.openingMessage
        #expect(opening.lowercased().contains("how") || opening.lowercased().contains("session"))
    }
}

@Suite("QuickReply Tests")
struct QuickReplyTests {

    @Test("QuickReplies has howAreYou options")
    func howAreYouOptions() {
        let replies = QuickReplies.howAreYou
        #expect(replies.count >= 3)
    }

    @Test("QuickReplies includes crisis option in wantToTalk")
    func wantToTalkHasCrisis() {
        let replies = QuickReplies.wantToTalk
        let hasCrisisOption = replies.contains { $0.action == .escalateToCrisis }
        #expect(hasCrisisOption == true)
    }

    @Test("Crisis replies have appropriate actions")
    func crisisRepliesHaveActions() {
        let replies = QuickReplies.crisis
        let hasEscalation = replies.contains { $0.action == .escalateToCrisis }
        let hasTherapist = replies.contains { $0.action == .contactTherapist }
        #expect(hasEscalation == true)
        #expect(hasTherapist == true)
    }
}

@Suite("DistressLevel Tests")
struct DistressLevelTests {

    @Test("DistressLevel requires action at severe levels")
    func requiresAction() {
        #expect(DistressLevel.crisis.requiresAction == true)
        #expect(DistressLevel.severe.requiresAction == true)
        #expect(DistressLevel.significant.requiresAction == false)
        #expect(DistressLevel.moderate.requiresAction == false)
    }

    @Test("DistressLevel suggests rest appropriately")
    func suggestsRest() {
        #expect(DistressLevel.moderate.suggestRest == true)
        #expect(DistressLevel.significant.suggestRest == true)
        #expect(DistressLevel.mild.suggestRest == false)
        #expect(DistressLevel.none.suggestRest == false)
    }
}

@Suite("ConversationMessage Tests")
struct ConversationMessageTests {

    @Test("ConversationMessage initializes properly")
    func initialization() {
        let message = ConversationMessage(
            role: .user,
            content: "I'm feeling okay"
        )

        #expect(message.role == .user)
        #expect(message.content == "I'm feeling okay")
        #expect(message.wasTypedResponse == false)
    }

    @Test("ConversationMessage tracks quick reply selection")
    func tracksQuickReply() {
        let quickReply = QuickReply(text: "I'm okay", sentiment: .positive)
        let message = ConversationMessage(
            role: .user,
            content: "I'm okay",
            quickReplySelected: quickReply,
            wasTypedResponse: false
        )

        #expect(message.quickReplySelected != nil)
        #expect(message.wasTypedResponse == false)
    }
}

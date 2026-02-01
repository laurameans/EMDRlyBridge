import Foundation
import Testing
@testable import EMDRlyBridge

@Suite("Dream Model Tests")
struct DreamTests {

    @Test("Dream.Micro initializes with defaults")
    func microInitialization() {
        let dream = Dream.Micro()

        #expect(dream.title == "")
        #expect(dream.intensity == .moderate)
        #expect(dream.wasNightmare == false)
    }

    @Test("Dream.Micro initializes with custom values")
    func microCustomInitialization() {
        let id = UUID()
        let dream = Dream.Micro(
            id: id,
            title: "Flying dream",
            intensity: .vivid,
            wasNightmare: false
        )

        #expect(dream.id == id)
        #expect(dream.title == "Flying dream")
        #expect(dream.intensity == .vivid)
    }

    @Test("Dream.Global tracks interpretation")
    func globalTracksInterpretation() {
        let micro = Dream.Micro(title: "Chase dream")
        let global = Dream.Global(
            micro: micro,
            themes: [.beingChased, .escaping],
            aiInterpretation: "May represent avoidance",
            flaggedForTherapist: true
        )

        #expect(global.themes.count == 2)
        #expect(global.aiInterpretation != nil)
        #expect(global.flaggedForTherapist == true)
    }

    @Test("Dream encodes to JSON")
    func dreamEncodes() throws {
        let dream = Dream.Global(
            micro: Dream.Micro(id: UUID(), title: "Test"),
            themes: [.water]
        )

        let data = try JSONEncoder().encode(dream)
        #expect(!data.isEmpty)
    }
}

@Suite("DreamIntensity Tests")
struct DreamIntensityTests {

    @Test("DreamIntensity has descriptive display names")
    func displayNames() {
        #expect(DreamIntensity.mild.displayName.contains("Faint"))
        #expect(DreamIntensity.extremelyVivid.displayName.contains("completely real"))
    }

    @Test("All intensities have display names")
    func allHaveDisplayNames() {
        for intensity in DreamIntensity.allCases {
            #expect(!intensity.displayName.isEmpty)
        }
    }
}

@Suite("DreamTheme Tests")
struct DreamThemeTests {

    @Test("DreamTheme covers common EMDR dreams")
    func coversCommonThemes() {
        let themes = DreamTheme.allCases
        #expect(themes.contains(.beingChased))
        #expect(themes.contains(.flying))
        #expect(themes.contains(.falling))
        #expect(themes.contains(.healing))
        #expect(themes.contains(.transformation))
    }

    @Test("DreamTheme has processing significance")
    func hasProcessingSignificance() {
        let significance = DreamTheme.beingChased.processingSignificance
        #expect(significance.contains("avoidance"))
    }

    @Test("All themes have significance explanations")
    func allHaveSignificance() {
        for theme in DreamTheme.allCases {
            #expect(!theme.processingSignificance.isEmpty)
        }
    }
}

import Foundation

public struct GAD7Assessment: Sendable {

    public static let questions: [String] = [
        "Feeling nervous, anxious, or on edge?",
        "Not being able to stop or control worrying?",
        "Worrying too much about different things?",
        "Trouble relaxing?",
        "Being so restless that it's hard to sit still?",
        "Becoming easily annoyed or irritable?",
        "Feeling afraid as if something awful might happen?"
    ]

    public static let scaleLabels: [String] = [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly every day"
    ]

    public static func severity(for score: Int) -> String {
        switch score {
        case 0...4: return "Minimal"
        case 5...9: return "Mild"
        case 10...14: return "Moderate"
        case 15...21: return "Severe"
        default: return "Invalid"
        }
    }
}

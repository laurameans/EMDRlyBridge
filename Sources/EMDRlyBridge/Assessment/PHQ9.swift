import Foundation

public struct PHQ9Assessment: Sendable {

    public static let questions: [String] = [
        "Little interest or pleasure in doing things?",
        "Feeling down, depressed, or hopeless?",
        "Trouble falling or staying asleep, or sleeping too much?",
        "Feeling tired or having little energy?",
        "Poor appetite or overeating?",
        "Feeling bad about yourself — or that you are a failure or have let yourself or your family down?",
        "Trouble concentrating on things, such as reading the newspaper or watching television?",
        "Moving or speaking so slowly that other people could have noticed? Or the opposite — being so fidgety or restless that you have been moving around a lot more than usual?",
        "Thoughts that you would be better off dead, or of hurting yourself in some way?"
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
        case 15...19: return "Moderately Severe"
        case 20...27: return "Severe"
        default: return "Invalid"
        }
    }
}

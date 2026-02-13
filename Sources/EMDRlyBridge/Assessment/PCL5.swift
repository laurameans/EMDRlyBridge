import Foundation

public struct PCL5Assessment: Sendable {

    public static let questions: [String] = [
        "Repeated, disturbing, and unwanted memories of the stressful experience?",
        "Repeated, disturbing dreams of the stressful experience?",
        "Suddenly feeling or acting as if the stressful experience were actually happening again (as if you were actually back there reliving it)?",
        "Feeling very upset when something reminded you of the stressful experience?",
        "Having strong physical reactions when something reminded you of the stressful experience (for example, heart pounding, trouble breathing, sweating)?",
        "Avoiding memories, thoughts, or feelings related to the stressful experience?",
        "Avoiding external reminders of the stressful experience (for example, people, places, conversations, activities, objects, or situations)?",
        "Trouble remembering important parts of the stressful experience?",
        "Having strong negative beliefs about yourself, other people, or the world (for example, having thoughts such as: I am bad, there is something seriously wrong with me, no one can be trusted, the world is completely dangerous)?",
        "Blaming yourself or someone else for the stressful experience or what happened after it?",
        "Having strong negative feelings such as fear, horror, anger, guilt, or shame?",
        "Loss of interest in activities that you used to enjoy?",
        "Feeling distant or cut off from other people?",
        "Trouble experiencing positive feelings (for example, being unable to feel happiness or have loving feelings for people close to you)?",
        "Irritable behavior, angry outbursts, or acting aggressively?",
        "Taking too many risks or doing things that could cause you harm?",
        "Being 'superalert' or watchful or on guard?",
        "Feeling jumpy or easily startled?",
        "Having difficulty concentrating?",
        "Trouble falling or staying asleep?"
    ]

    public static let scaleLabels: [String] = [
        "Not at all",
        "A little bit",
        "Moderately",
        "Quite a bit",
        "Extremely"
    ]

    public static func severity(for score: Int) -> String {
        switch score {
        case 0...10: return "Minimal"
        case 11...20: return "Low"
        case 21...32: return "Moderate"
        case 33...59: return "High"
        case 60...80: return "Severe"
        default: return "Invalid"
        }
    }

    public enum Cluster: String, CaseIterable, Sendable {
        case b = "Re-experiencing"
        case c = "Avoidance"
        case d = "Cognition & Mood"
        case e = "Arousal & Reactivity"

        public var questionRange: ClosedRange<Int> {
            switch self {
            case .b: return 0...4
            case .c: return 5...6
            case .d: return 7...13
            case .e: return 14...19
            }
        }
    }

    public static func clusterScore(responses: [Int], cluster: Cluster) -> Int {
        let range = cluster.questionRange
        guard responses.count > range.upperBound else { return 0 }
        return responses[range].reduce(0, +)
    }
}

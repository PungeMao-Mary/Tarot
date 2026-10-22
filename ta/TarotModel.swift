import Foundation

struct TarotCard: Identifiable, Hashable {
    let id: Int
    let name: String
    let uprightRelationship: String   // 人际/情感：正位释义
    let reversedRelationship: String  // 人际/情感：逆位释义
    let advice: String                // 人际建议
}

struct DrawnCard: Identifiable {
    let id = UUID()
    let card: TarotCard
    let isReversed: Bool
    let spreadPosition: String
    var isFlipped: Bool = false
}

enum SpreadType: String {
    case relationshipThree = "人际关系三张流"

    var positions: [String] {
        return [
            "【自身状态】你的视角与潜意识投射",
            "【对方状态】对方的真实态度与处境",
            "【互动与走向】双方动态及发展/建议"
        ]
    }
}

enum RitualStep {
    case intention   // 1. 冥想与提问
    case shuffling   // 2. 仪式洗牌
    case cutting     // 3. 直觉切牌
    case picking     // 4. 抽取三张
    case reading     // 5. 翻牌与深度解读
}

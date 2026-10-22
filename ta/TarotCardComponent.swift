import SwiftUI

struct TarotCardComponent: View {
    let drawnCard: DrawnCard
    let onFlip: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text(drawnCard.spreadPosition)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 110, height: 32)

            ZStack {
                CardFrontView(card: drawnCard.card, isReversed: drawnCard.isReversed)
                    .opacity(drawnCard.isFlipped ? 1.0 : 0.0)
                    .rotation3DEffect(.degrees(drawnCard.isFlipped ? 0 : 180), axis: (x: 0, y: 1, z: 0))

                CardBackView()
                    .opacity(drawnCard.isFlipped ? 0.0 : 1.0)
                    .rotation3DEffect(.degrees(drawnCard.isFlipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
            }
            .frame(width: 105, height: 170)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    onFlip()
                }
            }

            Text(drawnCard.isFlipped ? (drawnCard.isReversed ? "【逆位】" : "【正位】") : "点击翻牌")
                .font(.caption2)
                .foregroundColor(drawnCard.isFlipped ? (drawnCard.isReversed ? .red : .green) : .secondary)
        }
    }
}

private struct CardBackView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(
                LinearGradient(colors: [Color.indigo.opacity(0.85), Color.purple.opacity(0.95)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.yellow.opacity(0.6), lineWidth: 1)
                    .padding(3)
            )
            .overlay(
                Image(systemName: "sparkles")
                    .font(.system(size: 24))
                    .foregroundColor(.yellow.opacity(0.8))
            )
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 3)
    }
}

private struct CardFrontView: View {
    let card: TarotCard
    let isReversed: Bool

    private var suitIcon: String {
        if card.name.contains("权杖") { return "flame.fill" }
        if card.name.contains("圣杯") { return "drop.fill" }
        if card.name.contains("宝剑") { return "wind" }
        if card.name.contains("星币") { return "circle.hexagongrid.fill" }
        return "sun.max.fill"
    }

    private var suitColor: Color {
        if card.name.contains("权杖") { return .orange }
        if card.name.contains("圣杯") { return .blue }
        if card.name.contains("宝剑") { return .teal }
        if card.name.contains("星币") { return .yellow }
        return .purple
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(white: 0.96)) // 修复：使用合法的 ShapeStyle 颜色
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.yellow.opacity(0.7), lineWidth: 1)
                    .padding(3)
            )
            .overlay(
                VStack(spacing: 6) {
                    Text(card.name)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black) // 保证在浅色卡牌底色上有高清晰度
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)

                    Image(systemName: suitIcon)
                        .font(.system(size: 24))
                        .foregroundColor(suitColor)
                        .rotationEffect(isReversed ? .degrees(180) : .zero)
                }
                .padding(4)
            )
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 3)
    }
}

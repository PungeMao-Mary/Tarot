import SwiftUI
import Combine

#if canImport(UIKit)
import UIKit
#endif

class TarotSessionManager: ObservableObject {
    @Published var currentStep: RitualStep = .intention
    @Published var selectedSpread: SpreadType = .relationshipThree
    @Published var intentionText: String = ""

    @Published var deck: [TarotCard] = []
    @Published var drawnCards: [DrawnCard] = []

    @Published var isShuffling: Bool = false
    @Published var isCutCompleted: Bool = false

    init() {
        resetDeck()
    }

    func resetDeck() {
        // 使用完整的 78 张塔罗牌（大阿卡纳 22 + 小阿卡纳 56）
        self.deck = TarotDeckData.fullDeck.shuffled()
    }

    func triggerHaptic() {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()
        impact.impactOccurred()
        #endif
    }

    func triggerSuccessHaptic() {
        #if os(iOS)
        let notification = UINotificationFeedbackGenerator()
        notification.prepare()
        notification.notificationOccurred(.success)
        #endif
    }

    func nextStep() {
        triggerHaptic()
        switch currentStep {
        case .intention:
            currentStep = .shuffling
        case .shuffling:
            currentStep = .cutting
        case .cutting:
            currentStep = .picking
        case .picking:
            currentStep = .reading
        case .reading:
            drawnCards.removeAll()
            intentionText = ""
            resetDeck()
            currentStep = .intention
        }
    }

    func performShuffle() {
        isShuffling = true
        triggerHaptic()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.deck.shuffle()
            self.isShuffling = false
            self.triggerHaptic()
        }
    }

    func performCut(at position: Double) {
        let splitIndex = Int(Double(deck.count) * position)
        let safeIndex = max(1, min(splitIndex, deck.count - 1))

        let firstSlice = deck[..<safeIndex]
        let secondSlice = deck[safeIndex...]
        deck = Array(secondSlice + firstSlice)

        isCutCompleted = true
        triggerSuccessHaptic()
    }

    func pickCard(from index: Int) {
        guard drawnCards.count < selectedSpread.positions.count else { return }

        let card = deck.remove(at: index % deck.count)
        let isReversed = Bool.random()
        let positionName = selectedSpread.positions[drawnCards.count]

        drawnCards.append(DrawnCard(card: card, isReversed: isReversed, spreadPosition: positionName))
        triggerHaptic()

        if drawnCards.count == selectedSpread.positions.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.nextStep()
            }
        }
    }

    func flipCard(at index: Int) {
        guard index < drawnCards.count else { return }
        drawnCards[index].isFlipped.toggle()
        triggerHaptic()
    }
}

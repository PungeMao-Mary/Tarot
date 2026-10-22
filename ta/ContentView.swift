import SwiftUI

struct ContentView: View {
    @StateObject private var sessionManager = TarotSessionManager()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()

                switch sessionManager.currentStep {
                case .intention:
                    IntentionPhaseView(manager: sessionManager)
                case .shuffling, .cutting:
                    ShuffleAndCutPhaseView(manager: sessionManager)
                case .picking:
                    CardPickingPhaseView(manager: sessionManager)
                case .reading:
                    ReadingPhaseView(manager: sessionManager)
                }
            }
            .navigationTitle("人际塔罗启示")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

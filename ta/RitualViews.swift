import SwiftUI

// 阶段 1: 静心与设念 (人际专属引导)
struct IntentionPhaseView: View {
    @ObservedObject var manager: TarotSessionManager
    @State private var isBreathingIn = false

    var body: some View {
        VStack(spacing: 24) {
            Text("人际关系 · 静心设念")
                .font(.title2)
                .fontWeight(.bold)

            Text("在心中观想对方的样貌或你们相处的场景\n保持客观与平静，放下先入为主的偏见")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: isBreathingIn ? 160 : 110, height: isBreathingIn ? 160 : 110)

                Circle()
                    .stroke(Color.purple.opacity(0.5), lineWidth: 1.5)
                    .frame(width: isBreathingIn ? 130 : 90, height: isBreathingIn ? 130 : 90)

                Text(isBreathingIn ? "呼气..." : "吸气...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .animation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true), value: isBreathingIn)
            .onAppear { isBreathingIn = true }

            TextField("输入你想问的人际困惑或对方名字...", text: $manager.intentionText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 32)

            Button("心念已定，开始洗牌") {
                manager.nextStep()
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
        }
        .padding()
    }
}

// 阶段 2 & 3: 洗牌与切牌
struct ShuffleAndCutPhaseView: View {
    @ObservedObject var manager: TarotSessionManager

    var body: some View {
        VStack(spacing: 24) {
            if manager.currentStep == .shuffling {
                Text("顺应直觉洗牌")
                    .font(.title2)
                    .fontWeight(.bold)

                ZStack {
                    ForEach(0..<6, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.indigo)
                            .frame(width: 100, height: 150)
                            .offset(x: manager.isShuffling ? CGFloat.random(in: -35...35) : CGFloat(i * 2),
                                    y: manager.isShuffling ? CGFloat.random(in: -15...15) : CGFloat(i * 2))
                            .animation(.easeInOut(duration: 0.25), value: manager.isShuffling)
                    }
                }
                .frame(height: 180)

                Button("点此洗牌") {
                    manager.performShuffle()
                }
                .buttonStyle(.bordered)

                Button("洗牌完毕，前往切牌") {
                    manager.nextStep()
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
            } else if manager.currentStep == .cutting {
                Text("直觉切牌")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("请在牌堆任意位置点击或滑动分割牌阵")
                    .font(.caption)
                    .foregroundColor(.secondary)

                GeometryReader { geo in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.indigo.opacity(0.2))

                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.purple, lineWidth: 2)

                        Text("点击此区域切牌")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 100)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let fraction = value.location.x / geo.size.width
                                manager.performCut(at: max(0.1, min(0.9, fraction)))
                            }
                    )
                }
                .frame(height: 100)
                .padding(.horizontal, 40)

                if manager.isCutCompleted {
                    Button("切牌完成，抽取三张牌") {
                        manager.nextStep()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                }
            }
        }
    }
}

// 阶段 4: 抽牌
struct CardPickingPhaseView: View {
    @ObservedObject var manager: TarotSessionManager

    var body: some View {
        VStack(spacing: 20) {
            Text("凭直觉抽取 3 张牌")
                .font(.title2)
                .fontWeight(.bold)

            Text("当前抽取第 \(manager.drawnCards.count + 1) 张：\(manager.selectedSpread.positions[min(manager.drawnCards.count, 2)])")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -45) {
                    ForEach(0..<manager.deck.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.indigo)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.yellow.opacity(0.4), lineWidth: 1))
                            .frame(width: 75, height: 120)
                            .shadow(radius: 3)
                            .onTapGesture {
                                manager.pickCard(from: index)
                            }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 30)
            }
        }
    }
}

// 阶段 5: 人际关系深度解读
struct ReadingPhaseView: View {
    @ObservedObject var manager: TarotSessionManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if !manager.intentionText.isEmpty {
                    Text("问念：\(manager.intentionText)")
                        .font(.headline)
                        .padding(.horizontal)
                }

                // 3张卡牌横向展示
                HStack(spacing: 12) {
                    ForEach(Array(manager.drawnCards.enumerated()), id: \.element.id) { index, drawn in
                        TarotCardComponent(drawnCard: drawn) {
                            manager.flipCard(at: index)
                        }
                    }
                }
                .padding(.horizontal, 8)

                // 人际解读卡片
                VStack(spacing: 14) {
                    ForEach(manager.drawnCards) { item in
                        if item.isFlipped {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(item.spreadPosition)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.purple)
                                    Spacer()
                                    Text("\(item.card.name) · \(item.isReversed ? "逆位" : "正位")")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(item.isReversed ? .red : .green)
                                }

                                Text("【人际启示】" + (item.isReversed ? item.card.reversedRelationship : item.card.uprightRelationship))
                                    .font(.footnote)

                                Text("【行动指引】" + item.card.advice)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(12)
                            .background(Color.primary.opacity(0.04))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2), lineWidth: 0.5))
                        }
                    }
                }
                .padding(.horizontal)

                Button("重置仪式") {
                    manager.nextStep()
                }
                .buttonStyle(.bordered)
                .padding(.top, 10)
            }
            .padding(.vertical)
        }
    }
}

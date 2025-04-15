import SwiftUI

struct AnimatedBackgroundView: View {
    @State private var phase = 0.0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.background, Color.background.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated circles
            ForEach(0..<5) { i in
                Circle()
                    .fill(Color.primary.opacity(0.05))
                    .frame(width: 100 + CGFloat(i * 50), height: 100 + CGFloat(i * 50))
                    .offset(
                        x: sin(phase + Double(i)) * 10,
                        y: cos(phase + Double(i)) * 10
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                phase = 2 * .pi
            }
        }
    }
}

struct CustomButton: View {
    let text: String
    let icon: String?
    let isPrimary: Bool
    let action: () -> Void
    
    init(text: String, icon: String? = nil, isPrimary: Bool = true, action: @escaping () -> Void) {
        self.text = text
        self.icon = icon
        self.isPrimary = isPrimary
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            HapticFeedbackManager.shared.playSelection()
            action()
        }) {
            HStack {
                if let icon = icon, icon.hasPrefix("chevron.left") {
                    Image(systemName: icon)
                    Text(text)
                } else {
                    Text(text)
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                }
            }
            .font(.headline)
            .foregroundColor(isPrimary ? .white : .primary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(isPrimary ? Color.primary : Color.cardBackground)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct ProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Circle()
                    .fill(index < currentStep ? Color.primary : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct ConfettiView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { i in
                ConfettiPiece(color: confettiColor(for: i), rotation: Double.random(in: 0...360))
                    .offset(
                        x: isAnimating ? randomOffset() : 0,
                        y: isAnimating ? UIScreen.main.bounds.height : -50
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 2...4))
                            .delay(Double.random(in: 0...1))
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private func confettiColor(for index: Int) -> Color {
        let colors: [Color] = [.primary, .secondary, .accent]
        return colors[index % colors.count]
    }
    
    private func randomOffset() -> CGFloat {
        return CGFloat.random(in: -UIScreen.main.bounds.width/2...UIScreen.main.bounds.width/2)
    }
}

struct ConfettiPiece: View {
    let color: Color
    let rotation: Double
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 8, height: 8)
            .rotationEffect(.degrees(rotation))
    }
}

// Extension to add subtle animations to views
extension View {
    func addPulseAnimation() -> some View {
        self.modifier(PulseAnimation())
    }
}

struct PulseAnimation: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

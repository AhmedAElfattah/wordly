import SwiftUI

// MARK: - Color Extensions
extension Color {
    static let background = Color(hex: "F8F9FA")
    static let cardBackground = Color(hex: "FFFFFF")
    static let textPrimary = Color(hex: "212529")
    static let textSecondary = Color(hex: "6C757D")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Extensions
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - Rounded Corner Shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Animation Utilities
struct AnimationUtils {
    static func staggeredDelay(for index: Int, baseDelay: Double = 0.1) -> Double {
        return baseDelay * Double(index)
    }
    
    static func springAnimation(dampingFraction: Double = 0.7, response: Double = 0.5) -> Animation {
        return Animation.spring(response: response, dampingFraction: dampingFraction)
    }
}

// MARK: - Confetti View
struct ConfettiView: View {
    @State private var isAnimating = false
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
    let confettiCount = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<confettiCount, id: \.self) { index in
                ConfettiPiece(
                    color: colors[index % colors.count],
                    position: randomPosition(),
                    angle: randomAngle(),
                    size: randomSize(),
                    isAnimating: $isAnimating
                )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private func randomPosition() -> CGPoint {
        return CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: -100...0)
        )
    }
    
    private func randomAngle() -> Double {
        return Double.random(in: 0...360)
    }
    
    private func randomSize() -> CGFloat {
        return CGFloat.random(in: 5...15)
    }
}

struct ConfettiPiece: View {
    let color: Color
    let position: CGPoint
    let angle: Double
    let size: CGFloat
    
    @Binding var isAnimating: Bool
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size)
            .position(x: position.x, y: position.y)
            .rotationEffect(.degrees(angle))
            .offset(y: isAnimating ? UIScreen.main.bounds.height + 100 : 0)
            .animation(
                Animation.timingCurve(0.1, 0.8, 0.2, 1, duration: Double.random(in: 2...4))
                    .delay(Double.random(in: 0...1))
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
    }
}

// MARK: - Card Looping Manager
struct CardLoopingManager {
    // Ensures proper looping of cards when reaching the end of the list
    static func getNextIndex(currentIndex: Int, totalCount: Int) -> Int {
        return (currentIndex + 1) % totalCount
    }
    
    static func getPreviousIndex(currentIndex: Int, totalCount: Int) -> Int {
        return (currentIndex - 1 + totalCount) % totalCount
    }
    
    // Provides smooth transition animation when looping
    static func getLoopTransition(isLooping: Bool) -> AnyTransition {
        if isLooping {
            return AnyTransition.asymmetric(
                insertion: .opacity.combined(with: .scale(scale: 0.8).animation(.spring(response: 0.4, dampingFraction: 0.7))),
                removal: .opacity.combined(with: .scale(scale: 1.2).animation(.spring(response: 0.4, dampingFraction: 0.7)))
            )
        } else {
            return AnyTransition.opacity.combined(with: .move(edge: .bottom))
        }
    }
}

// MARK: - Animated Background View
struct AnimatedBackgroundView: View {
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            colors: [
                Color(hex: "F8F9FA"),
                Color(hex: "E9ECEF"),
                Color(hex: "DEE2E6"),
                Color(hex: "E9ECEF"),
                Color(hex: "F8F9FA")
            ],
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(
                .linear(duration: 5.0)
                .repeatForever(autoreverses: true)
            ) {
                animateGradient.toggle()
            }
        }
    }
}

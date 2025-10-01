//
//  SkeletonAppearance.swift
//  SkeletonAppearance
//
//  Created by Bhavani Reddy Navure on 9/25/25.
//

import SwiftUI

// MARK: - Skeleton Appearance Configuration
public struct SkeletonAppearance {
    public var tintColor: Color = Color.gray.opacity(0.3)
    public var gradient: SkeletonGradient = SkeletonGradient()
    public var cornerRadius: CGFloat = 4
    public var multilineHeight: CGFloat = 15
    public var multilineSpacing: CGFloat = 10
    public var multilineLastLineFillPercent: Double = 0.7
    public var textLineHeight: TextLineHeight = .relativeToFont
    
    public static var `default` = SkeletonAppearance()
    
    public enum TextLineHeight {
        case relativeToFont
        case fixed(CGFloat)
    }
    
    public init() {}
    
    public init(
        tintColor: Color,
        gradient: SkeletonGradient = SkeletonGradient(),
        cornerRadius: CGFloat = 4,
        multilineHeight: CGFloat = 15,
        multilineSpacing: CGFloat = 10,
        multilineLastLineFillPercent: Double = 0.7
    ) {
        self.tintColor = tintColor
        self.gradient = gradient
        self.cornerRadius = cornerRadius
        self.multilineHeight = multilineHeight
        self.multilineSpacing = multilineSpacing
        self.multilineLastLineFillPercent = multilineLastLineFillPercent
    }
}

// MARK: - Skeleton Gradient
public struct SkeletonGradient {
    public let baseColor: Color
    public let highlightColor: Color
    
    public init(baseColor: Color = Color.gray.opacity(0.3)) {
        self.baseColor = baseColor
        self.highlightColor = baseColor.opacity(0.1)
    }
    
    public init(baseColor: Color, highlightColor: Color) {
        self.baseColor = baseColor
        self.highlightColor = highlightColor
    }
}

// MARK: - Animation Types with Color Support
public enum SkeletonAnimation {
    case pulse(duration: Double = 1.0, color: Color? = nil)
    case sliding(direction: GradientDirection = .leftToRight, duration: Double = 1.5, gradient: SkeletonGradient? = nil)
    case shimmer(duration: Double = 1.2, color: Color? = nil)
    case wave(duration: Double = 1.8, color: Color? = nil)
    
    // Convenience methods for quick color customization
    public func withColor(_ color: Color) -> SkeletonAnimation {
        switch self {
        case .pulse(let duration, _):
            return .pulse(duration: duration, color: color)
        case .sliding(let direction, let duration, _):
            return .sliding(direction: direction, duration: duration, gradient: SkeletonGradient(baseColor: color))
        case .shimmer(let duration, _):
            return .shimmer(duration: duration, color: color)
        case .wave(let duration, _):
            return .wave(duration: duration, color: color)
        }
    }
    
    public func withGradient(_ gradient: SkeletonGradient) -> SkeletonAnimation {
        switch self {
        case .pulse(let duration, _):
            return .pulse(duration: duration, color: gradient.baseColor)
        case .sliding(let direction, let duration, _):
            return .sliding(direction: direction, duration: duration, gradient: gradient)
        case .shimmer(let duration, _):
            return .shimmer(duration: duration, color: gradient.baseColor)
        case .wave(let duration, _):
            return .wave(duration: duration, color: gradient.baseColor)
        }
    }
}

public enum GradientDirection: CaseIterable {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
    case topLeftToBottomRight
    case bottomRightToTopLeft
    case topRightToBottomLeft
    case bottomLeftToTopRight
    
    var startPoint: UnitPoint {
        switch self {
        case .leftToRight: return .leading
        case .rightToLeft: return .trailing
        case .topToBottom: return .top
        case .bottomToTop: return .bottom
        case .topLeftToBottomRight: return .topLeading
        case .bottomRightToTopLeft: return .bottomTrailing
        case .topRightToBottomLeft: return .topTrailing
        case .bottomLeftToTopRight: return .bottomLeading
        }
    }
    
    var endPoint: UnitPoint {
        switch self {
        case .leftToRight: return .trailing
        case .rightToLeft: return .leading
        case .topToBottom: return .bottom
        case .bottomToTop: return .top
        case .topLeftToBottomRight: return .bottomTrailing
        case .bottomRightToTopLeft: return .topLeading
        case .topRightToBottomLeft: return .bottomLeading
        case .bottomLeftToTopRight: return .topTrailing
        }
    }
}

// MARK: - Transition Styles
public enum SkeletonTransition {
    case none
    case opacity(duration: Double = 0.25)
    case scale(duration: Double = 0.25, scale: Double = 0.95)
    case slide(edge: Edge = .leading, duration: Double = 0.25)
}

// MARK: - Core Skeleton View
public struct SkeletonView: View {
    private let isActive: Bool
    private let animation: SkeletonAnimation
    private let appearance: SkeletonAppearance
    private let transition: SkeletonTransition
    private let lines: Int
    private let content: AnyView
    
    @State private var animationOffset: CGFloat = -200
    @State private var pulseOpacity: Double = 0.3
    @State private var waveOffset: CGFloat = -100
//    @State private var waveOffset: CGFloat = -200

    @State private var shimmerOffset: CGFloat = -200
    
    public init<Content: View>(
        isActive: Bool,
        animation: SkeletonAnimation = .pulse(),
        appearance: SkeletonAppearance = .default,
        transition: SkeletonTransition = .opacity(),
        lines: Int = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.isActive = isActive
        self.animation = animation
        self.appearance = appearance
        self.transition = transition
        self.lines = max(1, lines) // Ensure at least 1 line
        self.content = AnyView(content())
    }
    
    public var body: some View {
        Group {
            if isActive {
                skeletonContent
                    .transition(transitionStyle)
            } else {
                content
                    .transition(transitionStyle)
            }
        }
    }
    
    @ViewBuilder
    private var skeletonContent: some View {
        if lines > 1 {
            multilineSkeletonView
        } else {
            singleSkeletonView
        }
    }
    
    private var singleSkeletonView: some View {
        RoundedRectangle(cornerRadius: appearance.cornerRadius)
            .fill(Color.clear)
            .frame(height: appearance.multilineHeight)
            .background(gradientFill)
            .clipShape(RoundedRectangle(cornerRadius: appearance.cornerRadius))
            .onAppear { startAnimation() }
    }
    
    private var multilineSkeletonView: some View {
        VStack(alignment: .leading, spacing: appearance.multilineSpacing) {
            ForEach(0..<lines, id: \.self) { index in
                RoundedRectangle(cornerRadius: appearance.cornerRadius)
                    .fill(Color.clear)
                    .frame(height: appearance.multilineHeight)
                    .background(gradientFill)
                    .clipShape(RoundedRectangle(cornerRadius: appearance.cornerRadius))
                    .if(index == lines - 1) { view in
                        view.scaleEffect(x: appearance.multilineLastLineFillPercent, y: 1, anchor: .leading)
                    }
            }
        }
        .onAppear { startAnimation() }
    }
    
    @ViewBuilder
    private var gradientFill: some View {
        switch animation {
        case .pulse(_, let color):
            (color ?? appearance.tintColor)
                .opacity(pulseOpacity)
            
        case .sliding(let direction, _, let gradient):
            slidingGradient(direction: direction, customGradient: gradient)
            
        case .shimmer(_, let color):
            shimmerGradient(customColor: color)
            
        case .wave(_, let color):
            waveGradient(customColor: color)
        }
    }
    
    private func slidingGradient(direction: GradientDirection, customGradient: SkeletonGradient? = nil) -> some View {
        let gradient = customGradient ?? appearance.gradient
        
        return LinearGradient(
            colors: [
                gradient.baseColor.opacity(0.8),
                gradient.highlightColor,
                gradient.baseColor.opacity(0.8)
            ],
            startPoint: direction.startPoint,
            endPoint: direction.endPoint
        )
        .mask(
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, .white, .white, .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(x: animationOffset)
                .animation(.linear(duration: getDuration()).repeatForever(autoreverses: false), value: animationOffset)
        )
    }
    
    private func shimmerGradient(customColor: Color? = nil) -> some View {
        let baseColor = customColor ?? appearance.gradient.baseColor
        
        return baseColor
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.6), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 100)
                    .offset(x: shimmerOffset)
                    .animation(.linear(duration: getDuration()).repeatForever(autoreverses: false), value: shimmerOffset)
            )
            .clipShape(RoundedRectangle(cornerRadius: appearance.cornerRadius))
    }
    
    private func waveGradient(customColor: Color? = nil) -> some View {
        let baseColor = customColor ?? appearance.gradient.baseColor
        
        return baseColor
            .overlay(
                LinearGradient(
                    colors: [.clear, Color.white.opacity(0.8), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 200)
                .offset(x: waveOffset)
                .blendMode(.screen)
                .animation(
                    .linear(duration: getDuration())
                        .repeatForever(autoreverses: false),
                    value: waveOffset
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: appearance.cornerRadius))
    }
    
    private var transitionStyle: AnyTransition {
        switch transition {
        case .none:
            return .identity
        case .opacity(let duration):
            return .opacity.animation(.easeInOut(duration: duration))
        case .scale(let duration, let scale):
            return .scale(scale: scale).animation(.easeInOut(duration: duration))
        case .slide(let edge, let duration):
            return .move(edge: edge).animation(.easeInOut(duration: duration))
        }
    }
    
    private func getDuration() -> Double {
        switch animation {
        case .pulse(let duration, _): return duration
        case .sliding(_, let duration, _): return duration
        case .shimmer(let duration, _): return duration
        case .wave(let duration, _): return duration
        }
    }
    
    private func startAnimation() {
        switch animation {
        case .pulse(let duration, _):
            withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                pulseOpacity = 0.8
            }
            
        case .sliding(_, let duration, _):
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                animationOffset = 400
            }
            
        case .shimmer(let duration, _):
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                shimmerOffset = 400
            }
        
        case .wave(let duration, _):
            waveOffset = -100
            withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: false)) {
                waveOffset = 400
            }
    }
    }
}

// MARK: - View Extensions
extension View {
    /// Adds animated skeleton loading effect to any view
    public func skeleton(
        isActive: Bool,
        animation: SkeletonAnimation = .pulse(),
        appearance: SkeletonAppearance = .default,
        transition: SkeletonTransition = .opacity(),
        lines: Int = 1
    ) -> some View {
        SkeletonView(
            isActive: isActive,
            animation: animation,
            appearance: appearance,
            transition: transition,
            lines: lines
        ) {
            self
        }
    }
    
    /// Skeleton with custom color - most convenient method
    public func skeleton(
        isActive: Bool,
        animation: SkeletonAnimation = .pulse(),
        color: Color,
        lines: Int = 1
    ) -> some View {
        let customAnimation = animation.withColor(color)
        return skeleton(
            isActive: isActive,
            animation: customAnimation,
            lines: lines
        )
    }
    
    /// Skeleton with custom gradient
    public func skeleton(
        isActive: Bool,
        animation: SkeletonAnimation = .sliding(),
        gradient: SkeletonGradient,
        lines: Int = 1
    ) -> some View {
        let customAnimation = animation.withGradient(gradient)
        return skeleton(
            isActive: isActive,
            animation: customAnimation,
            lines: lines
        )
    }
    
    /// Convenient method for animated skeleton with custom animation
    public func animatedSkeleton(
        isActive: Bool,
        animation: SkeletonAnimation = .pulse(),
        appearance: SkeletonAppearance = .default,
        lines: Int = 1
    ) -> some View {
        skeleton(
            isActive: isActive,
            animation: animation,
            appearance: appearance,
            transition: .opacity(),
            lines: lines
        )
    }
    
    /// Convenient method for gradient skeleton
    public func gradientSkeleton(
        isActive: Bool,
        gradient: SkeletonGradient = SkeletonGradient(),
        animation: SkeletonAnimation = .sliding(),
        lines: Int = 1
    ) -> some View {
        let customAnimation = animation.withGradient(gradient)
        return skeleton(
            isActive: isActive,
            animation: customAnimation,
            lines: lines
        )
    }
}

// MARK: - Skeleton List Support
public struct SkeletonList<Content: View>: View {
    let isActive: Bool
    let rowCount: Int
    let animation: SkeletonAnimation
    let appearance: SkeletonAppearance
    let rowHeight: CGFloat
    let content: () -> Content
    
    public init(
        isActive: Bool,
        rowCount: Int = 10,
        rowHeight: CGFloat = 60,
        animation: SkeletonAnimation = .pulse(),
        appearance: SkeletonAppearance = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isActive = isActive
        self.rowCount = rowCount
        self.rowHeight = rowHeight
        self.animation = animation
        self.appearance = appearance
        self.content = content
    }
    
    public var body: some View {
        if isActive {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(0..<rowCount, id: \.self) { _ in
                        HStack {
                            Circle()
                                .fill(appearance.tintColor)
                                .frame(width: 40, height: 40)
                                .skeleton(isActive: true, animation: animation)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                SkeletonView(
                                    isActive: true,
                                    animation: animation,
                                    appearance: appearance,
                                    lines: 1
                                ) {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(height: 16)
                                }
                                
                                SkeletonView(
                                    isActive: true,
                                    animation: animation,
                                    appearance: appearance,
                                    lines: 1
                                ) {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(height: 12)
                                        .scaleEffect(x: 0.7, y: 1, anchor: .leading)
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(height: rowHeight)
                        .padding(.horizontal)
                    }
                }
            }
        } else {
            content()
        }
    }
}

// MARK: - Text-specific Skeleton
public struct SkeletonText: View {
    let isActive: Bool
    let lines: Int
    let animation: SkeletonAnimation
    let appearance: SkeletonAppearance
    let text: String
    
    public init(
        _ text: String,
        isActive: Bool,
        lines: Int = 1,
        animation: SkeletonAnimation = .pulse(),
        appearance: SkeletonAppearance = .default
    ) {
        self.text = text
        self.isActive = isActive
        self.lines = lines
        self.animation = animation
        self.appearance = appearance
    }
    
    public var body: some View {
        SkeletonView(
            isActive: isActive,
            animation: animation,
            appearance: appearance,
            lines: lines
        ) {
            Text(text)
        }
    }
}

// MARK: - Helper Extension for Conditional Modifiers
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
// MARK: - Advanced Features

// MARK: - Skeleton Shape Types
public enum SkeletonShape {
    case rectangle
    case roundedRectangle(cornerRadius: CGFloat)
    case capsule
    case circle
    case custom(shape: AnyShape)
}

public struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    public init<S: Shape>(_ shape: S) {
        _path = { rect in
            shape.path(in: rect)
        }
    }
    
    public func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

// MARK: - Skeleton Effect Modifiers
public enum SkeletonEffect {
    case standard
    case bordered(color: Color, width: CGFloat)
    case shadowed(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)
    case glowing(color: Color, radius: CGFloat)
    case glassmorphism
}

// MARK: - Smart Skeleton (Auto-detects content type)
public struct SmartSkeletonModifier: ViewModifier {
    let isActive: Bool
    let animation: SkeletonAnimation
    let intelligentLines: Bool
    
    public func body(content: Content) -> some View {
        if isActive {
            content
                .hidden()
                .overlay(
                    GeometryReader { geometry in
                        SkeletonView(
                            isActive: true,
                            animation: animation,
                            lines: intelligentLines ? calculateLines(for: geometry.size) : 1
                        ) {
                            EmptyView()
                        }
                    }
                )
        } else {
            content
        }
    }
    
    private func calculateLines(for size: CGSize) -> Int {
        // Intelligently calculate number of lines based on height
        let lineHeight: CGFloat = 20
        let spacing: CGFloat = 8
        let lines = Int((size.height + spacing) / (lineHeight + spacing))
        return max(1, min(lines, 10)) // Cap between 1-10 lines
    }
}

// MARK: - Skeleton with Accessibility Support
public struct AccessibleSkeletonModifier: ViewModifier {
    let isActive: Bool
    let animation: SkeletonAnimation
    let accessibilityLabel: String
    
    public func body(content: Content) -> some View {
        content
            .skeleton(isActive: isActive, animation: animation)
            .accessibilityLabel(isActive ? "Loading \(accessibilityLabel)" : "")
            .accessibilityAddTraits(isActive ? .updatesFrequently : [])
    }
}

// MARK: - Skeleton with Delay (Prevents flash for fast loads)
public struct DelayedSkeletonModifier: ViewModifier {
    let isActive: Bool
    let animation: SkeletonAnimation
    let delay: TimeInterval
    let lines: Int
    
    @State private var shouldShow = false
    @State private var task: Task<Void, Never>?
    
    public func body(content: Content) -> some View {
        content
            .skeleton(isActive: shouldShow && isActive, animation: animation, lines: lines)
            .onChange(of: isActive) { newValue in
                task?.cancel()
                
                if newValue {
                    task = Task {
                        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                        if !Task.isCancelled {
                            withAnimation {
                                shouldShow = true
                            }
                        }
                    }
                } else {
                    shouldShow = false
                }
            }
    }
}

// MARK: - Skeleton Group (Synchronized animations)
public struct SkeletonGroup<Content: View>: View {
    let isActive: Bool
    let animation: SkeletonAnimation
    let staggerDelay: TimeInterval
    let content: Content
    
    @State private var animationPhase: Double = 0
    
    public init(
        isActive: Bool,
        animation: SkeletonAnimation = .pulse(),
        staggerDelay: TimeInterval = 0.1,
        @ViewBuilder content: () -> Content
    ) {
        self.isActive = isActive
        self.animation = animation
        self.staggerDelay = staggerDelay
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.skeletonGroupPhase, animationPhase)
            .onAppear {
                if isActive {
                    startGroupAnimation()
                }
            }
    }
    
    private func startGroupAnimation() {
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
            animationPhase = 1.0
        }
    }
}

// Environment key for skeleton group synchronization
private struct SkeletonGroupPhaseKey: EnvironmentKey {
    static let defaultValue: Double = 0
}

extension EnvironmentValues {
    var skeletonGroupPhase: Double {
        get { self[SkeletonGroupPhaseKey.self] }
        set { self[SkeletonGroupPhaseKey.self] = newValue }
    }
}

// MARK: - Skeleton with Shape Support
public struct ShapeSkeletonModifier: ViewModifier {
    let isActive: Bool
    let animation: SkeletonAnimation
    let shape: SkeletonShape
    let effect: SkeletonEffect
    
    public func body(content: Content) -> some View {
        if isActive {
            shapeView
                .overlay(content.hidden())
        } else {
            content
        }
    }
    
    @ViewBuilder
    private var shapeView: some View {
        GeometryReader { geometry in
            ZStack {
                switch shape {
                case .rectangle:
                    Rectangle()
                        .fill(Color.clear)
                        .background(skeletonAnimation)
                        .clipShape(Rectangle())
                        .applyEffect(effect)
                        
                case .roundedRectangle(let radius):
                    RoundedRectangle(cornerRadius: radius)
                        .fill(Color.clear)
                        .background(skeletonAnimation)
                        .clipShape(RoundedRectangle(cornerRadius: radius))
                        .applyEffect(effect)
                        
                case .capsule:
                    Capsule()
                        .fill(Color.clear)
                        .background(skeletonAnimation)
                        .clipShape(Capsule())
                        .applyEffect(effect)
                        
                case .circle:
                    Circle()
                        .fill(Color.clear)
                        .background(skeletonAnimation)
                        .clipShape(Circle())
                        .applyEffect(effect)
                        
                case .custom(let anyShape):
                    anyShape
                        .fill(Color.clear)
                        .background(skeletonAnimation)
                        .clipShape(anyShape)
                        .applyEffect(effect)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    @ViewBuilder
    private var skeletonAnimation: some View {
        SkeletonView(
            isActive: true,
            animation: animation,
            lines: 1
        ) {
            EmptyView()
        }
    }
}

// MARK: - Effect Application
extension View {
    @ViewBuilder
    func applyEffect(_ effect: SkeletonEffect) -> some View {
        switch effect {
        case .standard:
            self
        case .bordered(let color, let width):
            self.overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(color, lineWidth: width)
            )
        case .shadowed(let color, let radius, let x, let y):
            self.shadow(color: color, radius: radius, x: x, y: y)
        case .glowing(let color, let radius):
            self
                .shadow(color: color.opacity(0.5), radius: radius)
                .shadow(color: color.opacity(0.3), radius: radius * 2)
        case .glassmorphism:
            self
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - Enhanced View Extensions
extension View {
    /// Smart skeleton that auto-detects content dimensions
    public func smartSkeleton(
        isActive: Bool,
        animation: SkeletonAnimation = .pulse()
    ) -> some View {
        modifier(SmartSkeletonModifier(
            isActive: isActive,
            animation: animation,
            intelligentLines: true
        ))
    }
    
    /// Skeleton with accessibility support
    public func accessibleSkeleton(
        isActive: Bool,
        animation: SkeletonAnimation = .pulse(),
        label: String
    ) -> some View {
        modifier(AccessibleSkeletonModifier(
            isActive: isActive,
            animation: animation,
            accessibilityLabel: label
        ))
    }
    
    /// Skeleton with delay (prevents flash on fast loads)
    public func delayedSkeleton(
        isActive: Bool,
        animation: SkeletonAnimation = .pulse(),
        delay: TimeInterval = 0.3,
        lines: Int = 1
    ) -> some View {
        modifier(DelayedSkeletonModifier(
            isActive: isActive,
            animation: animation,
            delay: delay,
            lines: lines
        ))
    }
    
    /// Skeleton with custom shape
    public func skeleton(
        isActive: Bool,
        animation: SkeletonAnimation = .pulse(),
        shape: SkeletonShape,
        effect: SkeletonEffect = .standard
    ) -> some View {
        modifier(ShapeSkeletonModifier(
            isActive: isActive,
            animation: animation,
            shape: shape,
            effect: effect
        ))
    }
    
    /// Skeleton with rounded corners shorthand
    public func skeletonRounded(
        isActive: Bool,
        animation: SkeletonAnimation = .pulse(),
        cornerRadius: CGFloat = 8,
        lines: Int = 1
    ) -> some View {
        var appearance = SkeletonAppearance.default
        appearance.cornerRadius = cornerRadius
        return skeleton(isActive: isActive, animation: animation, appearance: appearance, lines: lines)
    }
}

struct ColorCustomizationExamples: View {
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Quick color customization
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quick Color Customization")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        Text("Red pulse")
                            .skeleton(isActive: isLoading, animation: .pulse(), color: .red.opacity(0.4))
                        
                        Text("Blue shimmer")
                            .skeleton(isActive: isLoading, animation: .shimmer(), color: .blue.opacity(0.4))
                        
                        Text("Green wave")
                            .skeleton(isActive: isLoading, animation: .wave(), color: .green.opacity(0.4))
                        
                        Text("Purple sliding")
                            .skeleton(isActive: isLoading, animation: .sliding(), color: .purple.opacity(0.4))
                    }
                }
                
                // Gradient customization
                VStack(alignment: .leading, spacing: 8) {
                    Text("Custom Gradients")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        let gradient1 = SkeletonGradient(
                            baseColor: .blue.opacity(0.3),
                            highlightColor: .cyan.opacity(0.1)
                        )
                        Text("Blue to cyan gradient")
                            .skeleton(isActive: isLoading, gradient: gradient1)
                        
                        let gradient2 = SkeletonGradient(
                            baseColor: .pink.opacity(0.3),
                            highlightColor: .purple.opacity(0.1)
                        )
                        Text("Pink to purple gradient")
                            .skeleton(isActive: isLoading, animation: .sliding(direction: .topToBottom), gradient: gradient2)
                        
                        let gradient3 = SkeletonGradient(
                            baseColor: .orange.opacity(0.3),
                            highlightColor: .yellow.opacity(0.1)
                        )
                        Text("Orange to yellow gradient")
                            .skeleton(isActive: isLoading, animation: .wave(), gradient: gradient3)
                    }
                }
                
                // Animation with color chaining
                VStack(alignment: .leading, spacing: 8) {
                    Text("Animation + Color Chaining")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        Text("Pulse with custom color")
                            .skeleton(
                                isActive: isLoading,
                                animation: .pulse(duration: 1.5).withColor(.mint.opacity(0.4))
                            )
                        
                        Text("Fast shimmer with teal")
                            .skeleton(
                                isActive: isLoading,
                                animation: .shimmer(duration: 0.8).withColor(.teal.opacity(0.4))
                            )
                        
                        Text("Slow wave with indigo")
                            .skeleton(
                                isActive: isLoading,
                                animation: .wave(duration: 2.5).withColor(.indigo.opacity(0.4))
                            )
                    }
                }
                
                Button(isLoading ? "Hide Skeletons" : "Show Skeletons") {
                    withAnimation {
                        isLoading.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Color Customization")
        .navigationBarTitleDisplayMode(.inline)
    }
}
// MARK: - Animation Gallery
struct AnimationGalleryView: View {
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                AnimationExampleView(
                    title: "Pulse Animation",
                    description: "Gentle opacity breathing effect",
                    isLoading: isLoading,
                    animation: .pulse(duration: 1.0)
                )
                
                AnimationExampleView(
                    title: "Left to Right Sliding",
                    description: "Gradient slides from left to right",
                    isLoading: isLoading,
                    animation: .sliding(direction: .leftToRight, duration: 1.5)
                )
                
                AnimationExampleView(
                    title: "Right to Left Sliding",
                    description: "Gradient slides from right to left",
                    isLoading: isLoading,
                    animation: .sliding(direction: .rightToLeft, duration: 1.5)
                )
                
                AnimationExampleView(
                    title: "Top to Bottom Sliding",
                    description: "Gradient slides from top to bottom",
                    isLoading: isLoading,
                    animation: .sliding(direction: .topToBottom, duration: 1.8)
                )
                
                AnimationExampleView(
                    title: "Shimmer Effect",
                    description: "Facebook-style shimmer animation",
                    isLoading: isLoading,
                    animation: .shimmer(duration: 1.2)
                )
                
                AnimationExampleView(
                    title: "Wave Animation",
                    description: "Smooth flowing wave effect",
                    isLoading: isLoading,
                    animation: .wave(duration: 2.0)
                )
                
                AnimationExampleView(
                    title: "Diagonal Sliding",
                    description: "Gradient slides diagonally across view",
                    isLoading: isLoading,
                    animation: .sliding(direction: .topLeftToBottomRight, duration: 2.0)
                )
                
                Button(isLoading ? "Hide Animations" : "Show Animations") {
                    withAnimation(.spring()) {
                        isLoading.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Animation Gallery")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AnimationExampleView: View {
    let title: String
    let description: String
    let isLoading: Bool
    let animation: SkeletonAnimation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                // Single line example
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 18)
                    .skeleton(
                        isActive: isLoading,
                        animation: animation
                    )
                
                // Varied width lines
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 18)
                    .scaleEffect(x: 0.85, y: 1, anchor: .leading)
                    .skeleton(
                        isActive: isLoading,
                        animation: animation
                    )
                
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 18)
                    .scaleEffect(x: 0.65, y: 1, anchor: .leading)
                    .skeleton(
                        isActive: isLoading,
                        animation: animation
                    )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Advanced Examples and Utilities

struct AdvancedExamplesView: View {
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Custom shaped skeleton
                VStack(alignment: .leading, spacing: 8) {
                    Text("Custom Shapes")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .skeleton(isActive: isLoading, animation: .shimmer())
                        
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 30)
                            .skeleton(isActive: isLoading, animation: .wave())
                        
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .skeleton(isActive: isLoading, animation: .pulse())
                    }
                }
                
                // Message bubble example
                MessageBubbleExample(isLoading: isLoading)
                
                // Settings row example
                SettingsRowExample(isLoading: isLoading)
                
                // Product card example
                ProductCardExample(isLoading: isLoading)
                
                Button(isLoading ? "Show Content" : "Show Skeleton") {
                    withAnimation {
                        isLoading.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Advanced Examples")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageBubbleExample: View {
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Message Bubbles")
                .font(.headline)
            
            VStack(spacing: 8) {
                // Incoming message
                HStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 32, height: 32)
                        .skeleton(isActive: isLoading, animation: .pulse())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hey! How are you doing?")
                            .padding(12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(16)
                            .skeleton(isActive: isLoading)
                        
                        Text("Just now")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .skeleton(isActive: isLoading)
                    }
                    
                    Spacer()
                }
                
                // Outgoing message
                HStack {
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("I'm doing great! Thanks for asking. How about you?")
                            .padding(12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(16)
                            .skeleton(isActive: isLoading, lines: 2)
                        
                        Text("Just now")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .skeleton(isActive: isLoading)
                    }
                }
            }
        }
    }
}

struct SettingsRowExample: View {
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Settings Rows")
                .font(.headline)
            
            VStack(spacing: 1) {
                ForEach(0..<4, id: \.self) { _ in
                    HStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 28, height: 28)
                            .skeleton(isActive: isLoading, animation: .shimmer())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Setting Name")
                                .font(.body)
                                .skeleton(isActive: isLoading)
                            
                            Text("Setting description")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .skeleton(isActive: isLoading)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .skeleton(isActive: isLoading)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color(.systemBackground))
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct ProductCardExample: View {
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Product Card")
                .font(.headline)
            
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .skeleton(isActive: isLoading, animation: .wave())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Product Name")
                        .font(.headline)
                        .skeleton(isActive: isLoading)
                    
                    Text("Product description and details")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .skeleton(isActive: isLoading, lines: 2)
                    
                    HStack {
                        Text("$29.99")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .skeleton(isActive: isLoading)
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            ForEach(0..<5, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                                    .skeleton(isActive: isLoading)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Skeleton Modifier Helpers

extension View {
    /// Applies skeleton with custom corner radius
    public func skeletonCornerRadius(_ radius: CGFloat, isActive: Bool) -> some View {
        var appearance = SkeletonAppearance.default
        appearance.cornerRadius = radius
        return skeleton(isActive: isActive, appearance: appearance)
    }
    
    /// Applies skeleton with custom height for multiline content
    public func skeletonHeight(_ height: CGFloat, isActive: Bool, lines: Int = 1) -> some View {
        var appearance = SkeletonAppearance.default
        appearance.multilineHeight = height
        return skeleton(isActive: isActive, appearance: appearance, lines: lines)
    }
}

// MARK: - Performance Optimized Skeleton Components

struct OptimizedSkeletonRow: View {
    let isActive: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
                .redacted(reason: isActive ? .placeholder : [])
            
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)
                    .redacted(reason: isActive ? .placeholder : [])
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scaleEffect(x: 0.7, y: 1, anchor: .leading)
                    .redacted(reason: isActive ? .placeholder : [])
            }
        }
    }
}

# SwiftUISkeletonLoader 💀

<p align="center">
  <img src="assets/skeleton-ui-banner.svg" alt="SkeletonUI Animated Banner" width="800"/>
</p>
<p align="center">
    <img src="https://img.shields.io/badge/iOS-15.0+-blue.svg" alt="iOS 15.0+"/>
    <img src="https://img.shields.io/badge/macOS-12.0+-blue.svg" alt="macOS 12.0+"/>
    <img src="https://img.shields.io/badge/tvOS-15.0+-blue.svg" alt="tvOS 15.0+"/>
    <img src="https://img.shields.io/badge/watchOS-8.0+-blue.svg" alt="watchOS 8.0+"/>
    <img src="https://img.shields.io/badge/Swift-5.9+-orange.svg" alt="Swift 5.9+"/>
    <img src="https://img.shields.io/badge/SwiftUI-5.0+-orange.svg" alt="SwiftUI 5.0+"/>
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="MIT License"/>
</p>
<p align="center">
  <b>An elegant, powerful skeleton loading animation library for SwiftUI</b>
  <br>
</p>


**SkeletonUI** provides a seamless way to show users that content is loading while preparing them for what's coming. With just a few lines of code, you can add beautiful, customizable skeleton animations to any SwiftUI view.

## 🌟 Why SkeletonUI?

- **🎨 Beautiful Animations** - 4 distinct, professionally designed animation styles
- **🎯 Dead Simple API** - Just add `.skeleton(isActive: true)` to any view
- **🔧 Fully Customizable** - Colors, gradients, shapes, effects, and timing
- **🧠 Smart Detection** - Auto-calculates skeleton lines based on content
- **⚡ Performance Optimized** - Smooth 60fps animations with minimal overhead
- **♿ Accessibility Built-in** - Screen reader support out of the box
- **📦 Zero Dependencies** - Pure SwiftUI, no external libraries
- **🎓 Well Documented** - Comprehensive examples and guides

## ✨ Features

- **Easy to use** - Just add `.skeleton(isActive: true)` to any view
- **4 Animation Types** - Pulse, Sliding, Shimmer, Wave
- **Highly customizable** - Colors, gradients, animations, shapes, and more
- **SwiftUI native** - Built specifically for SwiftUI with modern Swift features
- **Universal** - Works on iOS, macOS, tvOS, and watchOS
- **Lightweight** - Small footprint, readable codebase
- **Multiline support** - Perfect for text content of any length
- **List support** - Built-in skeleton list component
- **Custom shapes** - Circle, Capsule, RoundedRectangle, or any custom shape
- **Visual effects** - Bordered, Glowing, Glassmorphism, Shadowed
- **Smart skeleton** - Auto-detects content dimensions
- **Delayed loading** - Prevents UI flash for fast-loading content
- **Synchronized groups** - Coordinate multiple skeleton animations

## 🎬 Animation Types

SkeletonUI offers 4 distinct animation styles, each designed for different use cases:

| Animation | Description | Best For | Visual Style |
|-----------|-------------|----------|--------------|
| **Pulse** | Gentle breathing opacity effect that fades in and out | Simple loading states, minimal distraction | Subtle, calm |
| **Sliding** | Gradient band slides smoothly across the skeleton in 8 directions | Directional content loading, modern UI | Dynamic, directional |
| **Shimmer** | Facebook-style shimmer effect with a bright highlight sweep | Social feeds, card layouts, professional apps | Polished, familiar |
| **Wave** | Smooth flowing wave with gradual fade-in/out across the skeleton | Elegant loading, premium feel | Sophisticated, flowing |

### Animation Details

#### 🫧 Pulse Animation
A gentle, breathing effect where the skeleton smoothly fades between two opacity levels. Perfect for minimal, distraction-free loading states.

**Characteristics:**
- Opacity animates from 30% to 80%
- Smooth easeInOut timing
- Auto-reverses for continuous breathing effect
- Default duration: 1.0 second

**Use when:** You want subtle, non-distracting loading feedback

#### ➡️ Sliding Animation
A gradient band that slides across the skeleton. Supports 8 directions for maximum flexibility.

**Directions:** `leftToRight`, `rightToLeft`, `topToBottom`, `bottomToTop`, `topLeftToBottomRight`, `bottomRightToTopLeft`, `topRightToBottomLeft`, `bottomLeftToTopRight`

**Characteristics:**
- Linear movement with gradient fade
- Customizable direction
- Suggests directional content loading
- Default duration: 1.5 seconds

**Use when:** You want to suggest content is flowing in from a direction

#### ✨ Shimmer Animation
Inspired by Facebook's loading shimmer, a bright highlight sweeps across the skeleton with high contrast.

**Characteristics:**
- Bright white highlight with 60% opacity
- Linear movement for consistent speed
- High visibility and familiarity
- Default duration: 1.2 seconds

**Use when:** You want a polished, professional look that users recognize

#### 🌊 Wave Animation
A smooth, flowing wave with gradual fade-in and fade-out, creating an elegant, premium feel.

**Characteristics:**
- 9-step gradient for smooth wave curve
- EaseInOut timing for natural flow
- Wider coverage (80% of skeleton width)
- Gradual fade creates depth
- Default duration: 1.8 seconds

**Use when:** You want an elegant, sophisticated loading experience

## 🎨 Customization Examples

### Animation with Custom Colors

```swift
// Pulse with custom color
Text("Loading...").skeleton(
    isActive: true,
    animation: .pulse(),
    color: .blue.opacity(0.4)
)

// Shimmer with custom color
Text("Loading...").skeleton(
    isActive: true,
    animation: .shimmer(),
    color: .purple.opacity(0.4)
)

// Wave with custom color
Text("Loading...").skeleton(
    isActive: true,
    animation: .wave(),
    color: .green.opacity(0.4)
)
```

### Custom Gradients

```swift
let gradient = SkeletonGradient(
    baseColor: .blue.opacity(0.3),
    highlightColor: .cyan.opacity(0.1)
)

Text("Loading...").skeleton(
    isActive: true,
    animation: .sliding(direction: .leftToRight),
    gradient: gradient
)
```

### Animation Timing

```swift
// Fast pulse
Text("Quick").skeleton(
    isActive: true,
    animation: .pulse(duration: 0.6)
)

// Slow wave
Text("Relaxed").skeleton(
    isActive: true,
    animation: .wave(duration: 3.0)
)

// Custom sliding speed
Text("Custom").skeleton(
    isActive: true,
    animation: .sliding(direction: .topToBottom, duration: 2.0)
)
```

## 📲 Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/YourUsername/SkeletonUI.git", from: "1.0.0")
]
```

### Xcode

1. In Xcode, go to **File → Add Package Dependencies...**
2. Enter: `https://github.com/YourUsername/SkeletonUI.git`
3. Click **Add Package**

## 🚀 Quick Start

Just 3 steps to add skeleton loading:

### 1️⃣ Import SkeletonUI

```swift
import SkeletonUI
```

### 2️⃣ Add skeleton to your views

```swift
Text("Loading content...")
    .skeleton(isActive: true)
```

### 3️⃣ Choose your animation

```swift
// Solid skeleton
Text("Content").skeleton(isActive: isLoading)

// Animated pulse
Text("Content").animatedSkeleton(isActive: isLoading)

// Gradient sliding
Text("Content").gradientSkeleton(isActive: isLoading)
```

## 📖 Usage Examples

### Basic Skeleton

```swift
struct ContentView: View {
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .skeleton(isActive: isLoading)
            
            Button("Toggle") {
                isLoading.toggle()
            }
        }
    }
}
```

### Multiline Text

```swift
Text("This is a long text that spans multiple lines")
    .skeleton(isActive: isLoading, lines: 3)
```

### Animated Skeletons

```swift
// Pulse animation
Text("Pulse effect")
    .animatedSkeleton(
        isActive: isLoading, 
        animation: .pulse(duration: 1.0)
    )

// Sliding gradient
Text("Sliding gradient")
    .gradientSkeleton(
        isActive: isLoading,
        animation: .sliding(direction: .leftToRight)
    )

// Shimmer effect
Text("Shimmer effect")
    .skeleton(
        isActive: isLoading,
        animation: .shimmer(duration: 1.2)
    )
```

### Custom Appearance

```swift
let customAppearance = SkeletonAppearance(
    tintColor: .blue.opacity(0.3),
    cornerRadius: 8,
    multilineHeight: 20
)

Text("Custom skeleton")
    .skeleton(
        isActive: isLoading,
        appearance: customAppearance
    )
```

### Skeleton Lists

```swift
struct ListView: View {
    @State private var isLoading = true
    @State private var items: [Item] = []
    
    var body: some View {
        SkeletonList(
            isActive: isLoading,
            rowCount: 10,
            rowHeight: 80
        ) {
            List(items) { item in
                ItemRow(item: item)
            }
        }
    }
}
```

### Card Skeleton

```swift
struct CardView: View {
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image placeholder
            Rectangle()
                .frame(height: 200)
                .skeleton(isActive: isLoading, animation: .shimmer())
            
            // Title
            Text("Card Title")
                .font(.headline)
                .skeleton(isActive: isLoading)
            
            // Description
            Text("Card description text")
                .skeleton(isActive: isLoading, lines: 2)
        }
        .cornerRadius(12)
    }
}
```

## 🎨 Customization

### Colors

SkeletonUI comes with 20 predefined colors inspired by flat design:

```swift
Text("Colorful skeleton")
    .skeleton(
        isActive: true,
        appearance: SkeletonAppearance(tintColor: .skeletonTurquoise)
    )
```

Available colors: `.skeletonTurquoise`, `.skeletonEmerald`, `.skeletonPeterRiver`, `.skeletonAmethyst`, `.skeletonSunFlower`, `.skeletonCarrot`, `.skeletonAlizarin`, and more.

### Gradients

```swift
let gradient = SkeletonGradient(
    baseColor: .blue.opacity(0.3),
    highlightColor: .blue.opacity(0.1)
)

Text("Gradient skeleton")
    .gradientSkeleton(isActive: true, gradient: gradient)
```

### Animations

```swift
// Different sliding directions
.skeleton(isActive: true, animation: .sliding(direction: .leftToRight))
.skeleton(isActive: true, animation: .sliding(direction: .topToBottom))
.skeleton(isActive: true, animation: .sliding(direction: .topLeftToBottomRight))

// Custom durations
.skeleton(isActive: true, animation: .pulse(duration: 2.0))
.skeleton(isActive: true, animation: .wave(duration: 3.0))
```

### Transitions

```swift
Text("Smooth transition")
    .skeleton(
        isActive: isLoading,
        transition: .opacity(duration: 0.5)
    )

Text("Scale transition")
    .skeleton(
        isActive: isLoading,
        transition: .scale(duration: 0.3, scale: 0.95)
    )
```

## 🔧 Advanced Features

### Global Configuration

```swift
// Set global defaults
SkeletonAppearance.default.tintColor = .gray.opacity(0.2)
SkeletonAppearance.default.cornerRadius = 8
SkeletonAppearance.default.multilineHeight = 18
```

### Conditional Skeletons

```swift
struct ProfileView: View {
    @State private var user: User?
    
    var body: some View {
        VStack {
            Text(user?.name ?? "Loading...")
                .skeleton(isActive: user == nil)
            
            Text(user?.bio ?? "Loading bio...")
                .skeleton(isActive: user == nil, lines: 3)
        }
    }
}
```

### Complex Layouts

```swift
struct ComplexView: View {
    let isLoading: Bool
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .skeleton(isActive: isLoading)
                
                VStack(alignment: .leading) {
                    Text("Name")
                        .skeleton(isActive: isLoading)
                    Text("Subtitle")
                        .skeleton(isActive: isLoading)
                }
                
                Spacer()
            }
            
            Text("Description content here")
                .skeleton(isActive: isLoading, lines: 4)
        }
    }
}
```

## 📊 Performance

SkeletonUI is designed to be performant:

- **Efficient animations** using SwiftUI's native animation system
- **Minimal memory footprint** with lightweight view modifiers
- **Optimized rendering** with conditional view updates
- **Smooth frame rates** even with complex layouts

## 🔧 Migration from SkeletonView

If you're coming from the UIKit SkeletonView library, here's how to migrate:

| SkeletonView (UIKit) | SkeletonUI (SwiftUI) |
|---------------------|----------------------|
| `view.showSkeleton()` | `.skeleton(isActive: true)` |
| `view.showAnimatedSkeleton()` | `.animatedSkeleton(isActive: true)` |
| `view.showGradientSkeleton()` | `.gradientSkeleton(isActive: true)` |
| `view.hideSkeleton()` | `.skeleton(isActive: false)` |

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

## 📝 License

SkeletonUI is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## 🙏 Acknowledgments

- Inspired by [SkeletonView](https://github.com/Juanpe/SkeletonView) by Juanpe Catalán
- Built with ❤️ for the SwiftUI community

---

**Star** ⭐ this repository if it helped you!

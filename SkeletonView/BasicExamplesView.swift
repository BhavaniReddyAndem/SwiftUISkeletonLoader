//
//  BasicExamplesView.swift
//  SkeletonView
//
//  Created by Bhavani Reddy Navure on 9/25/25.
//

import SwiftUI

struct BasicExamplesView: View {
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Solid Skeleton")
                            .font(.headline)
                        
                        Text("This is a sample text that will be skeletonized")
                            .skeleton(isActive: isLoading)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Animated Pulse Skeleton")
                            .font(.headline)
                        
                        Text("This text has a pulsing animation")
                            .animatedSkeleton(isActive: isLoading, animation: .pulse())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gradient Sliding Skeleton")
                            .font(.headline)
                        
                        Text("This text has a sliding gradient effect")
                            .gradientSkeleton(
                                isActive: isLoading,
                                animation: .sliding(direction: .leftToRight)
                            )
                    }
                }
                
                Group {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Shimmer Skeleton")
                            .font(.headline)
                        
                        Text("This text has a shimmer effect")
                            .skeleton(isActive: isLoading, animation: .shimmer())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Wave Skeleton")
                            .font(.headline)
                        
                        Text("This text has a wave animation")
                            .skeleton(isActive: isLoading, animation: .wave())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Multiline Skeleton")
                            .font(.headline)
                        
                        VStack(alignment: .leading) {
                            Text("Line 1 of multiline content")
                            Text("Line 2 of multiline content")
                            Text("Line 3 of multiline content")
                        }
                        .skeleton(isActive: isLoading, lines: 3)
                    }
                }
                
                Group {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Custom Color Skeleton")
                            .font(.headline)
                        
                        let customAppearance = SkeletonAppearance(
                            tintColor: .blue.opacity(0.3),
                            cornerRadius: 8
                        )
                        
                        Text("Custom colored skeleton")
                            .skeleton(
                                isActive: isLoading,
                                animation: .pulse(),
                                appearance: customAppearance
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Colorful Skeletons")
                            .font(.headline)
                        
                        VStack(spacing: 4) {
                            Text("Turquoise skeleton")
                                .skeleton(
                                    isActive: isLoading,
                                    appearance: SkeletonAppearance(tintColor: .skeletonTurquoise)
                                )
                            
                            Text("Emerald skeleton")
                                .skeleton(
                                    isActive: isLoading,
                                    appearance: SkeletonAppearance(tintColor: .skeletonEmerald)
                                )
                            
                            Text("Amethyst skeleton")
                                .skeleton(
                                    isActive: isLoading,
                                    appearance: SkeletonAppearance(tintColor: .skeletonAmethyst)
                                )
                        }
                    }
                }
                
                Button(isLoading ? "Hide Skeletons" : "Show Skeletons") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isLoading.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Basic Examples")
        .navigationBarTitleDisplayMode(.inline)
    }
}

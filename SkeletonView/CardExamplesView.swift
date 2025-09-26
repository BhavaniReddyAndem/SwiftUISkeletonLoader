//
//  CardExamplesView.swift
//  SkeletonView
//
//  Created by Bhavani Reddy Navure on 9/25/25.
//
import SwiftUI

struct CardExamplesView: View {
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<5, id: \.self) { index in
                    CardView(isLoading: isLoading, index: index)
                }
            }
            .padding()
            
            Button(isLoading ? "Load Cards" : "Show Skeleton") {
                withAnimation {
                    isLoading.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Card Examples")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CardView: View {
    let isLoading: Bool
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 200)
                .skeleton(
                    isActive: isLoading,
                    animation: .wave()
                )
                .overlay(
                    Group {
                        if !isLoading {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    }
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Amazing Card Title \(index + 1)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .skeleton(isActive: isLoading)
                
                Text("This is a detailed description of the card content. It demonstrates how skeleton loading works with different text lengths and provides a great user experience during loading states.")
                    .font(.body)
                    .skeleton(isActive: isLoading, lines: 3)
                
                HStack {
                    Text("By Author \(index + 1)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .skeleton(isActive: isLoading)
                    
                    Spacer()
                    
                    Text("\(2 + index) hours ago")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .skeleton(isActive: isLoading)
                }
            }
            .padding(.horizontal, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

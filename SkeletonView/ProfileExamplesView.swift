//
//  ProfileExamplesView.swift
//  SkeletonView
//
//  Created by Bhavani Reddy Navure on 9/25/25.
//
import SwiftUI

struct ProfileExamplesView: View {
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ProfileHeaderView(isLoading: isLoading)
                ProfileStatsView(isLoading: isLoading)
                ProfileBioView(isLoading: isLoading)
                ProfilePostsView(isLoading: isLoading)
                
                Button(isLoading ? "Load Profile" : "Show Skeleton") {
                    withAnimation {
                        isLoading.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Profile Examples")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileHeaderView: View {
    let isLoading: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 120, height: 120)
                .skeleton(
                    isActive: isLoading,
                    animation: .pulse()
                )
                .overlay(
                    Group {
                        if !isLoading {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 120))
                                .foregroundColor(.blue)
                        }
                    }
                )
            
            VStack(spacing: 4) {
                Text("John Doe")
                    .font(.title)
                    .fontWeight(.bold)
                    .skeleton(isActive: isLoading)
                
                Text("Senior iOS Developer")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .skeleton(isActive: isLoading)
                
                Text("San Francisco, CA")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .skeleton(isActive: isLoading)
            }
        }
    }
}

struct ProfileStatsView: View {
    let isLoading: Bool
    
    var body: some View {
        HStack(spacing: 40) {
            VStack {
                Text("1,234")
                    .font(.title2)
                    .fontWeight(.bold)
                    .skeleton(isActive: isLoading)
                
                Text("Followers")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .skeleton(isActive: isLoading)
            }
            
            VStack {
                Text("567")
                    .font(.title2)
                    .fontWeight(.bold)
                    .skeleton(isActive: isLoading)
                
                Text("Following")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .skeleton(isActive: isLoading)
            }
            
            VStack {
                Text("89")
                    .font(.title2)
                    .fontWeight(.bold)
                    .skeleton(isActive: isLoading)
                
                Text("Posts")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .skeleton(isActive: isLoading)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct ProfileBioView: View {
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.headline)
                .skeleton(isActive: isLoading)
            
            Text("Passionate iOS developer with 8+ years of experience creating beautiful and functional mobile applications. Specialized in SwiftUI, UIKit, and exploring cutting-edge technologies. Always excited to tackle new challenges and build amazing user experiences.")
                .font(.body)
                .skeleton(isActive: isLoading, lines: 4)
            
            HStack(spacing: 12) {
                Text("🏢 Apple Inc.")
                    .font(.caption)
                    .skeleton(isActive: isLoading)
                
                Text("📍 California")
                    .font(.caption)
                    .skeleton(isActive: isLoading)
                
                Text("🔗 johndoe.dev")
                    .font(.caption)
                    .skeleton(isActive: isLoading)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ProfilePostsView: View {
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Posts")
                .font(.headline)
                .skeleton(isActive: isLoading)
            
            VStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Exploring SwiftUI's Latest Features in iOS 17")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .skeleton(isActive: isLoading)
                        
                        Text("A deep dive into the new SwiftUI capabilities and how they can improve your app development workflow...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .skeleton(isActive: isLoading, lines: 2)
                        
                        HStack {
                            Text("2 days ago")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .skeleton(isActive: isLoading)
                            
                            Spacer()
                            
                            HStack(spacing: 12) {
                                Label("24", systemImage: "heart")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .skeleton(isActive: isLoading)
                                
                                Label("8", systemImage: "message")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .skeleton(isActive: isLoading)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

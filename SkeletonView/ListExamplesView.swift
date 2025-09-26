//
//  ListExamplesView.swift
//  SkeletonView
//
//  Created by Bhavani Reddy Navure on 9/25/25.
//

import SwiftUI

struct ListExamplesView: View {
    @State private var isLoading = true
    @State private var items: [ListItem] = []
    
    var body: some View {
        VStack {
            SkeletonList(
                isActive: isLoading,
                rowCount: 8,
                rowHeight: 80,
                animation: .shimmer()
            ) {
                List(items) { item in
                    ListItemView(item: item)
                }
            }
            
            Button(isLoading ? "Load Data" : "Show Skeleton") {
                if isLoading {
                    loadData()
                } else {
                    withAnimation {
                        isLoading = true
                        items = []
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("List Examples")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            items = (1...20).map {
                ListItem(id: $0, title: "Item \($0)", subtitle: "Subtitle for item \($0)")
            }
            withAnimation {
                isLoading = false
            }
        }
    }
}

//
//  ListItemView.swift
//  SkeletonView
//
//  Created by Bhavani Reddy Navure on 9/25/25.
//

import SwiftUI

struct ListItemView: View {
    let item: ListItem
    
    var body: some View {
        HStack {
            Circle()
                .fill(LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 40, height: 40)
                .overlay(
                    Text("\(item.id)")
                        .foregroundColor(.white)
                        .font(.caption)
                        .fontWeight(.semibold)
                )
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

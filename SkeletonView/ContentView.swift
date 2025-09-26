//
//  ContentView.swift
//  SkeletonView
//
//  Created by Bhavani Reddy Navure on 9/25/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Basic Examples", destination: BasicExamplesView())
                NavigationLink("List Examples", destination: ListExamplesView())
                NavigationLink("Card Examples", destination: CardExamplesView())
                NavigationLink("Profile Examples", destination: ProfileExamplesView())
                NavigationLink("Animation Gallery", destination: AnimationGalleryView())
            }
            .navigationTitle("SkeletonUI")
        }
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  GLMovie
//
//  Created by Wei Lu on 26/05/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .home

    enum Tab {
        case home
        case search
        case watchlist
    }

    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.141, green: 0.165, blue: 0.196, alpha: 1.0)
        appearance.shadowColor = UIColor(Color.blue)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)
            WatchListView()
                .tabItem {
                    Label("Watch list", systemImage: "bookmark")
                }
                .tag(Tab.watchlist)
                .background(Color(red: 0.14, green: 0.16, blue: 0.20))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

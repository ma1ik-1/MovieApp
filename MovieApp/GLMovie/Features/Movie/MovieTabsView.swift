//
//  MovieTabsView.swift
//  GLMovie
//
//  Created by Malik on 13/06/2023.
//

import SwiftUI

enum MovieTabItem: String, CaseIterable, Identifiable {
    case nowPlaying = "Now Playing"
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    case popular = "Popular"

    var id: String {
        self.rawValue
    }
}

struct MovieTabsView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State var selectedTab: MovieTabItem = .nowPlaying

    var body: some View {
        VStack(spacing: 20) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(MovieTabItem.allCases) { item in
                        Button {
                            selectedTab = item
                        } label: {
                            Text(item.rawValue)
                                .foregroundColor(selectedTab == item ? .white : .white)
                                .font(.custom("Poppins", size: 16))
                                .padding(10)
                                .background(selectedTab == item ? Color.gray.opacity(0.8) : Color.clear)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }

            switch selectedTab {
            case .nowPlaying:
                MovieGridView(movies: homeViewModel.nowPlayingMovies)
            case .upcoming:
                MovieGridView(movies: homeViewModel.upcomingMovies)
            case .topRated:
                MovieGridView(movies: homeViewModel.topRateMovies)
            case .popular:
                MovieGridView(movies: homeViewModel.popularMovies)
            }
        }
    }
}

struct MovieTabsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieTabsView().environmentObject(HomeViewModel())
    }
}

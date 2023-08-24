//
//  SearchSplashView.swift
//  GLMovie
//
//  Created by Malik on 31/07/2023.
//

import SwiftUI

struct SearchSplashView: View {
    private var index: Int

    init(index: Int) {
        self.index = index
    }

    var body: some View {
        HStack {
            Spacer()
            VStack {
                if index == 0 {
                    Image("typing")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .padding(.bottom, 20)
                    Text("Enter a search term")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            VStack {
                if index == 1 {
                    Image("magni")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .padding(.bottom, 20)
                    Text("We Are Sorry, We Cannot Find The Movie")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom)
                    Text("Find another movie by entering a different search term")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .background(Color(red: 0.14, green: 0.16, blue: 0.20))
    }
}

struct SearchSplashView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSplashView(index: 1)
    }
}

//
//  AboutMovieView.swift
//  GLMovie
//
//  Created by Malik on 21/06/2023.
//

import SwiftUI

struct AboutMovieView: View {
    private var desc: String
    init(description: String) {
        self.desc = description
    }
    var body: some View {
        // when we access api
        // get the description of the movie
        ScrollView {
            Text(desc)
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.14, green: 0.16, blue: 0.20))
    }
}

struct AboutMovieView_Previews: PreviewProvider {
    static var previews: some View {
        AboutMovieView(description: "Example movie description")
    }
}

//
//  ProfilePicture.swift
//  GLMovie
//
//  Created by Malik on 21/06/2023.
//

import SwiftUI

struct ProfilePicture<Content: View>: View {
    private var url: URL?
    private var placeholder: Content?

    init(url: URL?, placeholder: (() -> Content)? = nil) {
        self.url = url
        self.placeholder = placeholder?()
    }

    //    var body: some View {
    //        image
    //            .resizable()
    //            // .frame(width: 95, height: 120)
    //            .frame(width: 100, height: 100)
    //            .clipShape(Circle())
    //            .shadow(radius: 10)
    //    }
    var body: some View {
        AsyncImage(url: url) { phase in
            Group {
                // TODO: need to handle wrong url format issue. e.g.
                // https://api.themoviedb.org/3/movie/385687/reviews?page=1&region=GB&language=en
                // "avatar_path":"/https://secure.gravatar.com/avatar/992eef352126a53d7e141bf9e8707576.jpg"
                // update the sizing of the images

                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    // placeholder
                    if let placeholder {
                        placeholder
                    } else {
                        Color.gray
                            .frame(width: 44, height: 44)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 10)
                    }
                }
            }
            .frame(width: 90, height: 90)
            .clipShape(Circle())
        }
    }
}

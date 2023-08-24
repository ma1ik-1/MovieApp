//
//  CastView.swift
//  GLMovie
//
//  Created by Malik on 21/06/2023.
//

import SwiftUI

struct CastView: View {
    @StateObject var viewModel: CastViewModel

    init(viewModel: CastViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.error != nil {
                Text("Try again")
            } else {
                VStack(spacing: 8) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(viewModel.cast, id: \.self.id) { cast in
                            castItemView(cast)
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 20)
            }
        }
        .onAppear {
            if viewModel.cast.isEmpty || viewModel.error != nil {
                viewModel.fetchCast()
            }
        }
    }

    private func castItemView(_ cast: Cast) -> some View {
        HStack(spacing: 10) {
            VStack {
                ProfilePicture(url: cast.avatarURL) {
                    Image("pp")
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                }
                .shadow(color: .white.opacity(0.3), radius: 2)
                .padding(.trailing, 10)
                Text(cast.name ?? "-")
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 10)
    }
}


struct CastView_Previews: PreviewProvider {
    static var previews: some View {
        CastView(viewModel: .init(movieID: 550))
    }
}

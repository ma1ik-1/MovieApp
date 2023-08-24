//
//  ReviewsView.swift
//  GLMovie
//
//  Created by Malik on 15/06/2023.
//

import SwiftUI

struct ReviewsView: View {
    @State private var isExpanded = false
    let maxLines: Int
    @StateObject var viewModel: ReviewViewModel

    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        maxLines = 3
    }

    var body: some View {
        Group {
            if viewModel.error != nil {
                Text("Try again")
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.reviews, id: \.self.id) { review in
                        reviewItemView(review)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 20)
            }
        }
        .onAppear {
            if viewModel.reviews.isEmpty || viewModel.error != nil {
                viewModel.fetchReview()
            }
        }
    }

    private func reviewItemView(_ review: Review) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                VStack {
                    ProfilePicture(url: review.authorDetails.avatarURL) {
                        Image("pp")
                            .resizable()
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 10)
                    }
                    if let ratingValue = review.authorDetails.rating {
                        Text(String(format: "%.1f", ratingValue))
                    } else {
                        Text("-")
                    }
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text(review.authorDetails.name ?? "user")
                        .foregroundColor(.white)
                        .font(.custom("Poppins", size: 22))
                        .frame(maxWidth: .infinity, alignment: .leading) // Align name to the leading edge

                    ScrollView {
                        ReadMoreText(content: review.content, maxLines: maxLines, isExpanded: $isExpanded)
                            .foregroundColor(.white)
                            .font(.custom("Poppins", size: 18))
                            .lineLimit(isExpanded ? nil : maxLines)
                            .fixedSize(horizontal: false, vertical: true)
                            .onTapGesture {
                                isExpanded.toggle()
                            }
                    }
                    .frame(height: 100) // Adjust the height as needed
                }
            }
            .padding(.vertical, 8)
        }
        .padding(.vertical, 10)
    }
}

private struct ReadMoreText: View {
    let content: String
    let maxLines: Int
    @Binding var isExpanded: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(content)
                .lineLimit(isExpanded ? nil : maxLines)
            if !isExpanded {
                Text("Read More")
                    .foregroundColor(.blue)
                    .font(.custom("Poppins", size: 14))
                    .onTapGesture {
                        isExpanded = true
                    }
            }
        }
    }
}

struct ReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsView(viewModel: .init(movieID: 550))
    }
}

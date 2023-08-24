//
//  SearchView.swift
//  GLMovie
//
//  Created by Wei Lu on 21/06/2023.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var searchAction: (String) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("What do you want to watch?")
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 18))
                .fontWeight(.semibold)

            HStack {
                TextField("Search", text: $searchText, onCommit: {
                    searchAction(searchText)
                })
                .accentColor(.white)
                .padding(.horizontal)
                .foregroundColor(.white)
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding(.trailing, 16)
            }
            .frame(height: 40)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(20)
        }
        .padding(.horizontal)
    }
}


struct SearchBarView_Previews: PreviewProvider {
    @State static var searchText: String = ""

    static var previews: some View {
        SearchBarView(searchText: $searchText, searchAction: { _ in })
    }
}

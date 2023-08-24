//
//  DetailTabsView.swift
//  GLMovie
//
//  Created by Malik on 15/06/2023.
//

import SwiftUI

struct DetailTabsView: View {
    @Binding var selectedTab: Int
    let tabs = ["About Movie", "Reviews", "Cast"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tabs.indices, id: \.self) { index in
                    Button {
                        selectedTab = index
                    } label: {
                        Text(tabs[index])
                            .foregroundColor(selectedTab == index ? .white : .white)
                            .font(.custom("Poppins", size: 16))
                            .padding(10)
                            .background(selectedTab == index ? Color.gray.opacity(0.8) : Color.clear)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct DetailTabsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTabsView(selectedTab: .constant(0))
    }
}

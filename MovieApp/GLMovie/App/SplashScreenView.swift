//
//  SplashScreenView.swift
//  GLMovie
//
//  Created by Malik on 03/08/2023.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color(red: 0.14, green: 0.16, blue: 0.20)
            VStack {
                Image("spalsh")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)
                Text("Welcome!")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

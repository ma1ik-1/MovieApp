//
//  GLMovieApp.swift
//  GLMovie
//
//  Created by Wei Lu on 26/05/2023.
//

import SwiftUI

@main
struct GLMovieApp: App {
    @State private var showSplash = true
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onReceive(Timer.publish(every: 2, on: .main, in: .common).autoconnect()) { _ in
                        showSplash = false
                    }
            } else {
                ContentView()
            }
        }
    }
}

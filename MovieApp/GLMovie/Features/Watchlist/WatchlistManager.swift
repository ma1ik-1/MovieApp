//
//  WatchlistManager.swift
//  GLMovie
//
//  Created by Malik on 05/07/2023.
//

import Foundation

class WatchlistManager: ObservableObject {
    static let shared = WatchlistManager()

    @Published private var bookmarkedMovies: [Movie] = []

    private init() {
        loadBookmarkedMovies()
    }

    private func loadBookmarkedMovies() {
        guard let data = UserDefaults.standard.data(forKey: "gl.movieapp.saved.movies") else {
            return
        }

        if let bookmarkedMovies = try? JSONDecoder().decode([Movie].self, from: data) {
            self.bookmarkedMovies = bookmarkedMovies
        }
    }

    private func updateBookmarkedMovies() {
        if let encodedData = try? JSONEncoder().encode(bookmarkedMovies) {
            UserDefaults.standard.set(encodedData, forKey: "gl.movieapp.saved.movies")
        }
    }

    func bookmarkMovie(_ movie: Movie) {
        if !bookmarkedMovies.contains(where: { $0.title == movie.title }) {
            bookmarkedMovies.append(movie)
            updateBookmarkedMovies()
        }
    }

    func unbookmarkMovie(_ movie: Movie) {
        bookmarkedMovies.removeAll { $0.title == movie.title }
        updateBookmarkedMovies()
        // remove from user defaults
    }

    func isMovieBookmarked(_ movie: Movie) -> Bool {
        return bookmarkedMovies.contains(where: { $0.title == movie.title })
    }

    func getBookmarkedMovies() -> [Movie] {
        return bookmarkedMovies
    }
    
    func refreshBookmarkedMovies(completion: @escaping () -> Void) {
        // Simulate a network request or any asynchronous operation
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            // Replace this with your actual logic to reload bookmarked movies
            
            // For demonstration purposes, let's assume you're reloading the movies from UserDefaults
            self.loadBookmarkedMovies()
            
            // Call the completion closure on the main queue to update the UI
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

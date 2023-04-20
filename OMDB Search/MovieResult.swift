//
//  Movie.swift
//  OMDB Search
//

import Foundation

struct SearchResult: Decodable {
    let Search: [MovieResult]
    let totalResults: String
    let Response: String
    
    enum CodingKeys: String, CodingKey {
      case Search, totalResults, Response
    }
}

struct MovieResult: Decodable {
    let Title: String
    let Year: String
    let imdbID: String
    let Poster: String
    let `Type`: String
  
  enum CodingKeys: String, CodingKey {
      case Title, Year, imdbID, Poster, `Type`
  }
}

struct ImdbMovieResult: Decodable {
    let Title: String
    let Year: String
    let Rated: String
    let Genre: String
    let Director: String
    let `Type`: String
    let Writer: String
    let Plot: String
    let Country: String
    let imdbRating: String
    let Poster: String
  
  enum CodingKeys: String, CodingKey {
      case Title, Year, Rated, Genre, Director, `Type`, Writer, Plot, Country, imdbRating, Poster
  }
}

struct SearchFilters: Decodable {
    var title: String = ""
    var type: String = "any"
    var year: String = ""
}

//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 10/01/2022.
//

import Foundation
import Localize_Swift

struct ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

struct SearchResult: Codable, CustomStringConvertible {
    
    var description: String {
        return "Kind: \(CodingKeys.kind), Name: \(CodingKeys.trackName), Artist Name: \(CodingKeys.artistName)\n"
    }
    var name: String {
        return trackName ?? collectionName ?? ""
    }
    var storeURL: String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }
    var price: Double {
        return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }
    var genre: String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }
    var artist: String {
        return artistName ?? ""
    }
    var artistName: String? = ""
    var trackName: String? = ""
    var kind: String? = ""
    var trackPrice: Double? = 0.0
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    var trackViewUrl: String? = ""
    var collectionName: String? = ""
    var collectionViewUrl: String? = ""
    var collectionPrice: Double? = 0.0
    var itemPrice: Double? = 0.0
    var itemGenre: String? = ""
    var bookGenre: [String]? = [""]
    var isFounded = false
    
    var type: String {
        let kind = self.kind ?? "audiobook"
        switch kind {
        case "album": return "text_album".localized()
        case "audiobook": return "tex_audio_book".localized()
        case "book": return "text_book".localized()
        case "ebook": return "text_ebook_segment".localized()
        case "feature-movie": return "text_movie".localized()
        case "music-video": return "text_video".localized()
        case "podcast": return "text_podcast".localized()
        case "software": return "text_app".localized()
        case "song": return "text_song".localized()
        case "tv-episode": return "text_tv_episode".localized()
        default: break
        }
        return "text_unknown".localized()
    }
    
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookGenre = "genres"
        case itemPrice = "price"
        case kind, artistName, currency
        case trackName, trackPrice, trackViewUrl
        case collectionName, collectionViewUrl, collectionPrice
    }
    
}


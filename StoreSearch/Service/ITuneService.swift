//
//  ITuneService.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 18/01/2022.
//

import Foundation
import UIKit

struct ITuneService {
    
    static func iTinesUrl(searchText: String, category: Category) -> URL {
        
        let kind: String
        switch category {
        case .music: kind = "musicTrack"
        case .software: kind = "software"
        case .ebooks: kind = "ebook"
        case .all: kind = ""
        }
        
        let locale = Locale.autoupdatingCurrent
        let language = locale.identifier
        let countryCode = locale.regionCode ?? "en_US"
        
        let encodedText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?" +
            "term=\(encodedText)&limit=200&entity=\(kind)" +
            "&lang=\(language)&country=\(countryCode)"
        let url = URL(string: urlString)
        return url!
    }
    
    static func fetchSearchResults(url: URL, completion: @escaping ([SearchResult], Error?) -> Void) {
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error as NSError?, error.code == -999 {
                print("DEBUG: Failure! \(error.localizedDescription)")
                completion([], error)
                
            } else if let htttpResponse = response as? HTTPURLResponse,
                      htttpResponse.statusCode == 200 {
                guard let data = data else {return}
                
                let datas = parse(data: data)
                completion(datas, nil)
                
            } else {
                print("Failure! \(response!)")
            }
        })
        
        dataTask.resume()
    }
    
    static func stopFetchResults(url: URL, isActived: Bool) {
        
        if isActived {
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url)
            dataTask.cancel()
        }
        
    }
    
    private static func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            var searchResults = result.results
            searchResults.sort(by: { (result1, result2) in
                
                return result1.name.localizedStandardCompare(result2.name) == .orderedAscending
            })
            
            searchResults.sort(by: {(result1, result2) in
                
                return result1.artist.localizedStandardCompare(result2.artist) == .orderedAscending
            })
            
            return searchResults
            
        } catch {
            
            print("DEBUG: JSON Parsing error \(error.localizedDescription)")
            return []
            
        }
    }
}

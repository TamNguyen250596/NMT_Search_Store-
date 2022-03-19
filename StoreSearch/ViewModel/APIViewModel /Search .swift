//
//  Search .swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 12/03/2022.
//

import Foundation

struct Search {
    
    var searchResults: [SearchResult] = []
    var hasSearched = false
    var isLoading = false
    
    private var dataTask: URLSessionDataTask? = nil
    
    func performSearch(for text: String, category: Int) -> URL {
        
      return ITuneService.iTinesUrl(searchText: text, category: category)
        
    }
    
}

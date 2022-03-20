//
//  Search .swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 12/03/2022.
//

import UIKit

class Search {
    //MARK: Properties
    var url: URL?
    private(set) var state: State = .notSearchedYet
    
    //MARK: Typelias
    typealias SearchComplete = (Bool) -> Void
    
    
    //MARK: API fuctions
    func performSearch(for text: String, category: Category, completion: @escaping SearchComplete) {
        
        self.state = .loading
        let url = ITuneService.iTinesUrl(searchText: text, category: Category(rawValue: category.rawValue) ?? .all)
        self.url = url

        ITuneService.fetchSearchResults(url: url, completion: { (searchResults, error) in
            
            if let error = error as NSError?, error.code == -999 {
                
                self.state = .notSearchedYet
                DispatchQueue.main.async {
    
                    completion(false)
                    
                }
                
            }
            
            if searchResults.isEmpty {
                
                self.state = .noResults
                
            } else {
                
                self.state = .results(searchResults)
                DispatchQueue.main.async {
       
                    completion(true)
                }
                
            }
            
            
        })
        
    }
    
}

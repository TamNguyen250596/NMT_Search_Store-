//
//  SearchCellViewModel.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 12/01/2022.
//

import UIKit
import Localize_Swift

struct SearchCellViewModel {
    private var search: SearchResult
    
    init(search: SearchResult) {
        self.search = search
    }
    
    var notFound: String {
        return search.isFounded ? "" : "text_nothing_found".localized()
    }
    
    var mainTitle: String {
        return search.trackName ?? ""
    }
    
    var subTitle: String {
        if !search.artist.isEmpty && search.isFounded {
            
            return "text_artist_name_label_format".localizedFormat(search.artist, search.type)
            
            
        } else if search.artist.isEmpty && search.isFounded {
            
            return "text_unknown".localized()
            
        } else {
            
            return ""
            
        }
        
    }
    
    var smallImageURL: URL? {
        
        return URL(string: search.imageSmall)
        
    }
    
    var largeImageURL: URL? {
        
        return URL(string: search.imageLarge)
        
    }
    
    var type: String {
        
        return search.type
        
    }
    
    var genre: String {
        
        return search.genre
        
    }
    
    var price: String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = search.currency
        
        if search.price == 0 {
            
            return "text_free".localized()
            
        } else if let text = formatter.string(from: search.price as NSNumber) {
            
            return text
            
        } else {
            
            return ""
            
        }
        
    }
    
    var iTuneURL: String {
        
        return search.storeURL
        
    }
    
    func dynamicCellHeight(forWidth width: CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: width - 90, height: CGFloat.greatestFiniteMagnitude)
        
        let attributesOfMainTitle = NSAttributedString(string: mainTitle, attributes: [.font: UIFont.systemFont(ofSize: 18)])
        
        let attributesOfSubtitle = NSAttributedString(string: subTitle, attributes: [.font: UIFont.systemFont(ofSize: 15)])
        
        let boundingBoxOfMainTitle = attributesOfMainTitle.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        let boundingBoxOfSubtitle = attributesOfSubtitle.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        let height = ceil(boundingBoxOfMainTitle.height + boundingBoxOfSubtitle.height) + 22
         
        if height <= 80 {
            
            return 80
            
        } else {
            
            return height
        }
    }
    
}

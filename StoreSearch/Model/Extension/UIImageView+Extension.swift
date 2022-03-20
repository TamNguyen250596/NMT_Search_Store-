//
//  UIImageView+Extension.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 01/03/2022.
//

import UIKit

extension UIImageView {
    
    func loadImage(url: URL?) {
        
        guard let url = url else {return}
        
        let session = URLSession.shared
        let downloadTask = session.downloadTask(
            with: url, completionHandler: { [weak self] url, response, error in
            
            if error == nil, let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
                
            }
                
        })
        
        downloadTask.resume()
    }
    
}

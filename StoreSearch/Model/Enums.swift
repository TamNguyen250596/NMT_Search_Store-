//
//  Enums.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 12/03/2022.
//

import Foundation

enum Category: Int {
  case all = 0
  case music = 1
  case software = 2
  case ebooks = 3
}

enum State {
  case notSearchedYet
  case loading
  case noResults
  case results([SearchResult])
}

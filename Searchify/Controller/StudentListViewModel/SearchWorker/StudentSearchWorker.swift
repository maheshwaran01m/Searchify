//
//  StudentSearchWorker.swift
//  Searchify
//
//  Created by MAHESHWARAN on 21/05/23.
//

import Foundation

class StudentSearchWorker {
  
  var searchResult: (([String]?, NSPredicate?) -> Void)?
  
  var searchParameter: SearchParameter {
    didSet {
      assignSelectedOptions()
    }
  }
  
  private var selectedFilterOptions: [SearchFilterOptions] = []
  
  init(searchParameter: SearchParameter, searchResult: (([String]?, NSPredicate?) -> Void)? = nil) {
    self.searchParameter = searchParameter
    self.searchResult = searchResult
    assignSelectedOptions()
  }
  
  private func assignSelectedOptions() {
    let selectedFilterOptions = searchParameter.chosenFilterOptions
    if !selectedFilterOptions.isEmpty {
      self.selectedFilterOptions =  selectedFilterOptions
      return
    }
    self.selectedFilterOptions =  searchParameter.filterOptions
  }
  
  func searchForText(_ searchText: String? = nil) {
    guard let searchText, !searchText.isEmpty else {
      self.searchResult?(nil, nil)
      return
    }
    let searchWords = searchParameter.searchType == .exact ? [searchText] :
    searchText.lowercased().split(separator: " ").map({ String($0) })
    
    var predicateArr = [NSPredicate]()
    searchWords.forEach({ predicateArr.append(composeSearchPredicateFor($0))})
    
    let searchPredicate = NSCompoundPredicate(type: searchParameter.combineType.logicType,
                                              subpredicates: predicateArr)
    self.searchResult?(searchWords, searchPredicate)
  }
  
  func composeSearchPredicateFor(_ searchWord: String) -> NSPredicate {
    
    var predicateArr = [NSPredicate]()
    for searchable in selectedFilterOptions {
      let subPredicate = NSPredicate(
        format: "\(searchable.property) \(searchParameter.searchType.rawValue) $searchString")
      predicateArr.append(subPredicate)
    }
    var searchPredicate = NSCompoundPredicate(type: searchParameter.combineType.logicType,
                                              subpredicates: predicateArr)
    searchPredicate = searchPredicate.withSubstitutionVariables(["searchString": searchWord])
    return searchPredicate
  }
}

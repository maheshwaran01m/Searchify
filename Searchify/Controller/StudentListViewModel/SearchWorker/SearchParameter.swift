//
//  SearchParameter.swift
//  Searchify
//
//  Created by MAHESHWARAN on 21/05/23.
//

import Foundation
import UIKit

protocol SearchFilterOptions {
  var title: String { get set }
  var property: String { get set }
}

class SearchFilterOption: SearchFilterOptions {
  
  var title: String
  var property: String
  
  init(title: String, property: String) {
    self.title = title
    self.property = property
  }
  
  static var searchFilterOptions: [SearchFilterOptions] {
    var searchFilterOptions = [SearchFilterOptions]()
    SearchFilterTitle.allCases.forEach({
      searchFilterOptions.append(SearchFilterOption(title: $0.title, property: $0.keyPath))
    })
    return searchFilterOptions
  }
  
  enum SearchFilterTitle: String, CaseIterable {
    case name, isCompleted, department, course
    
    var title: String {
      switch self {
      case .name: return "Name"
      case .department: return "Department"
      case .course: return "Course"
      case .isCompleted: return "isCompleted"
      }
    }
    
    var keyPath: String {
      switch self {
      case .name: return #keyPath(Student.name)
      case .department: return #keyPath(Student.department)
      case .course: return #keyPath(Student.courseName)
      case .isCompleted: return #keyPath(Student.isCompleted)
      }
    }
  }
}

class SearchParameter {
  
  enum CombineType: String {
    case and = "AND"
    case or = "OR"
    
    var logicType: NSCompoundPredicate.LogicalType {
      switch self {
      case .and: return .and
      case .or: return .or
      }
    }
  }
  
  enum SearchType: String {
    case exact = "LIKE[c]"
    case contains = "CONTAINS[c]"
  }
  
  var filterOptions: [SearchFilterOptions] = []
  var chosenFilterOptions: [SearchFilterOptions] = []
  var combineType: CombineType = .or
  var searchType: SearchType = .contains
}

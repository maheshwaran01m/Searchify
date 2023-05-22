//
//  SearchParameterView.swift
//  Searchify
//
//  Created by MAHESHWARAN on 22/05/23.
//

import Foundation
import UIKit

protocol SearchParametersViewConfigurable: AnyObject {
  func resetSearchParametersView()
  func clearSearchParam(_ searchParam: SearchFilterOption)
}

class SearchParameterView: UIView {
  
  // MARK: - Event Delegation
  
  weak var delegate: SearchParametersViewConfigurable?
  
  // MARK: - Properties
  
  var searchFilterOptions: [SearchFilterOption] = []
  
  // MARK: - Outlets
  
  lazy var container: UIView = {
    $0.setContentHuggingPriority(UILayoutPriority(rawValue: 1000),
                                 for: .horizontal)
    return $0
  }(UIView())
  
  private lazy var collectionView: UICollectionView = {
    let layout = CustomFlowLayout()
    layout.scrollDirection = .horizontal
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    
    let collection = UICollectionView(frame: .zero,
                                      collectionViewLayout: layout)
    collection.contentInsetAdjustmentBehavior = .always
    return collection
  }()
  
  private lazy var resetButton: UIButton = {
    $0.setTitle("Reset", for: .normal)
    $0.setTitleColor(.blue, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    $0.addTarget(self, action: #selector(resetButtonClicked(_:)),
                 for: .touchUpInside)
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.accessibilityIdentifier = "search parameter reset button"
    return $0
  }(UIButton())
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Appearance
  
  private func configureView() {
    self.addSubview(container)
    
    let horizontalStack = UIStackView(arrangedSubviews: [collectionView, resetButton])
    horizontalStack.setCustomSpacing(10, after: collectionView)
    container.addSubview(horizontalStack)
    configureCollectionView()
    
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: self.topAnchor),
      container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      container.leftAnchor.constraint(equalTo: self.leftAnchor),
      container.rightAnchor.constraint(equalTo: self.rightAnchor),
      
      horizontalStack.topAnchor.constraint(equalTo: container.topAnchor),
      horizontalStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
      horizontalStack.leftAnchor.constraint(equalTo: container.leftAnchor),
      horizontalStack.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10)
      
    ])
  }
}

// MARK: - Custom Method

extension SearchParameterView {
  
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = container.backgroundColor
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(SearchParamsListCell.self, forCellWithReuseIdentifier: "SearchParamsListCell")
  }
}

// MARK: - Actions

extension SearchParameterView {
  
  @objc private func resetButtonClicked(_ sender: UIButton) {
    searchFilterOptions.removeAll()
    delegate?.resetSearchParametersView()
  }
}

// MARK: - UICollectionViewDelegate

extension SearchParameterView: UICollectionViewDataSource,
                               UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return searchFilterOptions.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchParamsListCell", for: indexPath) as? SearchParamsListCell else { return UICollectionViewCell() }
    cell.configureView(using: searchFilterOptions[indexPath.row].title)
    cell.delegate = self
    return cell
  }
}

// MARK: - SearchParamsListCellDelegate

extension SearchParameterView: SearchParamsListCellDelegate {
  
  func didTapOnClearButton(_ cell: SearchParamsListCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else { return }
    let filterOption = searchFilterOptions[indexPath.row]
    searchFilterOptions.remove(at: indexPath.row)
    if searchFilterOptions.isEmpty {
      delegate?.resetSearchParametersView()
    } else {
      delegate?.clearSearchParam(filterOption)
    }
  }
}


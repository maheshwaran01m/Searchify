//
//  SearchParameterVC.swift
//  Searchify
//
//  Created by MAHESHWARAN on 22/05/23.
//

import Foundation
import UIKit

class SearchParameterVC: UIViewController {
  
  // MARK: - Event Delegation
  
  var applyButtonTapClosure: ((SearchParameter) -> Void)?
  
  // MARK: - Properties
  
  var searchParameter = SearchParameter()
  var selectedFilterOptions =  [SearchFilterOption]()
  
  // MARK: - Outlets
  
  private let container: UIView = {
    $0.backgroundColor = .systemBackground
    $0.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
    return $0
  }(UIView())
  
  private lazy var clearButton: UIButton = {
    $0.setTitle("Clear", for: .normal)
    $0.setTitleColor(.blue.withAlphaComponent(0.6), for: .normal)
    $0.isEnabled = false
    $0.accessibilityIdentifier =  "searchFilter clear button"
    $0.addTarget(self, action: #selector(clearButtonClicked(_:)),
                 for: .touchUpInside)
    return $0
  }(UIButton())
  
  private lazy var combineTypeSegmentControl: UISegmentedControl = {
    $0.selectedSegmentIndex = 0
    $0.accessibilityIdentifier =  "combineType SegmentController"
    $0.addTarget(self,
                 action: #selector(didChangeCombineTypeSegmentControl(_:)),
                 for: .valueChanged)
    return $0
  }(UISegmentedControl(items: ["Or", "And"]))
  
  private lazy var searchTypeSegmentControl: UISegmentedControl = {
    $0.selectedSegmentIndex = 0
    $0.accessibilityIdentifier =  "searchType SegmentController"
    $0.addTarget(self,
                 action: #selector(didChangeSearchTypeSegmentControl(_:)),
                 for: .valueChanged)
    return $0
  }(UISegmentedControl(items: ["Exact", "Contains"]))
  
  private lazy var collectionView: UICollectionView = {
    let layout = CustomFlowLayout()
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    
    let collection = UICollectionView(frame: .zero,
                                      collectionViewLayout: layout)
    collection.contentInsetAdjustmentBehavior = .always
    return collection
  }()
  
  private lazy var applyButton: UIButton = {
    $0.setTitle("Apply", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .blue
    $0.layer.cornerRadius = 8
    $0.layer.masksToBounds = true
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    $0.addTarget(self, action: #selector(applyButtonClicked(_:)),
                 for: .touchUpInside)
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.accessibilityIdentifier = "search parameter reset button"
    return $0
  }(UIButton())
  
  // MARK: - Init
  
  override func viewDidLoad() {
    super.viewDidLoad()
    selectedFilterOptions = searchParameter.chosenFilterOptions
    configureView()
  }
  
  // MARK: - Appearance
  
  private func configureView() {
    self.view.backgroundColor = .systemBackground
    view.addSubview(container)
    configureDetailView()
    configureCollectionView()
    setupSegmentControl()
    configureClearButton()
  }
  
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(SearchParameterCell.self,
                            forCellWithReuseIdentifier: SearchParameterCell.identifier)
    collectionView.allowsMultipleSelection = true
  }
  
  // MARK: - Construct Views
  
  private func configureDetailView() {
    
    let headerBorderLine: UIView = {
      $0.backgroundColor = .gray
      $0.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
      return $0
    }(UIView())
    
    let headerTitleLabel: UILabel = {
      $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
      $0.textColor = .black
      $0.text = "Search Parameters"
      return $0
    }(UILabel())
    
    let searchTypeTitleLabel: UILabel = {
      $0.text = "Search Type"
      $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
      $0.textColor = .black
      return $0
    }(UILabel())
    
    let searchTypeBorderLine: UIView = {
      $0.backgroundColor = .gray
      $0.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
      return $0
    }(UIView())
    
    let searchByTitleLabel:  UILabel = {
      $0.text = "Search By"
      $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
      $0.textColor = .black
      return $0
    }( UILabel())
    
    updateLayoutConstraints(view: [clearButton, headerTitleLabel, headerBorderLine,
                                   searchTypeTitleLabel, searchTypeSegmentControl, combineTypeSegmentControl,
                                   searchTypeBorderLine, searchByTitleLabel, collectionView, applyButton])
    // Constraint
    NSLayoutConstraint.activate([
      
      container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
      container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
      container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
      container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
      
      clearButton.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: 15),
      clearButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
      clearButton.heightAnchor.constraint(equalToConstant: 24),
      
      headerTitleLabel.centerYAnchor.constraint(equalTo: clearButton.centerYAnchor),
      headerTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
      headerTitleLabel.heightAnchor.constraint(equalToConstant: 24),
      
      headerBorderLine.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 15),
      headerBorderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      headerBorderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      headerBorderLine.heightAnchor.constraint(equalToConstant: 0.5),
      
      searchTypeTitleLabel.topAnchor.constraint(equalTo: headerBorderLine.bottomAnchor, constant: 15),
      searchTypeTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
      searchTypeTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
      searchTypeTitleLabel.heightAnchor.constraint(equalToConstant: 24),
      
      combineTypeSegmentControl.topAnchor.constraint(equalTo: searchTypeTitleLabel.bottomAnchor, constant: 15),
      combineTypeSegmentControl.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
      combineTypeSegmentControl.heightAnchor.constraint(equalToConstant: 30),
      
      searchTypeSegmentControl.leadingAnchor.constraint(equalTo: combineTypeSegmentControl.trailingAnchor, constant: 15),
      searchTypeSegmentControl.centerYAnchor.constraint(equalTo: combineTypeSegmentControl.centerYAnchor),
      searchTypeSegmentControl.heightAnchor.constraint(equalToConstant: 30),
      
      searchTypeBorderLine.topAnchor.constraint(equalTo: combineTypeSegmentControl.bottomAnchor, constant: 15),
      searchTypeBorderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      searchTypeBorderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      searchTypeBorderLine.heightAnchor.constraint(equalToConstant: 0.5),
      
      searchByTitleLabel.topAnchor.constraint(equalTo: searchTypeBorderLine.bottomAnchor, constant: 15),
      searchByTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
      searchByTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      searchByTitleLabel.heightAnchor.constraint(equalToConstant: 24),
      
      collectionView.topAnchor.constraint(equalTo: searchByTitleLabel.bottomAnchor, constant: 10),
      collectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
      collectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
      
      applyButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
      applyButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
      applyButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -15),
      applyButton.heightAnchor.constraint(equalToConstant: 40),
      collectionView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -10),
    ])
    configureClearButton()
  }
  
  private func updateLayoutConstraints(view: [UIView], isEnabled: Bool = false) {
    container.translatesAutoresizingMaskIntoConstraints = isEnabled
    container.isUserInteractionEnabled = !isEnabled
    
    view.forEach {
      container.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = isEnabled
      $0.isUserInteractionEnabled = !isEnabled
    }
  }
  
  // MARK: - Action
  
  @objc func clearButtonClicked(_ sender: UIButton) {
    collectionView.selectItem(at: nil, animated: true, scrollPosition: .top)
    combineTypeSegmentControl.selectedSegmentIndex = 0
    searchTypeSegmentControl.selectedSegmentIndex = 1
    searchParameter.combineType = .or
    searchParameter.searchType = .contains
    clearSelectedFilterOptions()
    clearButton.isEnabled = false
  }
  
  @objc func didChangeCombineTypeSegmentControl(_ sender: UISegmentedControl) {
    searchParameter.combineType = sender.selectedSegmentIndex == 0 ? .or : .and
    clearButton.isEnabled = true
  }
  
  @objc func didChangeSearchTypeSegmentControl(_ sender: UISegmentedControl) {
    searchParameter.searchType = sender.selectedSegmentIndex == 0 ? .exact : .contains
    clearButton.isEnabled = true
  }
  
  @objc func applyButtonClicked(_ sender: UIButton) {
    searchParameter.chosenFilterOptions = selectedFilterOptions
    applyButtonTapClosure?(searchParameter)
  }
  
  // MARK: - Custom Methods
  
  private func reloadCollectionView() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  
  private func configureClearButton() {
    clearButton.isEnabled = !selectedFilterOptions.isEmpty
  }
  
  private func setupSegmentControl() {
    let combineTypeIndex =  searchParameter.combineType == .or ? 0 : 1
    combineTypeSegmentControl.selectedSegmentIndex = combineTypeIndex
    
    let searchTypeIndex =  searchParameter.searchType == .exact ? 0 : 1
    searchTypeSegmentControl.selectedSegmentIndex = searchTypeIndex
  }
  
  private func clearSelectedFilterOptions() {
    selectedFilterOptions.removeAll()
    collectionView.reloadData()
  }
}
// MARK: - Collection Delegate

extension SearchParameterVC: UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return searchParameter.filterOptions.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SearchParameterCell.identifier, for: indexPath) as? SearchParameterCell else {
      return UICollectionViewCell()
    }
    let selectedValue = searchParameter.filterOptions[indexPath.row]
    let isSelected = selectedFilterOptions.contains(where: { $0.title == selectedValue.title })
    cell.configureView(using: selectedValue, isSelected: isSelected)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    let selectedValue = searchParameter.filterOptions[indexPath.row]
    if let filterOptionIndex = selectedFilterOptions.firstIndex(
      where: { $0.title == selectedValue.title }) {
      selectedFilterOptions.remove(at: filterOptionIndex)
    } else {
      selectedFilterOptions.append(selectedValue)
    }
    configureClearButton()
    reloadCollectionView()
  }
}

//
//  ViewController.swift
//  Searchify
//
//  Created by MAHESHWARAN on 21/05/23.
//

import UIKit

class ViewController: UIViewController {
  
  var viewModel = StudentListViewModel()
  
  // MARK: - Outlets
  
  lazy var tableView: UITableView = {
    $0.estimatedRowHeight = UITableView.automaticDimension
    $0.tableFooterView = UIView()
    $0.sectionHeaderTopPadding = 0.0
    return $0
  }(UITableView(frame: .zero, style: .grouped))
  
  lazy var addButton: UIBarButtonItem = {
    return UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain,
                           target: self, action: #selector(createNewStudent))
  }()
  
  // MARK: - Override Method
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureSearchBar()
  }
  
  // MARK: - View
  
  private func configureView() {
    self.view.backgroundColor = .systemBackground
    self.title = "Searchify"
    configureTableView()
    configureNavigationBarButton()
    configureSearchBar()
  }
  
  private func configureNavigationBarButton() {
    self.navigationItem.rightBarButtonItem = addButton
  }
  
  // MARK: - TableView
  
  private func configureTableView() {
    self.view.addSubview(tableView)
    tableView.backgroundColor = .systemBackground
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(StudentDetailCell.self, forCellReuseIdentifier: StudentDetailCell.reuseIdentifier)
    tableViewConstraint()
  }
  
  private func tableViewConstraint() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  // MARK: - SearchBar
  
  let searchController = UISearchController(searchResultsController: nil)
  
  var searchWorker: StudentSearchWorker?
  // Parameter Based Search
  var chosenParameter: SearchParameter?
  
  var canShowSearchParameters: Bool {
    guard let chosenParameter else { return false }
    return !chosenParameter.chosenFilterOptions.isEmpty
  }
  
  private func configureSearchBar() {
    self.navigationItem.searchController = searchController
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.extendedLayoutIncludesOpaqueBars = true
    searchController.searchBar.barTintColor = .white
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = "Search Student"
    searchController.searchBar.showsBookmarkButton = true
    searchController.searchBar.setImage(UIImage(systemName: "text.magnifyingglass"),
                              for: .bookmark, state: .normal)
    if #available(iOS 16.0, *) {
      navigationItem.preferredSearchBarPlacement = .stacked
    }
    searchController.searchBar.sizeToFit()
    setupSearchWorker()
  }
  
  private func setupSearchWorker() {
    let parameter = SearchParameter()
    parameter.filterOptions = ParameterFilterOption.searchFilterOptions
    let searchWorker = StudentSearchWorker(searchParameter: parameter) { [weak self] (_, predicate) in
      self?.viewModel.searchPredicate = predicate
      self?.viewModel.updateSearchResult {
        self?.tableView.reloadData()
      }
    }
    self.searchWorker = searchWorker
  }
  
  private func resetSearchBar() {
    searchController.searchBar.resignFirstResponder()
    searchController.searchBar.showsCancelButton = false
  }
  
  // MARK: - Custom Methods
  
  @objc private func createNewStudent(_ sender: UIBarButtonItem) {
    openStudentVC()
  }
  
  private func openStudentVC(_ student: Student? = nil) {
    resetSearchBar()
    let studentVC = CreateStudentVC()
    studentVC.selectedStudent = { [weak self] student in
      self?.storeNewStudent(student)
    }
    if let student {
      studentVC.updateUserDetail(updateStudent: student)
    }
    navigationController?.pushViewController(studentVC, animated: true)
  }
  
  private func storeNewStudent(_ student: LocalStudent) {
    viewModel.createNewStudent(student) {
      self.tableView.reloadData()
    }
  }
}

// MARK: - TableView DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.students?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailCell", for: indexPath) as? StudentDetailCell else {
      return UITableViewCell()
    }
    if let student = viewModel.students?[indexPath.row] {
      cell.configureView(forStudent: student)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    if let student = viewModel.students?[indexPath.row] {
      openStudentVC(student)
    }
  }
  
  func tableView(_ tableView: UITableView,
                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
      if let student = self.viewModel.students?[indexPath.row] {
        self.viewModel.deleteStudent(student) {
          self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
      }
      complete(true)
    }
    delete.image = UIImage(systemName: "trash")
    
    let deleteAction = UISwipeActionsConfiguration(actions: [delete])
    deleteAction.performsFirstActionWithFullSwipe = true
    return deleteAction
  }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate, UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }
    searchWorker?.searchForText(searchText)
  }
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    searchBar.showsCancelButton = true
    return true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchWorker?.searchForText()
  }
  
  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    openSearchParameterVC(searchBar)
  }
}

// MARK: - Custom Search Parameter Filter

extension ViewController {
  
  private func openSearchParameterVC(_ search: UISearchBar) {
    let vc = SearchParameterVC()
    if let chosenParameter {
      vc.searchParameter = chosenParameter
    } else {
      vc.searchParameter.filterOptions = ParameterFilterOption.searchFilterOptions
    }
    vc.applyButtonTapClosure = { [weak self] value in
      vc.dismiss(animated: true) {
        self?.chosenParameter = value
        self?.updateParameterSearchWorker()
      }
    }
    if let sheet = vc.sheetPresentationController {
      sheet.detents = [.large(), .medium()]
      sheet.prefersGrabberVisible = true
    }
    present(vc, animated: true)
  }
  
  private func updateParameterSearchWorker() {
    let searchWorker = searchWorker
    if let chosenParameter {
      searchWorker?.searchParameter = chosenParameter
    } else {
      /* After we reset the selected parameter, we need to pass the default
       search parameters to ParameterSearchWorker */
      let searchParameter = SearchParameter()
      searchParameter.filterOptions = ParameterFilterOption.searchFilterOptions
      searchWorker?.searchParameter = searchParameter
    }
    reloadTableViewHeader()
  }
  
  private func reloadTableViewHeader() {
    DispatchQueue.main.async {
      self.tableView.reloadSections([0], with: .none)
    }
  }
  
  // MARK: - TableView Section Delegate
  
  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    guard canShowSearchParameters,
          let selectedFilterOptions = chosenParameter?.chosenFilterOptions else { return nil }
    let searchFilterView = SearchParameterView()
    searchFilterView.container.backgroundColor = tableView.backgroundColor
    searchFilterView.searchFilterOptions = selectedFilterOptions
    searchFilterView.delegate = self
    tableView.sectionHeaderTopPadding = 0.0
    return searchFilterView
  }
  
  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    return canShowSearchParameters ? 50.0 : 0.0
  }
}

// MARK: - SearchParameterDelegate

extension ViewController: SearchParametersViewConfigurable {
  
  func clearSearchParam(_ searchParam: SearchFilterOption) {
    self.chosenParameter?.chosenFilterOptions.removeAll(where: {
      $0.title == searchParam.title
    })
    reloadTableViewHeader()
    updateParameterSearchWorker()
  }
  
  func resetSearchParametersView() {
    self.chosenParameter = nil
    updateParameterSearchWorker()
  }
}

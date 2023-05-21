//
//  ViewController.swift
//  Searchify
//
//  Created by MAHESHWARAN on 21/05/23.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: - Outlets
  
  lazy var tableView: UITableView = {
    $0.estimatedRowHeight = UITableView.automaticDimension
    $0.tableFooterView = UIView()
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
  
  // MARK: - View
  
  private func configureView() {
    self.view.backgroundColor = .systemBackground
    self.title = "Searchify"
    configureTableView()
    configureNavigationBarButton()
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
  
  // MARK: - Custom Methods
  
  @objc private func createNewStudent(_ sender: UIBarButtonItem) {
    
  }
}

// MARK: - TableView DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailCell", for: indexPath) as? StudentDetailCell else {
      return UITableViewCell()
    }
    cell.configureView(forStudent: Student.example)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
}

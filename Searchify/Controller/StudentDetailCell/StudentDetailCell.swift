//
//  StudentDetailCell.swift
//  Searchify
//
//  Created by MAHESHWARAN on 21/05/23.
//

import UIKit

struct Student {
  let name: String
  let courseName: String
  let department: String
  let startDate: String
  let endDate: String
  let isCompleted: Bool
  
  static let example = Student(name: "Maheshwaran",
                               courseName: "iOS Developement",
                               department: "Computer Science",
                               startDate: "01-03-2023",
                               endDate: "01-06-2023",
                               isCompleted: false)
}

class StudentDetailCell: UITableViewCell {
  
  static let reuseIdentifier = "StudentDetailCell"
  
  // MARK: - Override Methods
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .systemBackground
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configure View
  
  func configureView(forStudent student: Student) {
    self.textLabel?.text = student.name
    self.detailTextLabel?.text = student.isCompleted ? student.courseName : student.department
    self.detailTextLabel?.textColor = student.isCompleted ? .systemGreen : .gray
    self.accessoryType = student.isCompleted ? .checkmark : .none
  }
}

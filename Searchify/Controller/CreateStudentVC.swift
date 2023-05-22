//
//  CreateStudentVC.swift
//  Searchify
//
//  Created by MAHESHWARAN on 21/05/23.
//

import UIKit

class CreateStudentVC: UIViewController {
  
  var student: Student?
  
  // MARK: - Event Delegation
  
  var selectedStudent: ((LocalStudent) -> Void)?
  
  // MARK: - Outlets
  
  private var verticalStackView: UIStackView = {
    $0.spacing = 10
    $0.axis = .vertical
    return $0
  }(UIStackView())
  
  private let studentNameLabel: UILabel = {
    $0.text = "Student "
    $0.textColor = .secondaryLabel
    return $0
  }(UILabel())
  
  private let studentNameField: UITextField = {
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.returnKeyType = .continue
    $0.layer.cornerRadius = 8
    $0.layer.borderWidth = 0.5
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.placeholder = "Enter your Name"
    $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    $0.leftViewMode = .always
    $0.backgroundColor = .secondarySystemBackground
    return $0
  }(UITextField())
  
  private let courseNameLabel: UILabel = {
    $0.text = "Course "
    $0.textColor = .secondaryLabel
    return $0
  }(UILabel())
  
  private let courseNameField: UITextField = {
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.returnKeyType = .continue
    $0.layer.cornerRadius = 8
    $0.layer.borderWidth = 0.5
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.placeholder = "Enter your Course Name"
    $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    $0.leftViewMode = .always
    $0.backgroundColor = .secondarySystemBackground
    return $0
  }(UITextField())
  
  private let departmentNameLabel: UILabel = {
    $0.text = "Department "
    $0.textColor = .secondaryLabel
    return $0
  }(UILabel())
  
  private let departmentField: UITextField = {
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.returnKeyType = .continue
    $0.layer.cornerRadius = 8
    $0.layer.borderWidth = 0.5
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.placeholder = "Enter your Department"
    $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    $0.leftViewMode = .always
    $0.backgroundColor = .secondarySystemBackground
    return $0
  }(UITextField())
  
  private let completeLabel: UILabel = {
    $0.text = "Completed"
    $0.textColor = .secondaryLabel
    return $0
  }(UILabel())
  
  private let completeToggle: UISwitch = {
    $0.isOn = false
    $0.tag = 0
    return $0
  }(UISwitch())
  
  lazy private var savebutton: UIButton = {
    $0.setTitle("Save", for: .normal)
    $0.backgroundColor = .systemBlue
    $0.setTitleColor(.white, for: .normal)
    $0.layer.cornerRadius = 8
    $0.layer.masksToBounds = true
    $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    $0.addTarget(self, action: #selector(savebuttonTapped), for: .touchUpInside)
    return $0
  }(UIButton())
  
  
  // MARK: - Override Method
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  // MARK: - View
  
  private func configureView() {
    self.view.backgroundColor = .systemBackground
    self.title = student == nil ? "Create Student" : "Update Student Details"
    configureUserDetailView()
  }
  
  private func configureUserDetailView() {
    view.addSubview(verticalStackView)
    
    let studentHStack = UIStackView(arrangedSubviews: [studentNameLabel, studentNameField])
    studentHStack.axis = .horizontal
    studentHStack.distribution = .fill
    
    let courseHStack = UIStackView(arrangedSubviews: [courseNameLabel,courseNameField])
    courseHStack.distribution = .fill
    courseHStack.axis = .horizontal
    
    let departmentHStack = UIStackView(arrangedSubviews: [departmentNameLabel,departmentField])
    departmentHStack.axis = .horizontal
    
    let completeHStack = UIStackView(arrangedSubviews: [completeLabel,completeToggle])
    completeHStack.axis = .horizontal
    
    let container = UIStackView(arrangedSubviews: [studentHStack, courseHStack, departmentHStack,
                                                   completeHStack, savebutton])
    container.axis = .vertical
    container.spacing = 10
    container.distribution = .equalSpacing
    verticalStackView.addArrangedSubview(container)
    
    verticalStackView.isUserInteractionEnabled = true
    studentNameField.delegate = self
    departmentField.delegate = self
    courseNameField.delegate = self
    updateViewConstraint()
  }
  
  private func updateViewConstraint() {
    verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
    ])
    
    NSLayoutConstraint.activate([
      studentNameField.heightAnchor.constraint(equalToConstant: 44),
      courseNameField.heightAnchor.constraint(equalToConstant: 44),
      departmentField.heightAnchor.constraint(equalToConstant: 44),
      savebutton.heightAnchor.constraint(equalToConstant: 44),
      completeToggle.heightAnchor.constraint(equalToConstant: 44),
      studentNameLabel.heightAnchor.constraint(equalToConstant: 44),
      courseNameLabel.heightAnchor.constraint(equalToConstant: 44),
      departmentNameLabel.heightAnchor.constraint(equalToConstant: 44),
      completeLabel.heightAnchor.constraint(equalToConstant: 44)
    ])
  }
  
  func updateUserDetail(updateStudent: Student? = nil) {
    if let student = updateStudent {
      self.student = student
      studentNameField.text = student.name
      courseNameField.text = student.courseName
      departmentField.text = student.department
      completeToggle.isOn = student.isCompleted
      savebutton.setTitle("Update", for: .normal)
    }
  }
  
  // MARK: - Save Student
  
  @objc private func savebuttonTapped() {
    departmentField.resignFirstResponder()
    studentNameField.resignFirstResponder()
    courseNameField.resignFirstResponder()
    
    guard let name = studentNameField.text,
          let courseName = courseNameField.text,
          let department = departmentField.text,
          !name.isEmpty, !courseName.isEmpty, !department.isEmpty else{
      alertCreateUserError()
      return
    }
    let student = LocalStudent(privateID: student?.privateID ?? UUID().uuidString,
                               name: name, courseName: courseName,
                               department: department, isCompleted: completeToggle.isOn)
    self.selectedStudent?(student)
    self.navigationController?.popViewController(animated: true)
  }
  
  func alertCreateUserError(message: String = "Please Enter all information to Create Student") {
    let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    present(alert, animated: true)
  }
}

// MARK: - UITextFieldDelegate

extension CreateStudentVC: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == studentNameField {
      courseNameField.becomeFirstResponder()
    } else if textField == courseNameField {
      departmentField.becomeFirstResponder()
    } else {
      departmentField.resignFirstResponder()
    }
    return true
  }
}

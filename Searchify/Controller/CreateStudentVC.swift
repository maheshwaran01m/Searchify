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
  
  private let container: UIView = {
    $0.backgroundColor = .systemBackground
    $0.isUserInteractionEnabled = true
    $0.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
    return $0
  }(UIView())
  
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
    view.addSubview(container)
    
    studentNameField.delegate = self
    departmentField.delegate = self
    courseNameField.delegate = self
    updateViewConstraint()
  }
  
  private func updateViewConstraint() {
    updateLayoutConstraints(view: [studentNameLabel, studentNameField, courseNameLabel, courseNameField,
                                  departmentNameLabel, departmentField, completeLabel, completeToggle,
                                  savebutton])
    
    NSLayoutConstraint.activate([
      
      container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
      container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
      
      studentNameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
      studentNameLabel.leftAnchor.constraint(equalTo: container.leftAnchor),
      studentNameLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5),
      
      studentNameField.topAnchor.constraint(equalTo: studentNameLabel.bottomAnchor, constant: 3),
      studentNameField.centerXAnchor.constraint(equalTo: studentNameLabel.centerXAnchor),
      studentNameField.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5),
      
      courseNameLabel.topAnchor.constraint(equalTo: studentNameField.bottomAnchor, constant: 5),
      courseNameLabel.centerXAnchor.constraint(equalTo: studentNameLabel.centerXAnchor),
      courseNameLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5),
      
      
      courseNameField.topAnchor.constraint(equalTo: courseNameLabel.bottomAnchor, constant: 3),
      courseNameField.leftAnchor.constraint(equalTo: studentNameLabel.leftAnchor),
      courseNameField.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5),
      
      departmentNameLabel.topAnchor.constraint(equalTo: courseNameField.bottomAnchor, constant: 5),
      departmentNameLabel.centerXAnchor.constraint(equalTo: studentNameLabel.centerXAnchor),
      departmentNameLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5),
      
      departmentField.topAnchor.constraint(equalTo: departmentNameLabel.bottomAnchor, constant: 3),
      departmentField.centerXAnchor.constraint(equalTo: studentNameLabel.centerXAnchor),
      departmentField.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5),
      
      completeLabel.topAnchor.constraint(equalTo: departmentField.bottomAnchor, constant: 10),
      completeLabel.centerXAnchor.constraint(equalTo: studentNameLabel.centerXAnchor),
      completeLabel.leftAnchor.constraint(equalTo: container.leftAnchor),
      
      completeToggle.centerYAnchor.constraint(equalTo: completeLabel.centerYAnchor),
      completeToggle.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5),
      
      savebutton.topAnchor.constraint(equalTo: completeLabel.bottomAnchor, constant: 10),
      savebutton.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 5),
      savebutton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5),
      
      
      studentNameField.heightAnchor.constraint(equalToConstant: 34),
      courseNameField.heightAnchor.constraint(equalToConstant: 34),
      departmentField.heightAnchor.constraint(equalToConstant: 34),
      savebutton.heightAnchor.constraint(equalToConstant: 34),
      completeToggle.heightAnchor.constraint(equalToConstant: 34),
      studentNameLabel.heightAnchor.constraint(equalToConstant: 34),
      courseNameLabel.heightAnchor.constraint(equalToConstant: 34),
      departmentNameLabel.heightAnchor.constraint(equalToConstant: 34),
      completeLabel.heightAnchor.constraint(equalToConstant: 34)
    ])
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

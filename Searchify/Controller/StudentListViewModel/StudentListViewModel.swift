//
//  StudentListViewModel.swift
//  Searchify
//
//  Created by MAHESHWARAN on 21/05/23.
//

import Foundation
import CoreData

class StudentListViewModel: NSObject {
  
  var students: [Student]?
  
  var fetchResultsController: NSFetchedResultsController<Student>?
  var searchPredicate: NSPredicate?
  var sortDescriptors: [NSSortDescriptor]?
  
  var moc: NSManagedObjectContext { return .main }
  
  private var predicate: NSPredicate? {
    var fetchPredicates: [NSPredicate] = []
    fetchPredicates.append(NSPredicate(format: "privateID != nil"))
//    fetchPredicates.append(NSPredicate(format: "isCompleted==TRUE"))
    if let searchPredicate {
      fetchPredicates.append(searchPredicate)
    }
    return NSCompoundPredicate(andPredicateWithSubpredicates: fetchPredicates)
  }
  
  override init() {
    super.init()
    self.configureFRC()
  }
  
  func performFetch() {
    do {
      try fetchResultsController?.performFetch()
      fetchStudentsUsingFRC()
    } catch {
      print("Failed to Fetch students for Database")
    }
  }
  
  private func configureFRC() {
    let frc = makeFetchedResultsController(moc: moc)
    frc?.delegate = self
    self.fetchResultsController = frc as? NSFetchedResultsController<Student>
    performFetch()
  }
  
  // MARK: - Save New Student
  
  func createNewStudent(_ student: LocalStudent, onCompletion: (() -> Void)?) {
    let newStudent = fetchObject(privateID: student.privateID).first ?? Student(context: moc)
    newStudent.privateID = student.privateID
    newStudent.name = student.name
    newStudent.courseName = student.courseName
    newStudent.department = student.department
    newStudent.isCompleted = student.isCompleted
    moc.saveContext()
    onCompletion?()
  }
  
  func deleteStudent(_ student: Student, onCompletion: (() -> Void)?) {
    moc.perform {
      let fetchedStudent = self.moc.object(with: student.objectID)
      self.moc.delete(fetchedStudent)
      self.moc.saveContext()
      print("Deleted student: \(student.name ?? "")")
      onCompletion?()
    }
  }
  
  // MARK: - Private Functions
  
  private func fetchStudentsUsingFRC() {
    guard let fetchStudents = fetchResultsController?.fetchedObjects, !fetchStudents.isEmpty else {
      return
    }
    students = fetchStudents
  }
  
  // MARK: - Fetch Assets
  
  func makeFetchedResultsController(moc: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>? {
    let sortDescriptors = [NSSortDescriptor(key: "isCompleted", ascending: true),
                           NSSortDescriptor(key: "courseName", ascending: true)]
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.includesPendingChanges = false
    fetchRequest.fetchBatchSize = 20
    return NSFetchedResultsController(fetchRequest: fetchRequest,
                                      managedObjectContext: moc,
                                      sectionNameKeyPath: nil,
                                      cacheName: nil)
  }
}
// MARK: - FRC Delegate

extension StudentListViewModel: NSFetchedResultsControllerDelegate {
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    fetchStudentsUsingFRC()
  }
}

// MARK: - FetchObjects

extension StudentListViewModel {
  
  func fetchObject(
    privateID: String,
    moc: NSManagedObjectContext = .main) -> [Student] {
      
      let fetchRequest = NSFetchRequest<Student>()
      fetchRequest.includesPendingChanges = false
      fetchRequest.fetchBatchSize = 20
      let entityDescription = NSEntityDescription.entity(forEntityName: "Student", in: moc)
      
      // Configure Fetch Request
      fetchRequest.entity = entityDescription
      fetchRequest.predicate = NSPredicate(format: "privateID = %@", privateID)
      fetchRequest.sortDescriptors = sortDescriptors
      do {
        return try moc.fetch(fetchRequest)
      } catch {
        return []
      }
    }
}

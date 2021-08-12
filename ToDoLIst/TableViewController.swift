//
//  TableViewController.swift
//  ToDoLIst
//
//  Created by Alexander Airumyan on 11.08.2021.
//
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
	
	var tasks: [Task] = []
	
	@IBAction func saveTask(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "New Task", message: "Please add new task", preferredStyle: .alert)
		
		let saveAction = UIAlertAction(title: "Save", style: .default) { action in
			let tf = alertController.textFields?.first
			if let newTaskTitle = tf?.text{
				self.saveTask(WithTitle: newTaskTitle)
				self.tableView.reloadData()
			}
		}
		alertController.addTextField { _ in }
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
		
		alertController.addAction(saveAction)
		alertController.addAction(cancelAction)
		
		present(alertController, animated: true, completion: nil)
	}
	
	private func saveTask(WithTitle title: String) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
		
		let taskObject = Task(entity: entity, insertInto: context)
		taskObject.title = title
		
		do {
			try context.save()
			tasks.append(taskObject)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	private func getContext() -> NSManagedObjectContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let context = getContext()
		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		do {
			tasks = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		let context = getContext()
//		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//		if let objects = try? context.fetch(fetchRequest){
//			for object in objects {
//				context.delete(object)
//			}
//		}
//
//		do {
//			try context.save()
//		} catch let error as NSError {
//			print(error.localizedDescription)
//		}
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		let task = tasks[indexPath.row]
		cell.textLabel?.text = task.title
		
		return cell
	}
}

//
//  CategoryTableViewController.swift
//  iOCNotes
//
//  Created by Peter Hedlund on 8/1/19.
//  Copyright © 2019 Peter Hedlund. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    let reuseIdentifier = "CategoryCell"
    static let noCategoryName = NSLocalizedString("No Category", comment: "Text displayed for notes not assigned to a category")

    var categories = [String]()
    var currentCategory = noCategoryName
    var note: CDNote? {
        didSet {
            currentCategory = note?.category ?? CategoryTableViewController.noCategoryName
            if currentCategory.isEmpty {
                currentCategory = CategoryTableViewController.noCategoryName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = cancelBarButton
        categories.insert(CategoryTableViewController.noCategoryName, at: 0)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        cell.accessoryType = .none
        let index = categories.index(of: currentCategory)
        if indexPath.row == index {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCategory = categories[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if let note = self.note {
            if currentCategory == CategoryTableViewController.noCategoryName {
                self.note?.category = nil
                note.category = nil
            } else {
                self.note?.category = currentCategory
                note.category = currentCategory
            }
            tableView.reloadData()
            navigationItem.leftBarButtonItem = doneBarButton
            NotesManager.shared.update(note: note)
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Add Category", message: "Enter a name for the new catefgory", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] (_) in
            if let textField = alert?.textFields?[0],
                let text = textField.text,
                !text.isEmpty {
                if let note = self?.note {
                    self?.categories.append(text)
                    self?.currentCategory = text
                    self?.note?.category = text
                    self?.tableView.reloadData()
                    self?.navigationItem.leftBarButtonItem = self?.doneBarButton
                    note.category = text
                    NotesManager.shared.update(note: note)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
//
//  ViewController.swift
//  Dictionary
//
//  Created by matteo ugolini on 2020-09-16.
//  Copyright © 2020 EnovLab Inc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

class ViewController: UITableViewController, UISearchResultsUpdating {

    lazy var resultSearchController = buildSearchController()

    var words: [Word] = [] {
        didSet { tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = resultSearchController.searchBar
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: reuseIdentifier)

        title = "Dictionary"
        words = DictionaryManager.shared.getAllOrdered()
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let prefix = searchController.searchBar.text, !prefix.isEmpty {
            words = DictionaryManager.shared.findWords(with: prefix)
        } else {
            words = DictionaryManager.shared.getAllOrdered()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = words[indexPath.row].word
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let definitionViewController = DefinitionViewController()
        definitionViewController.word = words[indexPath.row]
        resultSearchController.isActive = false
        navigationController?.pushViewController(definitionViewController, animated: true)
    }

    private func buildSearchController() -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        return controller
    }
}


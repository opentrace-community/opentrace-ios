//
//  HelpViewController.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit
import SafariServices

final class HelpViewController: UIViewController {

	private typealias Copy = DisplayStrings.Help

	private let dataSource: [Section] = [.init(title: "About the app", rows: [.init(title: "How do I use this?",
																			subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed",
																			urlString: "https://www.google.com/"),
																	  .init(title: "Does this steal my data?",
																			subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et",
																			urlString: "https://www.google.com/")]),
								 .init(title: "About the virus", rows: [.init(title: "What is a virus?",
																			  subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ",
																			  urlString: "https://www.google.com/"),
																		.init(title: "How you can protect yourself",
																			  subTitle: "Lorem ipsum dolor sit amet, consectetur",
																			  urlString: nil)])]

	@IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = Copy.View.title
		tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell().identifier)
		tableView.delegate = self
		tableView.dataSource = self
    }
}

extension HelpViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return dataSource[section].title
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return dataSource.count
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource[section].rows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell().identifier, for: indexPath) as? DetailCell else { return UITableViewCell() }
		let model = dataSource[indexPath.section].rows[indexPath.row]
		cell.model = model
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let url = dataSource[indexPath.section].rows[indexPath.row].url {
			let safariViewController = SFSafariViewController(url: url)
			present(safariViewController, animated: true)
		}
		tableView.cellForRow(at: indexPath)?.isSelected = false
	}

}

extension HelpViewController {

	struct Section {
		let title: String
		let rows: [CellModel]
	}

	struct CellModel {
		let title: String
		let subTitle: String
		let urlString: String?

		var url: URL? {
			guard let urlString = urlString else { return nil }
			return URL(string: urlString)
		}
	}
}

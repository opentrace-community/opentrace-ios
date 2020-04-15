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

	@IBOutlet private var tableView: UITableView!

	private var dataSource: [Section] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		fetchTableData()
		navigationItem.title = Copy.View.title
		tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell().identifier)
		tableView.delegate = self
		tableView.dataSource = self
    }

	private func fetchTableData() {
		guard let helpContentPath = Bundle.main.url(forResource: "HelpContent", withExtension: "json") else { return }
		do {
			let jsonData = try Data(contentsOf: helpContentPath, options: .mappedIfSafe)
			let helpData = try JSONDecoder().decode([Section].self, from: jsonData)
			dataSource = helpData
		}
		catch {
			let alert = UIAlertController(title: Copy.Error.title, message: error.localizedDescription, preferredStyle: .alert)
			alert.addAction(.init(title: Copy.Error.dismiss, style: .cancel))
			present(alert, animated: true)
		}
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

	struct Section: Codable {
		let title: String
		let rows: [CellModel]
	}

	struct CellModel: Codable {
		let title: String
		let subTitle: String
		let urlString: String?

		var url: URL? {
			guard let urlString = urlString else { return nil }
			return URL(string: urlString)
		}
	}
}

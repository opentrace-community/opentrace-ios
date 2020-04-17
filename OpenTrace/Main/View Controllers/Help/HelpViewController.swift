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
		tableView.sectionHeaderHeight = UITableView.automaticDimension
		tableView.estimatedSectionHeaderHeight = 35
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

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let showShadow = scrollView.contentOffset.y > 0
		setNavbarToBackgroundColour(withShadow: showShadow)
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 {  return TableHeaderView() }
		let view = SectionHeaderView()
		view.title = dataSource[section - 1].title
		return view
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return dataSource.count + 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 0 : dataSource[section - 1].rows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell().identifier, for: indexPath) as? DetailCell else { return UITableViewCell() }
		let model = dataSource[indexPath.section - 1].rows[indexPath.row]
		cell.model = model
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let url = dataSource[indexPath.section - 1].rows[indexPath.row].url {
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

//
//  SettingsViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import UIKit

final class SettingsViewController: UITableViewController {
    
    var fields: [CommonField] = [] {
        didSet {
            fields.forEach { field in
                field.register(for: self.tableView)
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        
        fields = [
            ToggleField(viewModel: .init(title: "둘러보기 허용", imageName: "person.crop.circle.badge.checkmark")),
            PlainField(viewModel: .init(title: "some", info: "some...?", imageName: "pencil")),
            NavigateField(viewModel: .init(title: "로그인", imageName: "person.circle.fill")),
            PlainField(viewModel: .init(title: "앱 버전", info: "0.0.1", imageName: "exclamationmark.transmission"))
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[indexPath.row]
        return field.dequeue(for: tableView, at: indexPath)
    }
}

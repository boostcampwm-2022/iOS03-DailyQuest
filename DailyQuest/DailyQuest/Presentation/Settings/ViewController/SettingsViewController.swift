//
//  SettingsViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import UIKit

import RxSwift
import RxCocoa

final class SettingsViewController: UITableViewController {
    enum Event {
        case showLoginFlow
    }
    
    var itemDidClick = PublishSubject<Event>()
    
    private let fields: [CommonField]  = [
        ToggleField(viewModel: .init(title: "둘러보기 허용", imageName: "person.crop.circle.badge.checkmark")),
        PlainField(viewModel: .init(title: "some", info: "some...?", imageName: "pencil")),
        NavigateField(viewModel: .init(title: "로그인", imageName: "person.circle.fill", viewType: .login)),
        PlainField(viewModel: .init(title: "앱 버전", info: "0.0.1", imageName: "exclamationmark.transmission"))
    ]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        
        register()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[indexPath.row]
        return field.dequeue(for: tableView, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let field = fields[indexPath.row]
        guard let type = field.didSelect() else { return }
        
        switch type {
            case .login:
                itemDidClick.onNext(.showLoginFlow)
        }
    }
    
    private func register() {
        fields.forEach { field in
            field.register(for: self.tableView)
        }
    }
}

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
    private var viewModel: SettingsViewModel!
    private var disposableBag = DisposeBag()
    
    var itemDidClick = PublishSubject<Event>()
    
    // MARK: - Life Cycle
    static func create(with viewModel: SettingsViewModel) -> SettingsViewController {
        let vc = SettingsViewController()
        vc.viewModel = viewModel
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        
        register()
        
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform()
        
        output
            .loginStatusDidChange
            .subscribe(onNext: { [weak self] in self?.reloadData() })
            .disposed(by: disposableBag)
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
    
    private func register() {
        viewModel.fields.forEach { field in
            field.register(for: self.tableView)
        }
    }
}

extension SettingsViewController {
    enum Event {
        case showLoginFlow
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = viewModel.fields[indexPath.row]
        return field.dequeue(for: tableView, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let field = viewModel.fields[indexPath.row]
        guard let type = field.didSelect() else { return }
        
        switch type {
            case .login:
                itemDidClick.onNext(.showLoginFlow)
            case .logout:
                viewModel
                    .signOut()
                    .subscribe()
                    .disposed(by: disposableBag)
        }
    }
}

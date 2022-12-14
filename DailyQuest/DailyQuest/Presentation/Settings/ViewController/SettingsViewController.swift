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
    var toggleButtonDidClick = PublishSubject<Event>()
    var deleteUserDidClicked = PublishSubject<Event>()
    // MARK: - Life Cycle
    static func create(with viewModel: SettingsViewModel) -> SettingsViewController {
        let vc = SettingsViewController()
        vc.viewModel = viewModel
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
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
    func showSignOutAlert(preferredStyle: UIAlertController.Style = .alert,
                          completion: (() -> Void)? = nil)
    {
        let title = "로그아웃"
        let message = "로그아웃 하시겠습니까?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.signOut()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: completion)
    }
    
    func showDeleteAlert(preferredStyle: UIAlertController.Style = .alert,
                         completion: (() -> Void)? = nil)
    
    {
        let title = "탈퇴하기"
        let message = "정말 탈퇴 하시겠습니까?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.deleteUser()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: completion)
    }
    
    private func signOut() {
        viewModel
            .signOut()
            .subscribe()
            .disposed(by: disposableBag)
    }
    
    private func deleteUser() {
        viewModel
            .deleteUser()
            .subscribe(onSuccess: { result in
                if result {
                    let message = "탈퇴가 완료되었습니다."
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let message = "오류가 발생했습니다. \n 잠시 후 다시 시도해주세요."
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposableBag)
    }
}

extension SettingsViewController {
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
            showSignOutAlert()
        case .delete:
            showDeleteAlert()
        case .version:
            break
        }
    }
}

extension SettingsViewController {
    enum Event {
        case showLoginFlow
    }
}

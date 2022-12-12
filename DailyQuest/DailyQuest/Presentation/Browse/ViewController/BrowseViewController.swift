//
//  BrowseViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import UIKit

import RxSwift
import RxCocoa

final class BrowseViewController: UITableViewController {
    
    var coordinatorPublisher = PublishSubject<User>()
    
    private var viewModel: BrowseViewModel!
    private var disposableBag = DisposeBag()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .maxDarkYellow
        
        let transfrom = CGAffineTransform.init(scaleX: 2, y: 2)
        activityIndicator.transform = transfrom
        
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    // MARK: - Life Cycle
    static func create(with viewModel: BrowseViewModel) -> BrowseViewController {
        let view = BrowseViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureIndicatorBar()
        bind()
    }
    
    private func configureIndicatorBar() {
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    /**
     table view의 기본 정보를 설정합니다.
     */
    private func configure() {
        // 델리게이트와 데이터소스를 rx로 재설정합니다.
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self).disposed(by: disposableBag)
        
        // BrowseCell을 등록합니다.
        tableView.register(BrowseCell.self, forCellReuseIdentifier: BrowseCell.reuseIdentifier)
    }
    
    private func bind() {
        let output = viewModel.transform(input: BrowseViewModel.Input(viewDidLoad: .just(()).asObservable()))
        
        output
            .data
            .do{ [weak self] _ in
                self?.activityIndicator.stopAnimating()
            }
            .drive(tableView.rx.items(cellIdentifier: BrowseCell.reuseIdentifier, cellType: BrowseCell.self)) { row, item, cell in
                cell.setup(with: item)
            }
            .disposed(by: disposableBag)
        
        tableView
            .rx
            .modelSelected(BrowseItemViewModel.self)
            .map { $0.user }
            .bind(to: coordinatorPublisher)
            .disposed(by: disposableBag)
    }
}

extension BrowseViewController {
    /**
     하나의 BrowseCell의 크기를 결정합니다. BrowseCell내의 QuestCell의 개수만큼 크기가 늘어납니다.
     +20은 margins으로 인해 추가된 값입니다.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (75.0 * CGFloat(viewModel.cellCount[indexPath.row])) + 20 + 75
    }
}

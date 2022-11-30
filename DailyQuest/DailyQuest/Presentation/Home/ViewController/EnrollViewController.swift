//
//  EnrollViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import RxSwift
import SnapKit

final class EnrollViewController: UIViewController {
    private var disposableBag = DisposeBag()
    
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10
        
        return container
    }()
    
    private lazy var titleField: TextFieldForm = {
        let titleField = TextFieldForm()
        titleField.placeholder = "description"
        titleField.backgroundColor = .maxYellow
        titleField.layer.cornerRadius = 15
        
        return titleField
    }()
    
    private lazy var startDate: PlanDatePickerView = {
        let startDate = PlanDatePickerView()
        
        return startDate
    }()
    
    private lazy var endDate: PlanDatePickerView = {
        let endDate = PlanDatePickerView()
        
        return endDate
    }()
    
    private lazy var daysPicker: DayNamePickerView = {
        return DayNamePickerView()
    }()
    
    private lazy var quantityView: QuantityView = {
        return QuantityView()
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        daysPicker
            .selectedDayObservable
            .map { dictionary in
                dictionary.filter { key, value in
                    value
                }
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposableBag)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        container.addArrangedSubview(titleField)
        container.addArrangedSubview(startDate)
        container.addArrangedSubview(endDate)
        container.addArrangedSubview(daysPicker)
        container.addArrangedSubview(quantityView)
        
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(30)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
}

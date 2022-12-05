//
//  EnrollViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class EnrollViewController: UIViewController {
    private var disposableBag = DisposeBag()
    private let viewModel = EnrollViewModel(dayNamePickerViewModel: DayNamePickerViewModel())
    
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
    
    private lazy var submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "등록하기"
        config.baseBackgroundColor = .maxYellow
        config.baseForegroundColor = .maxViolet
        
        return UIButton(configuration: config)
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quantityView.quantityField.delegate = self
        
        configureUI()
        
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        container.addArrangedSubview(titleField)
        container.addArrangedSubview(startDate)
        container.addArrangedSubview(endDate)
        container.addArrangedSubview(daysPicker)
        container.addArrangedSubview(quantityView)
        container.addArrangedSubview(submitButton)
        
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(30)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    func bind() {
        daysPicker.bind(with: viewModel.dayNamePickerViewModel, disposeBag: disposableBag)
        
        let startDateDidSet = startDate.datePicker.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(startDate.datePicker.rx.date)
        
        let endDateDidSet = endDate.datePicker.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(endDate.datePicker.rx.date)
        
        let output = viewModel.transform(
            input: EnrollViewModel.Input(
                titleDidChanged: titleField.rx.text.orEmpty.asObservable(),
                startDateDidSet: startDateDidSet,
                endDateDidSet: endDateDidSet,
                quantityDidSet: quantityView.quantityField.rx.text.orEmpty
                    .asObservable(),
                submitButtonDidClicked: submitButton.rx.tap.asObservable()
            )
        )
        
        bindSubmitButton(output: output)
    }
    
    private func bindSubmitButton(output: EnrollViewModel.Output) {
        output
            .buttonEnabled
            .drive(submitButton.rx.isEnabled)
            .disposed(by: disposableBag)
    }
}

extension EnrollViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        guard let oldText = textField.text else { return true }
        let text = (oldText as NSString).replacingCharacters(in: range, with: string)
        
        return text.count < 4
    }
}

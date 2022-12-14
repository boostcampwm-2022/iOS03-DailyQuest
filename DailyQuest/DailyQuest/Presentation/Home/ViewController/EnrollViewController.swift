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
    private var viewModel: EnrollViewModel!
    private var disposableBag = DisposeBag()
    
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10
        
        return container
    }()
    
    private lazy var titleField: TextFieldForm = {
        let titleField = TextFieldForm()
        titleField.placeholder = "퀘스트"
        titleField.backgroundColor = .maxYellow
        titleField.layer.cornerRadius = 15
        
        return titleField
    }()
    
    private lazy var startDate: PlanDatePickerView = {
        let startDate = PlanDatePickerView()
        startDate.title("시작 날짜")
        
        return startDate
    }()
    
    private lazy var endDate: PlanDatePickerView = {
        let endDate = PlanDatePickerView()
        endDate.title("종료 날짜")
        
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
    static func create(with viewModel: EnrollViewModel) -> EnrollViewController {
        let vc = EnrollViewController()
        vc.viewModel = viewModel
        
        return vc
    }
    
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
        let titleDidChanged = titleField.rx.text.orEmpty.asObservable()
        let startDateDidSet = startDate.datePicker.rx.date.asObservable()
        let endDateDidSet = endDate.datePicker.rx.date.asObservable()
        let quantityDidSet = quantityView.quantityField.rx.text.orEmpty.asObservable()
        let submitButtonDidClicked = submitButton.rx.tap.asObservable()
        
        let taps = daysPicker
            .buttons
            .enumerated()
            .map { index, button in
                button.rx.tap.map { _ in index + 1 }
            }
        
        let dayButtonDidClicked = Observable.from(taps).merge()
        
        let output = viewModel.transform(
            input: EnrollViewModel.Input(
                titleDidChanged: titleDidChanged,
                startDateDidSet: startDateDidSet,
                endDateDidSet: endDateDidSet,
                quantityDidSet: quantityDidSet,
                submitButtonDidClicked: submitButtonDidClicked,
                dayButtonDidClicked: dayButtonDidClicked
            )
        )
        
        bindToSubmitButton(output: output)
        bindToDayNamePickerView(output: output)
        bindToDismiss(output: output)
    }
    
    private func bindToSubmitButton(output: EnrollViewModel.Output) {
        output
            .buttonEnabled
            .drive(submitButton.rx.isEnabled)
            .disposed(by: disposableBag)
    }
    
    private func bindToDayNamePickerView(output: EnrollViewModel.Output) {
        output
            .dayButtonStatus
            .bind(onNext: { [weak self] index, isSelected in
                guard let isSelected = isSelected else { return }
                if isSelected {
                    self?.daysPicker.buttons[index-1].configuration?.baseBackgroundColor = .maxYellow
                } else {
                    self?.daysPicker.buttons[index-1].configuration?.baseBackgroundColor = .maxLightYellow
                }
            })
            .disposed(by: disposableBag)
    }
    
    private func bindToDismiss(output: EnrollViewModel.Output) {
        output
            .enrollResult
            .filter({ $0 })
            .bind(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposableBag)
    }
}

extension EnrollViewController {
    enum Event {
        case success
        case fail
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

//
//  QuestViewModelTests.swift
//  DailyQuestTests
//
//  Created by jinwoong Kim on 2022/11/21.
//

import XCTest

import RxSwift

final class QuestViewModelTests: XCTestCase {
    private var questViewModel: QuestViewModel!
    private var questUseCase: QuestUseCase!
    private var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        questViewModel = nil
        questUseCase = nil
        disposeBag = .init()
    }

    func testQuestViewModel_WhenUseCaseSendCorrectQuests_ThenExpectationWillBeFulfilledWithSuccess() {
        // given
        questUseCase = QuestUseCaseMock()
        
        questViewModel = QuestViewModel(questUseCase: questUseCase)
        
        let expectation = XCTestExpectation(description: "test success")
        
        // // when
        // let output = questViewModel.transform(input: QuestViewModel.Input(viewDidLoad: .just(Date()).asObservable(), itemDidClicked: .just(<#T##element: Quest##Quest#>)), disposeBag: disposeBag)
        // 
        // // then
        // output
        //     .data
        //     .drive(onNext: { quests in
        //         print(quests)
        //         expectation.fulfill()
        //     })
        //     .disposed(by: disposeBag)
        //
        // wait(for: [expectation], timeout: 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

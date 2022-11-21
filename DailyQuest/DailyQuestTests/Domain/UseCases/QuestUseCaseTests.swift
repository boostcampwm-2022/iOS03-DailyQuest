//
//  QuestUseCaseTests.swift
//  DailyQuestTests
//
//  Created by jinwoong Kim on 2022/11/21.
//

import XCTest

import RxSwift

final class QuestUseCaseTests: XCTestCase {
    private var questUseCase: QuestUseCase!
    private var questRepo: QuestsRepository!
    private var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        questRepo = nil
        questUseCase = nil
        disposeBag = .init()
    }

    func testQuestUseCase_WhenRepoSendCorrectQuests_ThenExpectationWillBeFulfilledWithSuccess() {
        // given
        questRepo = QuestRepositoryMock()
        
        questUseCase = DefaultQuestUseCase(questsRepository: questRepo)
        
        let expectation = XCTestExpectation(description: "test success")
        
        // when
        questUseCase
            .fetch(by: Date())
        // then
            .subscribe(onNext: { data in
                expectation.fulfill()
            }, onError: { _ in
                XCTFail("test failed")
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//
//  BrowseUseCaseTests.swift
//  DailyQuestTests
//
//  Created by jinwoong Kim on 2022/11/29.
//

import XCTest

import RxSwift

final class BrowseUseCaseTests: XCTestCase {
    private var browseUseCase: BrowseUseCase!
    private var browseRepo: BrowseRepository!
    private var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        browseRepo = nil
        browseUseCase = nil
        disposeBag = .init()
    }

    func testBrowseUseCase_WhenRepoSendCorrectQuests_ThenExpectationWillFulfillWithSuccess() {
        // given
        browseRepo = BrowseRepositoryMock()
        
        browseUseCase = DefaultBrowseUseCase(browseRepository: browseRepo)
        
        let expectation = XCTestExpectation(description: "test success")
        
        // when
        browseUseCase
            .excute()
        // then
            .subscribe(onNext: { browseQuests in
                print(browseQuests)
                expectation.fulfill()
            }, onError: { error in
                print(error)
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

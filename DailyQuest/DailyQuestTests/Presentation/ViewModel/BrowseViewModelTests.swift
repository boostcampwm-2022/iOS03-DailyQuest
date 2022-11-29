//
//  BrowseViewModelTests.swift
//  DailyQuestTests
//
//  Created by jinwoong Kim on 2022/11/29.
//

import XCTest

import RxSwift

final class BrowseViewModelTests: XCTestCase {
    private var browseViewModel: BrowseViewModel!
    private var browseUseCase: BrowseUseCase!
    private var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        browseViewModel = nil
        browseUseCase = nil
        disposeBag = .init()
    }

    func testBrowseViewModel_WhenUseCaseSendTwoUsersQuests_ThenViewModelWillGenerateTwoBrowseItemViewModel() {
        // given
        browseUseCase = BrowseUseCaseMock()
        
        browseViewModel = BrowseViewModel(browseUseCase: browseUseCase)
        
        // when
        let output = browseViewModel
            .transform(
                input: BrowseViewModel
                    .Input(viewDidLoad: .just(()).asObservable())
            )
        
        // then
        output
            .data
            .drive(onNext: { items in
                XCTAssertEqual(2, items.count)
            })
            .disposed(by: disposeBag)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

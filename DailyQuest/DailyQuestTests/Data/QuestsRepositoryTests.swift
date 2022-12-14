//
//  QuestsRepositoryTests.swift
//  DailyQuestTests
//
//  Created by 이전희 on 2022/12/05.
//

import XCTest
import RxSwift

final class QuestsRepositoryTests: XCTestCase {
    private var questsStorage: QuestsStorage!
    private var questsRepository: QuestsRepository!
    private var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_noAuthAndSave() throws {
        let dummyDate = ["2022-12-05".toDate()!,
                         "2022-12-05".toDate()!,
                         "2022-12-05".toDate()!,
                         "2022-12-05".toDate()!,
                         "2022-12-06".toDate()!,
                         "2022-12-06".toDate()!,
                         "2022-12-06".toDate()!,
                         "2022-12-07".toDate()!,
                         "2022-12-07".toDate()!,
                         "2022-12-07".toDate()!]
        let groupId = UUID()
        let dummyData = (0..<10).map { i in
            Quest(groupId: groupId, uuid: UUID(), date: dummyDate[i % dummyDate.count], title: "title \(i)", currentCount: (0...((i % 10) + 1)).randomElement()!, totalCount: (i % 10) + 1)
        }

        questsStorage = RealmQuestsStorage()
        questsRepository = DefaultQuestsRepository(persistentStorage: questsStorage)
        questsRepository.save(with: dummyData)
            .subscribe { quests in
            // XCTAssertEqual(dummyData, quests)
        } onFailure: { error in
            XCTFail(error.localizedDescription)
        } onDisposed: {
            print("❎ Disposed")
            XCTSkip()
        }.disposed(by: disposeBag)
    }
    
    func test_noAuthAnd() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

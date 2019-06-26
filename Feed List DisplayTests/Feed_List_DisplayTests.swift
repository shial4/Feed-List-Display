//
//  Feed_List_DisplayTests.swift
//  Feed List DisplayTests
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import XCTest
@testable import Feed_List_Display

class Feed_List_DisplayTests: XCTestCase {
    let window = UIWindow(frame: .zero)
    lazy var coordinator = ApplicationCoordinator(window: window)

    func testGetDisplayListViewController() {
        do {
            let _: DisplayListViewController = try coordinator.viewController([])
            XCTAssert(true)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
}

//
//  ApplicationTests.swift
//  Feed List DisplayTests
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import XCTest
@testable import Feed_List_Display

class ApplicationTests: XCTestCase {
    func testPost() {
        let json = """
[
   {
      "userId":1,
      "id":1,
      "title":"a",
      "body":"v",
      "imageUrl":"https://via.placeholder.com/600/771796",
      "thumbnailUrl":"https://via.placeholder.com/150/771796"
   },
   {
      "userId":1,
      "id":2,
      "title":"qui est esse",
      "body":"v",
      "imageUrl":"https://via.placeholder.com/600/771796",
      "thumbnailUrl":"https://via.placeholder.com/150/771796"
   },
   {
      "userId":1,
      "id":3,
      "title":"d",
      "body":"d",
      "imageUrl":"https://via.placeholder.com/600/771796",
      "thumbnailUrl":"https://via.placeholder.com/150/771796"
   }
]
"""
        let posts = try! JSONDecoder().decode([Post].self, from: json.data(using: .utf8)!)
        XCTAssert(posts.count == 3)
        XCTAssert(posts.first?.id == 1)
        XCTAssert(posts.last?.id == 3)
    }
    
    func testEndpoints() {
        
    }
}

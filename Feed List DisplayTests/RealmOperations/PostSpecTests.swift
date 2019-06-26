//
//  PostSpecTests.swift
//  Feed List DisplayTests
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Feed_List_Display

class PostSpecTests: XCTestCase {
    var realm: Realm!
    
    override func setUp() {
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "PostSpecTestsRealm"))
    }

    override func tearDown() {
        try! realm.write {
            realm.deleteAll()
        }
    }

    func testUpdate() {
        XCTAssert(realm.objects(Post.self).count == 0)
        let post = Post()
        do {
            try post.update(realm)
        } catch let catchError {
            XCTFail(catchError.localizedDescription)
        }
        XCTAssert(realm.objects(Post.self).count == 1)
        let postUpdate = Post()
        postUpdate.body = "my body"
        do {
            try postUpdate.update(realm)
        } catch let catchError {
            XCTFail(catchError.localizedDescription)
        }
        XCTAssert(realm.objects(Post.self).filter("body == %@", "my body").first?.id == 0)
    }
    
    func testSequanceUpdate() {
        XCTAssert(realm.objects(Post.self).count == 0)
        do {
            try Post.update(realm, sequance: [Post(userId: 0, id: 0, title: "", body: "", image: "", thumbnail: ""),
                                              Post(userId: 0, id: 1, title: "", body: "", image: "", thumbnail: ""),
                                              Post(userId: 0, id: 2, title: "", body: "", image: "", thumbnail: ""),
                                              Post(userId: 0, id: 3, title: "", body: "", image: "", thumbnail: "")
                ])
        } catch let catchError {
            XCTFail(catchError.localizedDescription)
        }
        XCTAssert(realm.objects(Post.self).count == 4)
        
        let query = Post.getAll(realm)
        XCTAssert(realm.objects(Post.self).count == query.count)
    }
}

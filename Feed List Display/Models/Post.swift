//
//  Post.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Post: Object, Decodable {
    @objc dynamic var userId: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var thumbnailUrl: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum PostCodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
        case imageUrl
        case thumbnailUrl
    }
    
    convenience init(userId: Int, id: Int, title: String, body: String, image: String, thumbnail: String) {
        self.init()
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
        self.imageUrl = image
        self.thumbnailUrl = thumbnail
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PostCodingKeys.self)
        self.init(userId: try container.decode(Int.self, forKey: .userId),
                  id: try container.decode(Int.self, forKey: .id),
                  title: try container.decode(String.self, forKey: .title),
                  body: try container.decode(String.self, forKey: .body),
                  image: try container.decode(String.self, forKey: .imageUrl),
                  thumbnail: try container.decode(String.self, forKey: .thumbnailUrl))
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
/**
 Helper methods for eas of work with realm.
 */
extension Post {
    //Update self
    func update() throws {
        let realm = try Realm()
        try realm.write {
            realm.add(self)
        }
    }
    //Update sequance
    static func update(sequance: [Post]) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(sequance)
        }
    }
    //Get all elements from realm
    static func getAll() throws -> Results<Post> {
        let realm = try Realm()
        let categories: Results<Post> = { realm.objects(Post.self) }()
        return categories
    }
}

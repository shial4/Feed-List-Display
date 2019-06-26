//
//  AppDelegate.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import Foundation
import MapKit
/**
 Result enum providing data about success or failure from the request.
 */
enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
    
    init(value: Value) {
        self = .success(value)
    }
    
    init(error: Error) {
        self = .failure(error)
    }
}

class Application {
    private static let apiUrlString = "https://ios-code-challenge.mockservice.io/"
    
    private class func featchPosts(_ handler: @escaping (_ response: [Post]?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let url = urlComponents(for: "posts", queryItems: nil)?.url else {
            handler(nil, NSError(domain: "Can not construct url", code: NSURLErrorBadURL))
            return nil
        }
        return networkTask(request: urlRequest(url, method: "GET"), handler: handler)
    }
    
    private class func urlRequest(_ url: URL, method: String?) -> URLRequest {
        var request = URLRequest(url: url)
        if let httpMethod = method {
            request.httpMethod = httpMethod
        }
        return request
    }
    
    private class func urlComponents(for path: String, queryItems: [URLQueryItem]?) -> URLComponents? {
        var urlComponents = URLComponents(string: apiUrlString + path)
        urlComponents?.queryItems = queryItems
        return urlComponents
    }
    
    private class func networkTask<T: Decodable>(request: URLRequest, handler: @escaping (_ response: T?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    handler(object, error)
                } catch let throwError {
                    handler(nil, throwError)
                }
            } else {
                handler(nil, error)
            }
        }
        task.resume()
        return task
    }
}

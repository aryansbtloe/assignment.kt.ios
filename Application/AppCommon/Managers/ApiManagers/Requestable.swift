//
//  Requestable.swift
//  aryansbtloe
//
//  Created by Alok on 08/04/2020.
//  Copyright (c) 2020 Aryansbtloe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

enum Failure: Error {
    case apiFailure
    case decodeFailure
    case dataAlreadyExists
    
    var message: String {
        switch self {
        case .apiFailure:
            return "Failed"
        case .decodeFailure:
            return "Something went wrong"
        case .dataAlreadyExists:
            return "Data already exists"
        }
    }
}

enum VideoResult<Value: Decodable> {
    case success(Value)
    case failure(Failure)
}

enum Result<Value: Decodable> {
    case success(Value)
    case failure(Int)
}

enum DefaultResult<Value: Decodable> {
    case success(Value)
    case failure(Failure)
}

typealias Handler = (Result<Data>) -> Void
typealias DefaultCallBack = (DefaultResult<Data>) -> Void
typealias CompletionHandler = (VideoResult<[Video]>) -> Void

enum Method {
    case get
    case put
    case post
    case delete
}

enum NetworkingError: String, LocalizedError {
    case jsonError = "JSON error"
    case other
    var localizedDescription: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

extension Method {
    public init(_ rawValue: String) {
        let method = rawValue.uppercased()
        switch method {
        case "POST":
            self = .post
        case "PUT":
            self = .put
        case "DELETE":
            self = .delete
        default:
            self = .get
        }
    }
}

extension Method: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:          return "GET"
        case .post:         return "POST"
        case .put:          return "PUT"
        case .delete:       return "DELETE"
        }
    }
}

protocol Requestable { }

extension Requestable {
    func request(method: Method, url: String, params: [String: Any]? = nil, callback: @escaping Handler) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("jvmNAyPNr1JhiCeUlYmB2ae517p3Th0aGG6syqMb", forHTTPHeaderField: "x-api-key")
        print("url: \(url)")
        if let params = params {
            request.setValue(contentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        request.httpMethod = method.description
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    callback(.failure(500))
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                        callback(.success(data!))
                    } else {
                        callback(.failure(httpResponse.statusCode))
                    }
                } else {
                    callback(.failure(500))
                }
            }
        })
        task.resume()
    }
}

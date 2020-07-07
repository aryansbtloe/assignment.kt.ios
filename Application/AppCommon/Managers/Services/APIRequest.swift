//
//  APIRequest.swift
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

class APIRequest: NSObject, Requestable {
    func fetchVideos(pageSize:Int,pageNo:Int ,callback: @escaping CompletionHandler) {
        let url = String(format: EndPoint.videos.path, pageNo,pageSize)
        self.callAPIToGetData(url: url) { (data) in
            switch data {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode([Video].self, from: data)
                    callback(.success(results))
                } catch {
                    callback(.failure(.decodeFailure))
                }
            case .failure(_):
                callback(.failure(.apiFailure))
            }
        }
    }
}

extension APIRequest {
    private func callAPIToGetData(url: String, callback: @escaping DefaultCallBack) {
        request(method: .get, url: url, params: nil) { (data) in
            switch data {
            case .success(let result):
                callback(.success(result))
            case .failure(_):
                callback(.failure((.apiFailure)))
            }
        }
    }
}

//
//  AKSPaginator.swift
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

import Foundation

enum RequestStatus {
    case requestStatusNone
    case requestStatusInProgress
}

protocol AKSPaginatorOutProtocol: class {
    func fetchPage(_ page:NSInteger)
}

//MARK: - Completion block
typealias Completion = (_ paginator:Any) ->()

func paginatorDidFailToRespond(_ paginator: Any){
    
}

class AKSPaginator : NSObject  {
    
    var delegate : AKSPaginatorOutProtocol!
    var pageSize : NSInteger = -1
    var page : NSInteger = -1
    var total : NSInteger = -1
    var results : NSMutableArray = []
    var responseData : NSDictionary?
    var requestStatus : RequestStatus = RequestStatus.requestStatusNone
    var completionBlock: Completion?
    
    func setup(_ pageSize:NSInteger){
        self.pageSize = pageSize
    }
    
    func reset(){
        self.page = 0
        self.results.removeAllObjects()
        self.total = -1
        requestStatus = RequestStatus.requestStatusNone
    }
    
    func fetchFirstPage(){
        reset()
        requestStatus = RequestStatus.requestStatusInProgress
        delegate?.fetchPage(1)
    }
    
    func fetchNextPage(){
        requestStatus = RequestStatus.requestStatusInProgress
        delegate?.fetchPage(page+1)
    }
        
    func reachedLastPage()->(Bool){
        if (total != -1)&&(total <= page) {
            return true
        }
        return false
    }
    
    func setSuccess(_ results:[Any],totalResults:NSInteger){
        if results != nil && results.count > 0 {
            page += 1
            self.results.addObjects(from: results)
        }
        requestStatus = RequestStatus.requestStatusNone
        if completionBlock != nil {
            completionBlock!(self)
        }
        total = totalResults
    }
    func setFailure(){
        requestStatus = RequestStatus.requestStatusNone
        if completionBlock != nil {
            completionBlock!(self)
        }
    }
}

//
//  HomeProtocols.swift
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
import UIKit

///VIEW : PRESENTER -> VIEW
protocol HomeViewProtocol: class {
    var presenter: HomePresenterProtocol? { get set }
    var viewModal:[VideoViewModal] { get set }
}

///PRESENTER : VIEW -> PRESENTER
protocol HomePresenterProtocol: class {
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    func viewDidLoad()
    func reachedEndOfThePage()
}

///PRESENTER : INTERACTOR -> PRESENTER
protocol HomeInteractorOutputProtocol: class {
    func pageRequestCompleted(pageSize:Int,pageNo:Int,results:[Video])
    func pageRequestFailed()
}

///INTERACTOR : PRESENTER -> INTERACTOR
protocol HomeInteractorInputProtocol: class {
    var presenter: HomeInteractorOutputProtocol? { get set }
    var apiDataManager: HomeAPIManagerInputProtocol? { get set }
    func fetchVideos(pageSize:Int,pageNo:Int)
}

///INTERACTOR : APIDATAMANAGER -> INTERACTOR
protocol HomeAPIManagerOutputProtocol: class{
    func pageRequestCompleted(pageSize:Int,pageNo:Int,results:[Video])
    func pageRequestFailed()
}

///APIDATAMANAGER : INTERACTOR -> HomeAPIManager
protocol HomeAPIManagerInputProtocol: class{
    var caller: HomeAPIManagerOutputProtocol? { get set }
    func fetchVideos(pageSize:Int,pageNo:Int)
}

///LOGIN WIREFRAME
protocol HomeWireFrameProtocol: class{
    static func presentModule(_ navigationController: UINavigationController?, animated: Bool)
}


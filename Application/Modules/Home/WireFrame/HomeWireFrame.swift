//
//  HomeWireFrame.swift
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

class HomeWireFrame: HomeWireFrameProtocol {

    class func presentModule(_ navigationController: UINavigationController?, animated: Bool) {
        navigationController?.pushViewController(getView(), animated: animated)
    }

    class func getView() -> UIViewController {
        // Generating module components
        let viewController = viewControllerObject(identifier: "HomeViewController")
        let view: UIViewController & HomeViewProtocol = viewController as! UIViewController & HomeViewProtocol
        let presenter: HomePresenterProtocol & HomeInteractorOutputProtocol = HomePresenter()
        let interactor: HomeInteractorInputProtocol & HomeAPIManagerOutputProtocol = HomeInteractor()
        let apiDataManager: HomeAPIManagerInputProtocol = HomeAPIManager()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.apiDataManager = apiDataManager
        apiDataManager.caller = interactor
        return view
    }

}

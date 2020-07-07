//
//  AksCommonFunctions + ViewController.swift
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
@objc public extension AksCommonFunctions {

    /// return key
    ///
    /// - Returns: return key window object
    class func window() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }

    /// return root view controller on key window
    ///
    /// - Returns: view controller at root level
    class func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }

    /// Is anything presented
    ///
    /// - Returns: true if any view controller is already presented
    class func isSomethingPresented() -> Bool {
        let topVC = AksCommonFunctions.getTopViewController()
        if topVC != nil {
            return topVC!.presentingViewController != nil
        } else {
            return false
        }
    }

    /// Returns top view controller
    ///
    /// - Parameter viewController: do not pass this parameter
    /// - Returns: top view controller
    class func getTopViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
        let viewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = viewController as? UINavigationController,
            !navigationController.viewControllers.isEmpty {
            return getTopViewController(navigationController.viewControllers.last)
        } else if let tabBarController = viewController as? UITabBarController,
            let selectedController = tabBarController.selectedViewController {
            return getTopViewController(selectedController)
        } else if let presentedController = viewController?.presentedViewController {
            return getTopViewController(presentedController)
        }
        return viewController
    }

}

public func window() -> UIWindow? {
    return AksCommonFunctions.window()
}

public func rootViewController() -> UIViewController? {
    return AksCommonFunctions.rootViewController()
}

public func isSomethingPresented() -> Bool {
    return AksCommonFunctions.isSomethingPresented()
}

func mainStoryboard() -> UIStoryboard {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    return storyboard
}

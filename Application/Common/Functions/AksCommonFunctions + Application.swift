//
//  AksCommonFunctions + Animations.swift
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
@objc  public extension AksCommonFunctions {

    /// Returns current app version number as string
    ///
    /// - Returns: version number eg:- 5.1.3
    class func versionNumber() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// Compare two version string
    ///
    /// - Parameters:
    ///   - versionFirst: version first
    ///   - versionSecond: version second
    /// - Returns: true if first verison is greater than second else false
    class func compareVersions(_ versionFirst: String?, versionSecond: String?) -> Bool {
        if let versionFirst = versionFirst, let versionSecond = versionSecond, versionFirst.compare(versionSecond, options: .numeric, range: nil, locale: .current) == .orderedDescending {
            return true
        } else {
            return false
        }
    }

    /// Returns the comparison result between newer and older iOS version
    ///
    /// - Parameter version: older iOS version
    /// - Returns: [-1,0,1] , -1 means current version is lesser than passed version, 0 means current version is same as passed version, 1 means current version is greater than the passed version
    class func compareCurrentOSVersionWith(osVersion version: String) -> Int {
        let comparison = UIDevice.current.systemVersion.compare(version, options: .numeric, range: nil, locale: .current)
        if  comparison == .orderedAscending {
            return -1
        } else if comparison == .orderedSame {
            return 0
        }
        return 1
    }

    /// function to open app settings
    @available(iOS 10.0, *)
    class func openApplicationSettings() {
        DispatchQueue.main.async {
            if let appSettingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsUrl, options: [:], completionHandler: nil)
            }
        }
    }

}

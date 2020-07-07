//
//  AksCommonFunctions + Date.swift
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

@objc public extension AksCommonFunctions {

    /// Returns number of days between two dates
    ///
    /// - Parameters:
    ///   - beginDate: begin date
    ///   - endDate: end date
    /// - Returns: no of days
    class func getNumberOfDaysBetweenTwoDays(_ beginDate: Date?, andEnd endDate: Date?) -> Int {
        guard let beginDate = beginDate else { return 0 }
        guard let endDate = endDate else { return 0 }
        return Calendar(identifier: .gregorian).dateComponents([.day], from: beginDate, to: endDate).day ?? 0
    }

    /// Returns number of months between two dates
    ///
    /// - Parameters:
    ///   - beginDate: begin date
    ///   - endDate: end date
    /// - Returns: no of months
    class func getNumberOfMonthsBetweenTwoDate(_ beginDate: Date?, andEnd endDate: Date?) -> Int {
        guard let beginDate = beginDate else { return 0 }
        guard let endDate = endDate else { return 0 }
        return Calendar(identifier: .gregorian).dateComponents([.month], from: beginDate, to: endDate).month ?? 0
    }

    /// Return new date by adding number of days to date
    ///
    /// - Parameters:
    ///   - date: date to add to
    ///   - days: days
    /// - Returns: new date
    class func change(_ date: Date, withDays days: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.current.date(byAdding: dateComponents, to: date) ?? date
    }

}

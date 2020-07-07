//
//  AksCommonExtensions + String.swift
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
public extension String {

    ///Capitalizes first character of String
    var capitalizeFirst: String {
        if self.count > 0 {
            var result = self
            result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
            return result
        } else {
            return ""
        }
    }

    ///Counts whitespace & new lines
    func isOnlyEmptySpacesAndNewLineCharacters() -> Bool {
        let characterSet = CharacterSet.whitespacesAndNewlines
        let newText = self.trimmingCharacters(in: characterSet)
        return newText.isEmpty
    }

    ///Trims white space and new line characters
    mutating func trim() {
        self = self.trimmed()
    }

    ///Trims white space and new line characters, returns a new string
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    ///Returns if String is a number
    func isNumber() -> Bool {
        if let _ = NumberFormatter().number(from: self) {
            return true
        }
        return false
    }

    ///Checking if String contains input
    func contains(_ find: String) -> Bool {
        return self.range(of: find) != nil
    }

    ///Checking if String contains input with comparing options
    func contains(_ find: String, compareOption: NSString.CompareOptions) -> Bool {
        return self.range(of: find, options: compareOption) != nil
    }

    ///Converts String to Int
    func toInt() -> Int {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return 0
        }
    }

    ///Converts String to Double
    func toDouble() -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en")
        numberFormatter.numberStyle = .decimal
        if let num = numberFormatter.number(from: self) {
            return num.doubleValue
        } else {
            return 0.0
        }
    }

    ///Converts String to Float
    func toFloat() -> Float {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en")
        numberFormatter.numberStyle = .decimal
        if let num = numberFormatter.number(from: self) {
            return num.floatValue
        } else {
            return 0.0
        }
    }

    ///Converts String to Bool
    func toBool() -> Bool {
        return self.trimmed().lowercased() == "true" || self.isNumber() ? self.toDouble() > 0 : false
    }

    /// Returns the first index of the occurency of the character in String
    func getIndexOf(_ char: Character) -> Int? {
        for (index, character) in self.enumerated() {
            if character == char {
                return index
            }
        }
        return nil
    }

    /// Return bounds for text to display with configurable properties like width , max height , font
    ///
    /// - Parameters:
    ///   - width: fixed width
    ///   - maxHeight: height threshold
    ///   - font: font
    /// - Returns: bounds
    func heightWithConstrainedWidth(_ width: CGFloat, maxHeight: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: width, height: maxHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox
    }

    /// Returns the index of sub string in string
    ///
    /// - Parameter target: sub string to find index of
    /// - Returns: index position in string
    func indexOf(_ target: String) -> Int? {
        let range = (self as NSString).range(of: target)
        guard Range(_: range) != nil else {
            return nil
        }
        return range.location
    }

    /// Return URL object from string
    ///
    /// - Returns: URL
    func asURL() -> URL? {
        if let encodedSelf = self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            return URL(string: encodedSelf)
        }
        return nil
    }

    /// Return if this string can be an valid URL
    ///
    /// - Returns: url
    func isURL() -> Bool {
        if let encodedSelf = self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            return URL(string: encodedSelf) != nil ? true : false
        }
        return false
    }

    /// Return string by adding pecent encoding , which is mandatory for creating url from string.
    ///
    /// - Returns: url
    func aURLReady() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }

    /// Returns minimum required height with constrained width
    ///
    /// - Parameters:
    ///   - width: fixed width
    ///   - font: font
    /// - Returns: height
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }

    /// Returns minimum required width with constrained height
    ///
    /// - Parameters:
    ///   - height: fixed height
    ///   - font: font
    /// - Returns: width
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }

}

public extension NSAttributedString {

    /// Returns minimum required height with constrained width
    ///
    /// - Parameters:
    ///   - width: fixed width
    ///   - font: font
    /// - Returns: height
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(boundingBox.height)
    }

    /// Returns minimum required width with constrained height
    ///
    /// - Parameters:
    ///   - height: fixed height
    ///   - font: font
    /// - Returns: width
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(boundingBox.width)
    }
}

public extension String {

    /// Returns strikeThrough text of the string as attributed string
    ///
    /// - Returns: attributed strikeThrough string
    func getStrikeThroughText(offset: Int = 1) -> NSAttributedString {
        let str = NSMutableAttributedString(string: self)
        str.addAttribute(.strikethroughStyle, value: 2, range: NSRange(location: 0, length: str.length))
        str.addAttribute(.baselineOffset, value: offset, range: NSRange(location: 0, length: str.length))
        return str
    }

    /// Returns JSON Object
    ///
    /// - Returns: json object
    func toJSONObject() -> Any? {
        if let data = self.data(using: .utf8) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                return jsonObject

            } catch _ as NSError {}
        }
        return nil
    }

    /// - Returns: NSString value
    func asNSString() -> NSString {
        return self as NSString
    }
}

public extension NSString {
    /// Returns NSString Value
    ///
    /// - Returns: attributed strikeThrough string
    @objc func getStrikeThroughText() -> NSAttributedString {
        return (self as String).getStrikeThroughText()
    }
}

public extension String {
    var hexColorValue: Int? {
        guard self.lowercased().hasPrefix("0x") && self.count == 8 else {
            assert(false, "Hex color value must have a format \"0x<HexValue>\"")
            return nil
        }
        return Int(self.suffix(6), radix: 16)
    }
}

public extension NSAttributedString {
}

public extension NSString {

    @objc func asNSURL() -> NSURL? {
        return (self as String).asURL() as NSURL?
    }
}

public extension String {

    var attributedStringFromHTML: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }

    func attributedStringFromHTML(font: UIFont, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(font.pointSize * 0.75)pt !important;" +
                "color: #\(color.hexString!) !important;" +
                "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

//
//  AksCommonExtensions + Others.swift
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

public extension Bool {
    var stringValue: String {
        return self ? "true" : "false"
    }
}

public extension Numeric {

    /// string value
    var stringValue: String {
        return "\(self)"
    }
}

public extension Double {

    /// integer value
    var intValue: Int {
        return Int(self)
    }
}

public extension Float {

    /// integer value
    var intValue: Int {
        return Int(self)
    }
}

public extension NSTextAlignment {

    /// returns text alignment as per RTL
    static var naturalInverse: NSTextAlignment {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .left : .right
    }

}


public extension JSONDecoder {
    func decodeSafelyArray<T: Decodable>(of type: T.Type, from data: Data) -> [T] {
        guard let array = try? decode([T].self, from: data) else { return [] }
        return array.compactMap { $0 }
    }
}

public struct Safe<T: Decodable>: Decodable {
    public let value: T?
    public init(from decoder: Decoder) throws {
        var data:T? = nil
        do {
            let container = try decoder.singleValueContainer()
            switch T.self {
            case is String.Type:
                if let value = try? container.decode(String.self){
                    data = value as? T
                }else if let value = try? container.decode(Double.self){
                    data = value.stringValue as? T
                }
                break
            case is Double.Type:
                if let value = try? container.decode(Double.self){
                    data = value as? T
                }else if let value = try? container.decode(String.self){
                    data = safeDouble(value) as? T
                }
                break
            case is Int.Type:
                if let value = try? container.decode(Int.self){
                    data = value as? T
                }else if let value = try? container.decode(String.self){
                    data = safeInt(value) as? T
                }
                break
            case is Bool.Type:
                if let value = try? container.decode(Bool.self){
                    data = value as? T
                }else if let value = try? container.decode(String.self){
                    data = safeBool(value) as? T
                }else if let value = try? container.decode(Int.self){
                    data = safeBool(value) as? T
                }
                break
            default:
                data = try container.decode(T.self)
            }
        } catch {
            print(error)
        }
        self.value = data
    }
}

public extension KeyedDecodingContainer {

    func decode<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T {
        return try self.decode(T.self, forKey: key)
    }

    func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }

    func decodeSafely<T: Decodable>(_ key: KeyedDecodingContainer.Key) -> T? {
        return self.decodeSafely(T.self, forKey: key)
    }

    func decodeSafely<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) -> T? {
        let decoded = try? decode(Safe<T>.self, forKey: key)
        return decoded?.value
    }

    func decodeSafelyIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) -> T? {
        return self.decodeSafelyIfPresent(T.self, forKey: key)
    }

    func decodeSafelyIfPresent<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) -> T? {
        let decoded = try? decodeIfPresent(Safe<T>.self, forKey: key)
        return decoded?.value
    }
}

public extension UIColor {
    var hexString: String? {
        var rComponent: CGFloat = 0.0
        var gComponent: CGFloat = 0.0
        var bComponent: CGFloat = 0.0
        var alphaComponent: CGFloat = 1.0
        guard (0...1) .contains(rComponent) && (0...1) .contains(gComponent) && (0...1) .contains(bComponent) && (0...1) .contains(alphaComponent) else {
            return nil
        }
        getRed(&rComponent, green: &gComponent, blue: &bComponent, alpha: &alphaComponent)
        return  String(format: "%02X%02X%02X%02X", (Int)(rComponent * 255), (Int)(gComponent * 255), (Int)(bComponent * 255), (Int)(alphaComponent * 255))
    }
}

public extension CGRect {
    static var one: CGRect {
        return CGRect(x: 0, y: 0, width: 1, height: 1)
    }
}

public extension UIScrollView {

    func simulateOffsetChange() {
        let offset = contentOffset
        contentOffset = CGPoint.zero
        contentOffset = offset
    }

}

extension UIView {
    
    /// <#Description#>
    func showActivityIndicator() {
        if let activityIndicator = self.viewWithTag(123) as? UIActivityIndicatorView {
            activityIndicator.startAnimating()
        }else{
            let activityIndicatorView = UIActivityIndicatorView(style: .gray)
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.tag = 123
            self.addSubview(activityIndicatorView)
            let horizontalConstraint = NSLayoutConstraint(item: activityIndicatorView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: activityIndicatorView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
            self.addConstraint(horizontalConstraint)
            self.addConstraint(verticalConstraint)
            activityIndicatorView.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        self.viewWithTag(123)?.removeFromSuperview()
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

/// <#Description#>
///
/// - Returns: <#return value description#>
func storyBoard()->UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
}


/// <#Description#>
///
/// - Parameter identifier: <#identifier description#>
/// - Returns: <#return value description#>
func viewControllerObject(identifier:String) -> UIViewController {
    return storyBoard().instantiateViewController(withIdentifier:identifier)
}


// MARK: Localizable
public protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    public var localized: String {
        return LS(self)
    }
}

// MARK: XIBLocalizable
public protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}

extension UINavigationItem: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
    }
}

extension UIBarItem: XIBLocalizable { // Localizes UIBarButtonItem and UITabBarItem
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
    }
}

// MARK: Special protocol to localize multiple texts in the same control
public protocol XIBMultiLocalizable {
    var xibLocKeys: String? { get set }
}

extension UISegmentedControl: XIBMultiLocalizable {
    @IBInspectable public var xibLocKeys: String? {
        get { return nil }
        set(keys) {
            guard let keys = keys?.components(separatedBy: ","), !keys.isEmpty else { return }
            for (index, title) in keys.enumerated() {
                setTitle(title.localized, forSegmentAt: index)
            }
        }
    }
}

// MARK: Special protocol to localizaze UITextField's placeholder
public protocol UITextFieldXIBLocalizable {
    var xibPlaceholderLocKey: String? { get set }
}

extension UITextField: UITextFieldXIBLocalizable {
    @IBInspectable public var xibPlaceholderLocKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized
        }
    }
}

//
//  AksCommonFunctions + Others.swift
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
import AVKit

@objc public extension AksCommonFunctions {

    /// To Play video from any view controller
    ///
    /// - Parameters:
    ///   - url: url of video
    ///   - viewController: presenting view controller
    class func playVideo(from url: URL, on viewController: UIViewController) {
        let player: AVPlayer = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        viewController.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }

    /// To check if object is null
    ///
    /// - Parameter object: object
    /// - Returns: bool value indicating object is null or not
    class func isNull(_ object: Any?) -> (Bool) {
        if let object = object {
            if object is NSNull {
                return true
            } else if object is String {
                if object as! String == "<null>" || object as! String == "" || object as! String == "null" {
                    return true
                }
            }
            return false
        }
        return true
    }

    /// To check if object is not null
    ///
    /// - Parameter object: object
    /// - Returns: bool value indicating object is not null or null
    class func isNotNull(_ object: Any?) -> (Bool) {
        return !isNull(object)
    }

    /// Function to return string value from any object
    ///
    /// - Parameter object: object
    /// - Returns: alternate (return any alternate value if object is invalid or null)
    class func safeString(_ object: Any?, alternate: String="") -> String {
        if isNotNull(object) {
            return "\(object!)"
        }
        return alternate
    }

    /// Function to return bool value from any object
    ///
    /// - Parameter object: object
    /// - Returns: alternate (return any alternate value if object is invalid or null)
    class func safeBool(_ object: Any?, alternate: Bool=false) -> Bool {
        if let numberValue = object as? NSNumber {
            return numberValue.boolValue
        } else if let boolValue = object as? Bool {
            return boolValue
        } else if let stringValue = object as? String {
            return stringValue.lowercased() == "true" || stringValue == "1"
        } else if let intValue = object as? Int32 {
            return NSNumber(value: intValue).boolValue
        } else if let doubleValue = object as? Double {
            return NSNumber(value: doubleValue).boolValue
        }
        return alternate
    }

    /// Function to return Int value from any object
    ///
    /// - Parameter object: object
    /// - Returns: alternate (return any alternate value if object is invalid or null)
    class func safeInt(_ object: Any?, alternate: Int=0) -> Int {
        if let intValue = object as? Int {
            return intValue
        } else if let numberValue = object as? NSNumber {
            return numberValue.intValue
        } else if let boolValue = object as? Bool {
            return boolValue ? 1 : 0
        } else if let stringValue = object as? String, stringValue.isNumber() {
            return stringValue.toInt()
        } else if let doubleValue = object as? Double {
            return Int(doubleValue)
        }
        return alternate
    }

    /// Function to return Double value from any object
    ///
    /// - Parameter object: object
    /// - Returns: alternate (return any alternate value if object is invalid or null)
    class func safeDouble(_ object: Any?, alternate: Double=0.0) -> Double {
        if let numberValue = object as? NSNumber {
            return numberValue.doubleValue
        } else if let stringValue = object as? String, stringValue.isNumber() {
            return Double(stringValue.toDouble())
        } else if let doubleValue = object as? Double {
            return doubleValue
        }
        return alternate
    }

    /// Perform checks any return string value from object
    ///
    /// - Parameter object: object
    /// - Returns: alternate (return any alternate value if object is invalid or null)
    class func stringValue(_ object: Any?, alternate: String?=nil) -> String? {
        if isNotNull(object), let object = object {
            return "\(object)"
        }
        return alternate
    }

    /// Perform checks and return NSNumber value from object
    ///
    /// - Parameter object: object
    /// - Returns: alternate (return any alternate value if object is invalid or null)
    class func numberValue(_ object: Any?, alternate: NSNumber?=nil) -> NSNumber? {
        if isNotNull(object), let object = object {
            if let numberValue = object as? NSNumber {
                return numberValue
            } else if let stringValue = object as? String, stringValue.isNumber() {
                return NSNumber(value: Double(stringValue) ?? 0)
            } else if let stringValue = (object as? String)?.lowercased(), stringValue.count <= 5 {
                return NSNumber(value: (stringValue == "true" || stringValue == "1") ? true : false)
            }
        }
        return alternate
    }

    /// To check the validity of string , it internally checks for null , length of the string
    ///
    /// - Parameter string: string to check
    /// - Returns: true if valid and vice versa
    class func AksIsValidString(_ string: String?) -> Bool {
        return isNotNull(string)
    }

}

public func isNull(_ object: Any?) -> (Bool) {return AksCommonFunctions.isNull(object)}
public func isNotNull(_ object: Any?) -> (Bool) {return AksCommonFunctions.isNotNull(object)}
public func safeString(_ object: Any?, alternate: String="") -> String {return AksCommonFunctions.safeString(object, alternate: alternate)}
public func safeBool(_ object: Any?, alternate: Bool=false) -> Bool {return AksCommonFunctions.safeBool(object, alternate: alternate)}
public func safeInt(_ object: Any?, alternate: Int=0) -> Int {return AksCommonFunctions.safeInt(object, alternate: alternate)}
public func safeDouble(_ object: Any?, alternate: Double=0.0) -> Double { return AksCommonFunctions.safeDouble(object, alternate: alternate)}
public func stringValue(_ object: Any?, alternate: String?=nil) -> String? { return AksCommonFunctions.stringValue(object, alternate: alternate)}
public func numberValue(_ object: Any?, alternate: NSNumber?=nil) -> NSNumber? { return AksCommonFunctions.numberValue(object, alternate: alternate)}
public func AksIsValidString(_ string: String?) -> Bool {return AksCommonFunctions.AksIsValidString(string)}


@objc public extension AksCommonFunctions {

    /// Get Primary Key Method
    ///
    /// - Returns: Timestamp in string format
    class func getCurrentTimeStamp() -> Double {
        let timeStamp: Double = Date().timeIntervalSince1970
        return timeStamp
    }
}

public func decode<T: Codable>(_ type: T.Type, data: Data?) -> T? {
    do {
        if let jsonAsData = data {
            return try JSONDecoder().decode(T.self, from: jsonAsData)
        }
    } catch {
        print("Failed to decode JSON for \n==>object \(T.self)")
    }
    return nil
}

func LS(_ key:String)->String{
     func LS(_ key: String, defaultValue: String="") -> String {
        func getLanguageBundle() -> Bundle? {
            let filename = getResourceFileName()
            let filenameDefault = "en"
            if let path = Bundle.main.path(forResource: filename, ofType: "lproj") {
                return Bundle(path: path)
            }else if let path = Bundle.main.path(forResource: filenameDefault, ofType: "lproj") {
                return Bundle(path: path)
            }
            return nil
        }
        return getLanguageBundle()?.localizedString(forKey: key, value: "", table: nil) ?? defaultValue
    }
    return LS(key, defaultValue: key)
}

func getResourceFileName() -> String {
   return String(Locale.current.languageCode?.prefix(2) ?? "")
}

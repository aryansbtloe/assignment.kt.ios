//
//  AksCommonFunctions + Device Info.swift
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

}

/// Returns device width
///
/// - Returns: width
public var deviceWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}

/// Returns device height
///
/// - Returns: height
public var deviceHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}

public enum Device: CustomStringConvertible, Equatable {
    case iPodTouch5
    case iPodTouch6
    case iPhone4
    case iPhone4s
    case iPhone5
    case iPhone5c
    case iPhone5s
    case iPhone6
    case iPhone6Plus
    case iPhone6s
    case iPhone6sPlus
    case iPhone7
    case iPhone7Plus
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhoneXs
    case iPhoneXsMax
    case iPhoneXr
    case iPad2
    case iPad3
    case iPad4
    case iPadAir
    case iPadAir2
    case iPad5
    case iPad6
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4
    case iPadPro9Inch
    case iPadPro12Inch
    case iPadPro12Inch2
    case iPadPro10Inch
    case iPadPro11Inch
    case iPadPro12Inch3
    case homePod

    indirect case simulator(Device)

    /// Device is not yet known (implemented)
    /// You can still use this enum as before but the description equals the identifier (you can get multiple identifiers for the same product class
    /// (e.g. "iPhone6,1" or "iPhone 6,2" do both mean "iPhone 5s"))
    case unknown(String)

    /// Initializes a `Device` representing the current device this software runs on.
    public init() {
        self = Device.instance
    }

    /// Gets the identifier from the system, such as "iPhone7,1".
    public static var identifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)

        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()

    private static let instance = Device.mapToDevice(identifier: Device.identifier)

    /// Maps an identifier to a Device. If the identifier can not be mapped to an existing device, `UnknownDevice(identifier)` is returned.
    ///
    /// - parameter identifier: The device identifier, e.g. "iPhone7,1". Can be obtained from `Device.identifier`.
    ///
    /// - returns: An initialized `Device`.
    public static func mapToDevice(identifier: String) -> Device { // swiftlint:disable:this cyclomatic_complexity
        switch identifier {
        case "iPod5,1": return iPodTouch5
        case "iPod7,1": return iPodTouch6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return iPhone4
        case "iPhone4,1": return iPhone4s
        case "iPhone5,1", "iPhone5,2": return iPhone5
        case "iPhone5,3", "iPhone5,4": return iPhone5c
        case "iPhone6,1", "iPhone6,2": return iPhone5s
        case "iPhone7,2": return iPhone6
        case "iPhone7,1": return iPhone6Plus
        case "iPhone8,1": return iPhone6s
        case "iPhone8,2": return iPhone6sPlus
        case "iPhone9,1", "iPhone9,3": return iPhone7
        case "iPhone9,2", "iPhone9,4": return iPhone7Plus
        case "iPhone8,4": return iPhoneSE
        case "iPhone10,1", "iPhone10,4": return iPhone8
        case "iPhone10,2", "iPhone10,5": return iPhone8Plus
        case "iPhone10,3", "iPhone10,6": return iPhoneX
        case "iPhone11,2": return iPhoneXs
        case "iPhone11,4", "iPhone11,6": return iPhoneXsMax
        case "iPhone11,8": return iPhoneXr
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3": return iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6": return iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3": return iPadAir
        case "iPad5,3", "iPad5,4": return iPadAir2
        case "iPad6,11", "iPad6,12": return iPad5
        case "iPad7,5", "iPad7,6": return iPad6
        case "iPad2,5", "iPad2,6", "iPad2,7": return iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6": return iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9": return iPadMini3
        case "iPad5,1", "iPad5,2": return iPadMini4
        case "iPad6,3", "iPad6,4": return iPadPro9Inch
        case "iPad6,7", "iPad6,8": return iPadPro12Inch
        case "iPad7,1", "iPad7,2": return iPadPro12Inch2
        case "iPad7,3", "iPad7,4": return iPadPro10Inch
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return iPadPro11Inch
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return iPadPro12Inch3
        case "AudioAccessory1,1": return homePod
        case "i386", "x86_64": return simulator(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))
        default: return unknown(identifier)
        }
    }

    /// Compares two devices
    ///
    /// - parameter lhs: A device.
    /// - parameter rhs: Another device.
    ///
    /// - returns: `true` iff the underlying identifier is the same.
    public static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.description == rhs.description
    }

    /// A textual representation of the device.
    public var description: String {
        switch self {
        case .iPodTouch5: return "iPod Touch 5"
        case .iPodTouch6: return "iPod Touch 6"
        case .iPhone4: return "iPhone 4"
        case .iPhone4s: return "iPhone 4s"
        case .iPhone5: return "iPhone 5"
        case .iPhone5c: return "iPhone 5c"
        case .iPhone5s: return "iPhone 5s"
        case .iPhone6: return "iPhone 6"
        case .iPhone6Plus: return "iPhone 6 Plus"
        case .iPhone6s: return "iPhone 6s"
        case .iPhone6sPlus: return "iPhone 6s Plus"
        case .iPhone7: return "iPhone 7"
        case .iPhone7Plus: return "iPhone 7 Plus"
        case .iPhoneSE: return "iPhone SE"
        case .iPhone8: return "iPhone 8"
        case .iPhone8Plus: return "iPhone 8 Plus"
        case .iPhoneX: return "iPhone X"
        case .iPhoneXs: return "iPhone Xs"
        case .iPhoneXsMax: return "iPhone Xs Max"
        case .iPhoneXr: return "iPhone Xr"
        case .iPad2: return "iPad 2"
        case .iPad3: return "iPad 3"
        case .iPad4: return "iPad 4"
        case .iPadAir: return "iPad Air"
        case .iPadAir2: return "iPad Air 2"
        case .iPad5: return "iPad 5"
        case .iPad6: return "iPad 6"
        case .iPadMini: return "iPad Mini"
        case .iPadMini2: return "iPad Mini 2"
        case .iPadMini3: return "iPad Mini 3"
        case .iPadMini4: return "iPad Mini 4"
        case .iPadPro9Inch: return "iPad Pro (9.7-inch)"
        case .iPadPro12Inch: return "iPad Pro (12.9-inch)"
        case .iPadPro12Inch2: return "iPad Pro (12.9-inch) (2nd generation)"
        case .iPadPro10Inch: return "iPad Pro (10.5-inch)"
        case .iPadPro11Inch: return "iPad Pro (11-inch)"
        case .iPadPro12Inch3: return "iPad Pro (12.9-inch) (3rd generation)"
        case .homePod: return "HomePod"
        case .simulator(let model): return "Simulator (\(model))"
        case .unknown(let identifier): return identifier
        }
    }

    public static func isXSeriesDevice() -> Bool {
        return [.iPhoneX, .iPhoneXs, .iPhoneXr, .iPhoneXsMax].contains(Device())
    }
}

@objc public extension AksCommonFunctions {

    class func adjustForWidth(_ base: CGFloat, value: CGFloat) -> CGFloat {
        return (deviceWidth/base)*value
    }

}

public func adjustForWidth(_ base: CGFloat=375, value: CGFloat) -> CGFloat {
    return Cfns.adjustForWidth(base, value: value)
}

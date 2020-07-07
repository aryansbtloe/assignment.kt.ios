//
//  AksCommonFunctions + String.swift
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
    
    //return array of alphabets string
    class func getAlphabetHash() -> [String] {
        var hash = (65...90).map {
            return String(UnicodeScalar($0))
        }
        hash.insert("#", at: 0)
        return hash
    }
    
    /// Returns RSA encrypted string
    ///
    /// - Parameters:
    ///   - string: string to be encrypted
    ///   - publicKey: RSA public key
    /// - Returns: encrypted string
    @available(iOS 10.0, *)
    class func decodeKey(publicKey: String?) -> SecKey? {
        guard let publicKey = publicKey else { return nil }
        guard let data = Data(base64Encoded: publicKey) else { return nil }
        
        let keyDict:[NSObject:NSObject] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: NSNumber(value: 2048),
            kSecReturnPersistentRef: true as NSObject
        ]
        
        guard let secKey = SecKeyCreateWithData(data as CFData, keyDict as CFDictionary, nil) else { return nil }
        return secKey
    }
    
    class func encryptString(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)
        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)
        
        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
}

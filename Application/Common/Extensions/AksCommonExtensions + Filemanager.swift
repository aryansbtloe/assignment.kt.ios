//
//  AksCommonExtensions + Filemanager.swift
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

 public extension FileManager {

    /// Move content
    ///
    /// - Parameters:
    ///   - sourceUrl: source url
    ///   - destinationUrl: destination url
    /// - Returns: moved ??
    func moveContentsAtDirectory(sourceDirectoryUrl: URL, toUrl destinationDirectoryUrl: URL) -> Bool {
        do {
            let arrayContents: [String] = try self.contentsOfDirectory(atPath: sourceDirectoryUrl.path)
            for sourceFileName: String in arrayContents {
                let finalSourcePathUrl = sourceDirectoryUrl.appendingPathComponent(sourceFileName)
                let destinationFileUrl = destinationDirectoryUrl.appendingPathComponent(sourceFileName)
                try self.moveItem(at: finalSourcePathUrl, to: destinationFileUrl)
            }
            try self.removeItem(at: sourceDirectoryUrl)
            return true
        } catch {print("\(error.localizedDescription)")}
        return false
    }

    /// Create directory
    ///
    /// - Parameters:
    ///   - sourceUrl: source url
    ///   - overwrite: overwrite ??
    func createDirectoryAtUrl(sourceUrl: URL, overwrite: Bool) {
        var isDirectory: ObjCBool = true
        let isFileExists: Bool = self.fileExists(atPath: sourceUrl.path, isDirectory: &isDirectory)
        if(isFileExists && overwrite) {
            do {
                try self.removeItem(at: sourceUrl)
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        if(!isFileExists || overwrite) {
            do {
                try self.createDirectory(at: sourceUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }

}

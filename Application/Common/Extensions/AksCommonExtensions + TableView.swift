//
//  AksCommonExtensions + TableView.swift
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
public extension UITableView {

    /// Scroll the table to the last cell
    ///
    /// - Parameter animated: animated
    func scrollToLastCell(animated: Bool) {
        let lastSectionIndex = self.numberOfSections - 1 // last section
        let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1 // last row
        if(lastRowIndex >= 0 && lastSectionIndex >= 0) {
            self.safelyScrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: animated)
        }
    }

    /// Scroll the table to the first cell
    ///
    /// - Parameter animated: animated
    func scrollToFirstCell(animated: Bool) {
        self.safelyScrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
    }

    /// Scroll tableView to indexPath
    ///
    /// - Parameters:
    ///   - indexPath: index path to scroll to
    ///   - scrollPosition: scroll position
    ///   - animated: animated
    /// - Returns: scrolled ??
    @discardableResult
    @objc func safelyScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition = .top, animated: Bool = false) -> Bool {
        guard (indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)) else {
            return false
        }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        return true
    }

    /// Reload index Path
    ///
    /// - Parameters:
    ///   - indexPath: index path to reload
    ///   - animation: reload animation
    /// - Returns: reloaded ??
    @discardableResult
    @objc func safelyReloadToRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) -> Bool {
        guard (indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)) else {
            return false
        }
        reloadRows(at: [indexPath], with: animation)
        return true
    }

    /// Scroll tableView to section
    ///
    /// - Parameters:
    ///   - section: section to scroll to
    ///   - scrollPosition: scroll position
    ///   - animated: animated
    /// - Returns: scrolled ??
    @discardableResult
    @objc func scrollToSection(section: Int, at scrollPosition: UITableView.ScrollPosition = .top, animated: Bool = false) -> Bool {
        return safelyScrollToRow(at: IndexPath(row: 0, section: section), at: scrollPosition, animated: animated)
    }
}

@objc public extension UITableView {
    /// Scroll to top of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToTop(animated: Bool = true) {
        self.setContentOffset(CGPoint(x: 0, y: -self.contentInset.top), animated: animated)
    }
    /// Reload index Path
    ///
    /// - Parameters:
    ///   - indexPath: index path to reload
    ///   - animation: reload animation
    /// - Returns: reloaded ??
    @discardableResult
    @objc func safelyReloadSection(at section: Int, with animation: UITableView.RowAnimation) -> Bool {
        guard section < numberOfSections else {
            return false
        }
        reloadSections(IndexSet(integer: section), with: animation)
        return true
    }
}

func registerNib(_ nibName:String,tableView:UITableView?){
    tableView?.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
}

func registerNibAsHeader(_ nibName:String,tableView:UITableView?){
    tableView?.register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: nibName)
}

func registerNib(_ nibName:String,collectionView:UICollectionView?){
    collectionView?.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
}

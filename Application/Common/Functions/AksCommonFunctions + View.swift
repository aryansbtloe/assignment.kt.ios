//
//  AksCommonFunctions + View.swift
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

    /// Function to add subview in any container view programmatically using constraints
    ///
    /// - Parameters:
    ///   - subview: view to add to container
    ///   - container: container view
    class func add(_ subview: UIView?, inContainer container: UIView?) {
        add(subview, inContainer: container, withPadding: .zero, horizontalCenter: false)
    }

    /// Function to add subview in any container view programmatically using constraints
    ///
    /// - Parameters:
    ///   - subview: view to add to container
    ///   - container: container view
    ///   - edge: edges
    class func add(_ subview: UIView?, inContainer container: UIView?, withPadding edge: UIEdgeInsets) {
        add(subview, inContainer: container, withPadding: edge, horizontalCenter: false)
    }

    /// Function to add subview in any container view programmatically using constraints
    ///
    /// - Parameters:
    ///   - subview: view to add to container
    ///   - container: container view
    ///   - edge: edges
    ///   - horizontal: should it be horizontally centered ?
    class func add(_ subview: UIView?, inContainer container: UIView?, withPadding edge: UIEdgeInsets = .zero, horizontalCenter horizontal: Bool = false) {
        if let subview = subview, let container = container {
            subview.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(subview)
            let views = ["subview": subview]
            var constraints = [NSLayoutConstraint]()
            let left = edge.left
            let right = edge.right
            let top: CGFloat = edge.top
            let bottom: CGFloat = edge.bottom
            constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(top)-[subview]-\(bottom)-|", options: [], metrics: nil, views: views))
            if horizontal {
                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=\(`left`))-[subview]-(>=\(`right`))-|", options: [], metrics: nil, views: views))
                constraints.append(contentsOf: [NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1.0, constant: 0)])
            } else {
                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(`left`)-[subview]-\(`right`)-|", options: [], metrics: nil, views: views))
            }
            container.addConstraints(constraints)
        }
    }

}

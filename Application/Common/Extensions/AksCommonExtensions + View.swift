//
//  AksCommonExtensions + View.swift
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
// MARK: - Properties
@objc public extension UIView {

    ///Height of view.
    var viewHeight: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    ///Width of view.
    var viewWidth: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    ///Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            viewWidth = newValue.width
            viewHeight = newValue.height
        }
    }

    ///Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    ///x origin of view.
    var positionX: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    ///y origin of view.
    var positionY: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }

}

// MARK: - Layers
@objc public extension UIView {

    /// Remove all layers
    func removeLayers() {
        self.layer.mask = nil
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }

    /// set corner radius
    ///
    /// - Parameter radius: radius
    func setUpCornerRadius(_ radius: CGFloat = 6.0) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    /// set border
    ///
    /// - Parameters:
    ///   - color: border color
    ///   - width: border width
    func setUpBorder(_ color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    /// setup dashed border
    ///
    /// - Parameter borderColor: border color
    func setUpDashedBorder(_ borderColor: UIColor) {
        let dashBorderLayer = CAShapeLayer()
        dashBorderLayer.strokeColor = borderColor.cgColor
        dashBorderLayer.lineDashPattern = [2, 2]
        dashBorderLayer.frame = self.bounds
        dashBorderLayer.fillColor = nil
        dashBorderLayer.lineCap = CAShapeLayerLineCap.round
        dashBorderLayer.path = UIBezierPath(rect: self.bounds).cgPath
        layer.addSublayer(dashBorderLayer)
    }

    /// Draw shadow for view with color and opacity
    ///
    /// - Parameters:
    ///   - view: view
    ///   - color: color
    ///   - opacity: opacity
    func drawDefaultShadow(with color: UIColor, andOpacity opacity: Float) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    /// Draw shadow for view with color and opacity
    ///
    /// - Parameters:
    ///   - view: view
    ///   - color: color
    ///   - opacity: opacity
    func drawDefaultShadow(with color: UIColor) {
        drawDefaultShadow(with: color, andOpacity: 0.4)
    }

    /// Remove all subviews
    func removeSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

}

@objc public extension UIView {

    /// Returns frame of view with respect to window
    ///
    /// - Returns: frame
    func frameOnWindow() -> CGRect {
        return self.superview?.convert(self.frame, to: nil) ?? CGRect.zero
    }

    /// Returns if view is visible on the UI
    ///
    /// - Returns: visibility
    @objc func isVisibleOnUI() -> Bool {
        return self.isVisibleOnUI(inset: .zero)
    }

    /// Returns if view is visible on the UI with reduced generalised inset
    ///
    /// - Returns: visibility
    @objc func isVisibleOnUIWithGeneralInsets() -> Bool {
        let inset: UIEdgeInsets = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        return self.isVisibleOnUI(inset:inset)
    }

    /// Returns if view is visible on the UI
    ///
    /// - Returns: visibility
    @objc func isVisibleOnUI(inset: UIEdgeInsets=UIEdgeInsets.zero) -> Bool {
        guard let _ = self.window else {return false}
        var view = self
        while let superview = view.superview {
            if superview.bounds.intersects(view.frame) == false || view.alpha == 0 || view.isHidden {
                return false
            }
            view = superview
        }
        return self.alpha != 0 && self.isHidden == false && frameOnWindow().intersects(UIScreen.main.bounds.inset(by: inset))
    }

    func popAnimated() {
        let option = UIView.AnimationOptions.curveEaseInOut
        self.layer.opacity = 0.01
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4, delay: 0.4, options: option, animations: {
            self.layer.opacity = 0.8
        }) { (_) in
        }
        UIView.animate(withDuration: 0.4 - 2*0.08, delay: 0.4, options: option, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.08, delay: 0, options: option, animations: {
                self.layer.opacity = 0.9
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) { (_) in
                UIView.animate(withDuration: 0.08, delay: 0, options: option, animations: {
                    self.layer.opacity = 1.0
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }) { (_) in
                }
            }
        }
    }

    class func fadeInAndOut(views: [UIView], fadeOut: TimeInterval, fadeIn: TimeInterval) {
        UIView.animate(withDuration: fadeOut, delay: 0, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            for view in views {
                view.layer.opacity = 0.4
            }
        }, completion: { (_) in
            UIView.animate(withDuration: fadeIn, delay: 0, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
                for view in views {
                    view.layer.opacity = 0.65
                }
            }, completion: { (_) in})
        })
    }
}

@objc public extension UIView {

    @objc func setBlurred(_ blurred: Bool) {
        let tagIdentifier = 123
        let totalAnimationDuration = 0.4
        let pauseAnimationAtDuration = totalAnimationDuration * 0.25
        let resumeAnimationDuration = totalAnimationDuration * 0.1
        var blurEffectView = self.viewWithTag(tagIdentifier) as? UIVisualEffectView
        let enabled = blurEffectView?.effect != nil
        guard blurred != enabled else { return }
        switch blurred {
        case true:
            if isNull(blurEffectView) {
                blurEffectView = UIVisualEffectView(frame: .zero)
                blurEffectView?.tag = tagIdentifier
                self.addSubview(blurEffectView!)
                blurEffectView?.pinToEdgesOfSuperview()
            }
            let blurEffect = UIBlurEffect(style: .light)
            UIView.animate(withDuration: totalAnimationDuration) {
                blurEffectView?.effect = blurEffect
            }
            blurEffectView?.pauseAnimation(delay: pauseAnimationAtDuration)
        case false:
            blurEffectView?.resumeAnimation()
            UIView.animate(withDuration: resumeAnimationDuration) {
                blurEffectView?.effect = nil
            }
        }
    }

    private func pauseAnimation(delay: Double) {
        let time = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, time, 0, 0, 0, { _ in
            let layer = self.layer
            let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0.0
            layer.timeOffset = pausedTime
        })
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
    }

    private func resumeAnimation() {
        let pausedTime  = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    }

}

@objc public extension UILabel {

    func setHTML(text: String?) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let attributedText = text?.attributedStringFromHTML(font: self.font, color: self.textColor)
            DispatchQueue.main.async {
                self.attributedText = attributedText
            }
        }
    }

}

@objc public extension UIStackView {

    func removeAllArrangedSubviews() {
        guard arrangedSubviews.count > 0 else { return } 
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }

}

@objc public extension UIScrollView {

    private struct Constant {
        static var percentageOffsetToBelieveNearToBottom: CGFloat = 90.0
    }

    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var isNearToBottom: Bool {
        return contentOffset.y >= (Constant.percentageOffsetToBelieveNearToBottom/100.0)*verticalOffsetForBottom
    }

    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }

}

public extension UIView {

    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurEffectView"
    }

    private (set) var blurEffectView: BlurView {
        get {
            if let blurEffectView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return blurEffectView
            }
            self.blurEffectView = BlurView(to: self)
            return self.blurEffectView
        }
        set(blurEffectView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurEffectView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }


    func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }

    func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}

public class BlurView {

    private var superview: UIView
    private var blur: UIVisualEffectView?
    private var editing: Bool = false
    private (set) var blurContentView: UIView?
    private (set) var vibrancyContentView: UIView?

    var animationDuration: TimeInterval = 0.1

    /**
     * Blur style. After it is changed all subviews on
     * blurContentView & vibrancyContentView will be deleted.
     */
    var style: UIBlurEffect.Style = .light {
        didSet {
            guard oldValue != style,
                !editing else { return }
            applyBlurEffect()
        }
    }
    /**
     * Alpha component of view. It can be changed freely.
     */
    public var alpha: CGFloat = 0 {
        didSet {
            guard !editing else { return }
            if blur == nil {
                applyBlurEffect()
            }
            let alpha = self.alpha
            UIView.animate(withDuration: animationDuration) {
                self.blur?.alpha = alpha
            }
        }
    }

    init(to view: UIView) {
        self.superview = view
    }

    public func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
        self.editing = true

        self.style = style
        self.alpha = alpha

        self.editing = false

        return self
    }

    public func enable(isHidden: Bool = false) {
        if blur == nil {
            applyBlurEffect()
        }

        self.blur?.isHidden = isHidden
    }

    private func applyBlurEffect() {
        blur?.removeFromSuperview()

        applyBlurEffect(
            style: style,
            blurAlpha: alpha
        )
    }

    private func applyBlurEffect(style: UIBlurEffect.Style,
                                 blurAlpha: CGFloat) {
        superview.backgroundColor = UIColor.clear

        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.contentView.addSubview(vibrancyView)

        blurEffectView.alpha = blurAlpha

        superview.insertSubview(blurEffectView, at: 0)

        blurEffectView.addAlignedConstrains()
        vibrancyView.addAlignedConstrains()

        self.blur = blurEffectView
        self.blurContentView = blurEffectView.contentView
        self.vibrancyContentView = vibrancyView.contentView
    }
}

public extension UIView {

    private struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "tapGestureRecognizer"
        static var swipeGestureRecognizer = "swipeGestureRecognizer"
    }

    typealias TapAction = (() -> Void)?
    typealias SwipeAction = ((UISwipeGestureRecognizer.Direction) -> Void)?

    private var tapGestureRecognizerAction: TapAction? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? TapAction
            return tapGestureRecognizerActionInstance
        }
    }

    private var swipeGestureRecognizerAction: SwipeAction? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.swipeGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKeys.swipeGestureRecognizer) as? SwipeAction
        }
    }

    func addTapGestureRecognizer(action: (() -> Void)?)->UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapGestureRecognizer)
        return tapGestureRecognizer
    }

    func didSwipe(action: SwipeAction) {
        self.isUserInteractionEnabled = true
        self.swipeGestureRecognizerAction = action
        let gestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        gestureRecognizerLeft.direction = .left
        self.addGestureRecognizer(gestureRecognizerLeft)
        let gestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        gestureRecognizerRight.direction = .right
        self.addGestureRecognizer(gestureRecognizerRight)
    }

    @objc private func didTap(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        }
    }

    @objc private func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        if let action = self.swipeGestureRecognizerAction {
            action?(sender.direction)
        }
    }

}


private var leadingAssociatedObjectHandle: UInt8 = 0
private var trailingAssociatedObjectHandle: UInt8 = 0
private var widthAssociatedObjectHandle: UInt8 = 0
private var heightAssociatedObjectHandle: UInt8 = 0
private var aspectRatioObjectHandle: UInt8 = 0

@objc public protocol LayoutItem {}
extension UIView: LayoutItem {}
extension UILayoutGuide: LayoutItem {}

/**
 Wrapper for the standard `NSLayoutConstraint` with some default values added for ease of use.
 This method adds the constraint to the view. This is the core method that every method in `KGNAutoLayout` uses deep down.

 - Parameter item: The item to constrain.
 - Parameter attribute: The attribute of the `item` to constrain.
 - Parameter toItem: The item to constrain the `item` to, defaults to nil.
 - Parameter attribute: The attribute of the `toItem` to constrain the `item` `attribute` to, defaults to `NotAnAttribute`.
 - Parameter relatedBy: The relation of the two items, deffaults to `Equal`.
 - Parameter multiplier: The multiplier of the constraint, defaults to `1`.
 - Parameter offset: The offset(`constant`) of the constraint, defaults to `0`.
 - Parameter priority: The priority of the constraint, defaults to `nil`.

 - Returns: The constraint object.
 */
@discardableResult
public func setConstraint(item: Any, attribute itemAttribute: NSLayoutConstraint.Attribute, toItem: Any? = nil, attribute toAttribute: NSLayoutConstraint.Attribute = .notAnAttribute, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    if let view = item as? UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    let constraint = NSLayoutConstraint(
        item: item,
        attribute: itemAttribute,
        relatedBy: relatedBy,
        toItem: toItem,
        attribute: toAttribute,
        multiplier: multiplier,
        constant: offset
    )
    constraint.priority = priority
    return constraint
}

// MARK: constraint properties
@objc public extension UIView {

    @objc private(set) var leadingConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &leadingAssociatedObjectHandle) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &leadingAssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private(set) var trailingConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &trailingAssociatedObjectHandle) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &trailingAssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private(set) var heightSizeConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &heightAssociatedObjectHandle) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &heightAssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private(set) var widthSizeConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &widthAssociatedObjectHandle) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &widthAssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private(set) var aspectRatioConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &aspectRatioObjectHandle) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &aspectRatioObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}

// MARK: - Size
@objc public extension UIView {

    /**
     Constrain the width to height of the view.

     - Parameter aspectRatio: The the required ratio of (width/height).
     - Parameter priority: The priority of the constraints.

     - Returns: The constraint object.
     */
    @discardableResult
    @objc func set(aspectRatio: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        if aspectRatio <= 0 {
            assert(false, "Aspect ratio can't be negative")
            return nil
        }
        if self.aspectRatioConstraint == nil || self.aspectRatioConstraint?.multiplier != aspectRatio {
            self.aspectRatioConstraint = self.constraint(attribute: .width, toAttribute: .height, ofItem: self, multiplier: aspectRatio, priority: priority)
        }

        return self.aspectRatioConstraint
    }

    /**
     Constrain the width and height of the view to given layout item.

     - Parameter item: The layout item to constrain the view's width and height to.
     - Parameter priority: The priority of the constraints.

     - Returns: The constraint object.
     */

    @objc func size(to item: LayoutItem, priority: UILayoutPriority = .required) {
        self.sizeWidth(to: item, priority: priority)
        self.sizeHeight(to: item, priority: priority)
    }

    /**
     Constrain the width of the view to given layout item.

     - Parameter item: The layout item to constrain the view's width to.
     - Parameter priority: The priority of the constraints.

     - Returns: The constraint object.
     */
    @discardableResult
    @objc func sizeWidth(to item: LayoutItem, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, offset: CGFloat = 0) -> NSLayoutConstraint? {
        self.widthSizeConstraint = self.constraint(attribute: .width, toAttribute: .width, ofItem: item, relatedBy: relatedBy, multiplier: multiplier, offset: offset, priority: priority)
        return self.widthSizeConstraint
    }

    /**
     Constrain the height of the view to given layout item.

     - Parameter item: The layout item to constrain the view's height to.
     - Parameter priority: The priority of the constraints.

     - Returns: The constraint object.
     */
    @discardableResult
    @objc func sizeHeight(to item: LayoutItem, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1) -> NSLayoutConstraint? {
        self.heightSizeConstraint = self.constraint(attribute: .height, toAttribute: .height, ofItem: item, relatedBy: relatedBy, multiplier: multiplier, offset: 0, priority: priority)
        return self.heightSizeConstraint
    }

    /**
     Constrain the height of the view to given layout item.

     - Parameter item: The layout item to constrain the view's height to.
     - Parameter priority: The priority of the constraints.

     - Returns: The constraint object.
     */
    @discardableResult
    @objc func sizeHeight(to item: LayoutItem, multiplier: CGFloat) -> NSLayoutConstraint? {
        self.heightSizeConstraint = self.constraint(attribute: .height, toAttribute: .height, ofItem: item, relatedBy: .equal, multiplier: multiplier, offset: 0, priority: .defaultHigh)
        return self.heightSizeConstraint
    }

    /**
     Constrain the width and Height of the view.

     - Parameter size: The size to constrain the view to.

     */
    @objc func size(toSize size: CGSize) {
        self.size(toWidth: size.width)
        self.size(toHeight: size.height)
    }

    /**
     Constrain the width of the view.

     - Parameter width: The width to constrain the view to.

     - Returns: The constraint object.
     */
    @discardableResult
    @objc func size(toWidth width: CGFloat, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        if self.widthSizeConstraint == nil {
            self.widthSizeConstraint = self.constraint(sizeAttribute: .width, size: width, relatedBy: relatedBy, priority: priority)
        }
        if self.widthSizeConstraint?.constant != width {
            self.widthSizeConstraint?.constant = width
        }
        return self.widthSizeConstraint!
    }

    /**
     Constrain the height of the view.

     - Parameter height: The height to constrain the view to.

     - Returns: The constraint object.
     */
    @discardableResult
    @objc func size(toHeight height: CGFloat, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        if self.heightSizeConstraint == nil {
            self.heightSizeConstraint = self.constraint(sizeAttribute: .height, size: height, relatedBy: relatedBy, priority: priority)
        }
        if self.heightSizeConstraint?.constant != height {
            self.heightSizeConstraint?.constant = height
        }
        return self.heightSizeConstraint!
    }
}

// MARK: - Pin: Superview
@objc public extension UIView {

    /**
     Add subview with necessary constraints programmatically

     - Parameters:
     - subview: subview to add
     */
    func addView(subview: UIView) {
        self.addSubview(subview)
        subview.pinToEdgesOfSuperview(edge: .zero, priority: .required)
    }

    /**
     Add subview with necessary constraints programmatically

     - Parameters:
     - subview: subview to add
     - edge: edge insets on super view
     */
    func addView(subview: UIView, edge: UIEdgeInsets = .zero) {
        self.addSubview(subview)
        subview.pinToEdgesOfSuperview(edge: edge, priority: .required)
    }

    func insertView(_ subview: UIView, belowSubView: UIView, edge: UIEdgeInsets = .zero) {
        self.insertSubview(subview, belowSubview: belowSubView)
        subview.pinToEdgesOfSuperview(edge: edge, priority: .required)
    }
    /**
     Pin a view to all four edges of it's super view.
     */
    func pinToEdgesOfSuperview() {
        self.pinToEdgesOfSuperview(withOffset: 0)
    }

    /**
     Pin a view to all four edges of it's super view, with an inset(inset from the edges).

     - Parameter withInset: How far to inset(inset) the edges of the view from the superview's edges.
     - Parameter priority: The priority of the constraints.

     */

    func pinToEdgesOfSuperview(withInset inset: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) {
        self.pinToTopEdgeOfSuperview(withOffset: inset.top, priority: priority)
        self.pinToTrailingEdgeOfSuperview(withOffset: inset.right, priority: priority)
        self.pinToBottomEdgeOfSuperview(withOffset: inset.bottom, priority: priority)
        self.pinToLeadingEdgeOfSuperview(withOffset: inset.left, priority: priority)
    }

    /**
     Pin a view to all four edges of it's super view, with an edge insets.

     - Parameter edge: How far to inset the edges of the view from the superview's edges.
     - Parameter priority: The priority of the constraints.

     */
    func pinToEdgesOfSuperview(edge: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) {
        self.pinToTopEdgeOfSuperview(withOffset: edge.top, priority: priority)
        self.pinToTrailingEdgeOfSuperview(withOffset: edge.right, priority: priority)
        self.pinToBottomEdgeOfSuperview(withOffset: edge.bottom, priority: priority)
        self.pinToLeadingEdgeOfSuperview(withOffset: edge.left, priority: priority)
    }

    /**
     Pin a view to all four edges of it's super view, with an offset(inset from the edges).

     - Parameter withOffset: How far to offset(inset) the edges of the view from the superview's edges.
     - Parameter priority: The priority of the constraints.

     */
    func pinToEdgesOfSuperview(withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) {
        self.pinToEdgesOfSuperview(withInset: UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset), priority: priority)
    }

    /**
     Pin a view to all four edges of it's super view, with an offset(inset from the edges).

     - Parameter withVerticalOffset: How far to vertical(inset) the edges of the view from the superview's edges.
     - Parameter horizonatalOffset: How far to horizontal(inset) the edges of the view from the superview's edges.
     - Parameter priority: The priority of the constraints.

     */
    func pinToEdgesOfSuperview(withVerticalOffset verticalOffset: CGFloat = 0, horizonatalOffset: CGFloat = 0, priority: UILayoutPriority = .required) {
        self.pinToEdgesOfSuperview(withInset: UIEdgeInsets(top: verticalOffset, left: horizonatalOffset, bottom: verticalOffset, right: horizonatalOffset), priority: priority)
    }

    /**
     Pin the top edge of the view to the top edge of it's superview.

     - Parameter withOffset: How far to offset the top edge of the view from the top edge of its superview.
     - Parameter priority: The priority of the constraint.

     - Returns: The constraint object or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    func pinToTopEdgeOfSuperview(withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
        return self.constraint(edgeAttribute: .top, offset: offset, priority: priority, relatedBy: relatedBy)
    }

    /**
     Pin the leading and trailing edges of the view to the leading and trailing edges of it's superview.

     - Parameter withOffset: How far to offset the top edge of the view from the top edge of its superview.
     - Parameter priority: The priority of the constraint.
     */
    func pinToLeadingAndTrailingEdgesOfSuperview(withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) {
        self.pinToLeadingEdgeOfSuperview(withOffset: offset, priority: priority)
        self.pinToTrailingEdgeOfSuperview(withOffset: offset, priority: priority)
    }

    /**
     Pin the right edge of the view to the right edge of it's superview.

     - Parameter withOffset: How far to offset the right edge of the view from the right edge of its superview.
     - Parameter priority: The priority of the constraint.
     - Parameter relatedBy: The relation of the constraint.

     - Returns: The constraint object or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    func pinToTrailingEdgeOfSuperview(withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
        self.trailingConstraint = self.constraint(edgeAttribute: .trailing, offset: -offset, priority: priority, relatedBy: relatedBy)
        return self.trailingConstraint
    }

    /**
     Pin the bottom edge of the view to the bottom edge of it's superview.

     - Parameter withOffset: How far to offset the bottom edge of the view from the bottom edge of its superview.
     - Parameter priority: The priority of the constraint.
     - Parameter relatedBy: The relation of the constraint.

     - Returns: The constraint object or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    func pinToBottomEdgeOfSuperview(withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
        return self.constraint(edgeAttribute: .bottom, offset: -offset, priority: priority, relatedBy: relatedBy)
    }

    /**
     Pin the left edge of the view to the left edge of it's superview.

     - Parameter withOffset: How far to offset the left edge of the view from the bottom edge of its superview.
     - Parameter priority: The priority of the constraint.
     - Parameter relatedBy: The relation of the constraint.

     - Returns: The constraint object or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    func pinToLeadingEdgeOfSuperview(withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
        self.leadingConstraint = self.constraint(edgeAttribute: .leading, offset: offset, priority: priority, relatedBy: relatedBy)
        return self.leadingConstraint
    }

}

// MARK: - Pin: to Item
@objc public extension UIView {

    /**
     Pin a view to all four edges of given layout item, with an inset(inset from the edges).

     - Parameter item: Constraint all four edges of the view to this item, it may be a view or layout guide.
     - Parameter withInset: How far to inset(inset) the edges of the view from the layout item's edges.
     - Parameter priority: The priority of the constraints.

     */

    @objc func pinToEdges(of item: LayoutItem, withInset inset: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) {
        self.pinToTopEdge(of: item, withOffset: inset.top, priority: priority)
        self.pinToTrailingEdge(of: item, withOffset: inset.right, priority: priority)
        self.pinToBottomEdge(of: item, withOffset: inset.bottom, priority: priority)
        self.pinToLeadingEdge(of: item, withOffset: inset.left, priority: priority)
    }

    /**
     Pin a view to all four edges of given layout item, with an offset(inset from the edges).

     - Parameter item: Constraint all four edges of the view to this item, it may be a view or layout guide.
     - Parameter withOffset: How far to offset(inset) the edges of the view from the layout item's edges.
     - Parameter priority: The priority of the constraints.

     */
    @objc func pinToEdges(of item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) {
        self.pinToEdges(of: item, withInset: UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset), priority: priority)
    }

    /**
     Pin a view to all four edges of given item.

     - Parameter item: Constraint all four edges of the view to this item, it may be a view or layout guide.

     */
    @objc func pinToEdges(of item: LayoutItem) {
        self.pinToEdges(of: item, withOffset: 0)
    }

    /**
     Pin a view to all four edges of given layout item, with an offset(inset from the edges).

     - Parameter item: Constraint all four edges of the view to this item, it may be a view or layout guide.
     - Parameter withVerticalOffset: How far to vertical(inset) the edges of the view from the superview's edges.
     - Parameter horizonatalOffset: How far to horizontal(inset) the edges of the view from the superview's edges.
     - Parameter priority: The priority of the constraints.

     */
    @objc func pinToEdges(of item: LayoutItem, withVerticalOffset verticalOffset: CGFloat = 0, horizonatalOffset: CGFloat = 0, priority: UILayoutPriority = .required) {
        self.pinToEdges(of: item, withInset: UIEdgeInsets(top: verticalOffset, left: horizonatalOffset, bottom: verticalOffset, right: horizonatalOffset), priority: priority)
    }

    /**
     Pin the top edge of the view to the top edge of given layout item.

     - Parameter item: Constraint top edge of the view to this item, it may be a view or layout guide.
     - Parameter withOffset: How far to offset the top edge of the view from the top edge of its superview.
     - Parameter priority: The priority of the constraint.

     - Returns: The constraint object or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    @objc func pinToTopEdge(of item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        return self.constraint(attribute: .top, toAttribute: .top, ofItem: item, offset: offset, priority: priority)
    }

    /**
     Pin the right edge of the view to the right edge of given layout item.

     - Parameter item: Constraint trailing edge of the view to this item, it may be a view or layout guide.
     - Parameter withOffset: How far to offset the right edge of the view from the right edge of its superview.
     - Parameter priority: The priority of the constraint.

     - Returns: The constraint object or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    @objc func pinToTrailingEdge(of item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        self.trailingConstraint = self.constraint(attribute: .trailing, toAttribute: .trailing, ofItem: item, offset: offset, priority: priority)
        return self.trailingConstraint
    }

    /**
     Pin the bottom edge of the view to the bottom edge of given layout item.

     - Parameter item: Constraint bottom edge of the view to this item, it may be a view or layout guide.
     - Parameter withOffset: How far to offset the bottom edge of the view from the bottom edge of its superview.
     - Parameter priority: The priority of the constraint.

     - Returns: The constraint object or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    @objc func pinToBottomEdge(of item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        return self.constraint(attribute: .bottom, toAttribute: .bottom, ofItem: item, offset: offset, priority: priority)
    }

    /**
     Pin the left edge of the view to the left edge of given layout item.

     - Parameter item: Constraint leading edge of the view to this item, it may be a view or layout guide.
     - Parameter withOffset: How far to offset the left edge of the view from the bottom edge of its superview.
     - Parameter priority: The priority of the constraint.

     - Returns: The constraint object or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    @objc func pinToLeadingEdge(of item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        self.leadingConstraint = self.constraint(attribute: .leading, toAttribute: .leading, ofItem: item, offset: offset, priority: priority)
        return self.leadingConstraint
    }

}

// MARK: - Center
public extension UIView {

    /**
     Center the view horizontally and vertically within it's superview.
     - Parameter withOffset: How far to horizontal and vertical offset the center of the view from the superview's center.
     - Parameter priority: The priority of the constraints.
     
     - Returns: The `horizontal` and `vertical` constraint objects or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    func centerInSuperview(withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) -> (horizontal: NSLayoutConstraint?, vertical: NSLayoutConstraint?) {
        return (
            self.centerHorizontallyInSuperview(withOffset: offset, priority: priority),
            self.centerVerticallyInSuperview(withOffset: offset, priority: priority)
        )
    }

    /**
     Center the view horizontally within it's super view.
     - Parameter withOffset: How far to horizontally offset the center of the view from the superview's center.
     - Parameter priority: The priority of the constraint.
     
     - Returns: The constraint object or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    @objc func centerHorizontallyInSuperview(withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        return self.constraint(edgeAttribute: .centerX, offset: offset, priority: priority)
    }

    /**
     Center the view vertical within it's super view.
     - Parameter withOffset: How far to vertical offset the center of the view from the superview's center.
     - Parameter priority: The priority of the constraint.
     
     - Returns: The constraint object or `nil` if the constraint could not be made because the view does not have a super view.
     */
    @discardableResult
    @objc func centerVerticallyInSuperview(withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        return self.constraint(edgeAttribute: .centerY, offset: offset, priority: priority)
    }

    /**
     Center the view horizontally to an item.
     - Parameter item: Constraint the horizontal axis of the view to this item, it may be a view or layout guide.
     - Parameter withOffset: How far to horizontally offset the center of the view from the item's center.
     - Parameter priority: The priority of the constraint.
     - Returns: The constraint object or `nil` if the constraint could not be made because the views do not share a common super view.
     */
    @discardableResult
    @objc func centerHorizontally(to item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        return self.constraint(attribute: .centerX, toAttribute: .centerX, ofItem: item, offset: offset, priority: priority)
    }

    /**
     Center the view vertically to an item.
     - Parameter item: Constraint the vertical axis of the view to this item, it may be a view or layout guide.
     - Parameter withOffset: How far to vertically offset the center of the view from the item's center.
     - Parameter priority: The priority of the constraint.
     - Returns: The constraint object or `nil` if the constraint could not be made because the views do not share a common super view.
     */
    @discardableResult
    @objc func centerVertically(to item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        return self.constraint(attribute: .centerY, toAttribute: .centerY, ofItem: item, offset: offset, priority: priority)
    }

}

// MARK: - Position
@objc public extension UIView {

    /**
     Position the view above an item.
     - Parameter item: Position the view above this item, it may be a view or layout guide.
     - Parameter withOffset: How far to offset(seperate) the bottom of the view from the top of the item.
     - Parameter priority: The priority of the constraint.
     - Returns: The constraint object or `nil` if the constraint could not be made because the views do not share a common super view.
     */
    @discardableResult
    @objc func positionAbove(_ item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
        return self.constraint(attribute: .bottom, toAttribute: .top, ofItem: item, relatedBy: relation, offset: -offset, priority: priority)
    }

    /**
     Position the view to the right of an item.
     - Parameter item: Position the view to the right of this item, it may be a view or layout guide.
     - Parameter withOffset: How far to offset(seperate) the left of the view from the right of the item.
     - Parameter priority: The priority of the constraint.
     - Returns: The constraint object or `nil` if the constraint could not be made because the views do not share a common super view.
     */
    @discardableResult
    @objc func positionToTheTrailing(of item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
        self.leadingConstraint = self.constraint(attribute: .leading, toAttribute: .trailing, ofItem: item, relatedBy: relation, offset: offset, priority: priority)
        return self.leadingConstraint
    }

    /**
     Position the view below an item.
     - Parameter item: Position the view below this item, it may be a view or layout guide.
     - Parameter withOffset: How far to offset(seperate) the top of the view from the bottom of the item.
     - Parameter priority: The priority of the constraint.
     - Returns: The constraint object or `nil` if the constraint could not be made because the views do not share a common super view.
     */
    @discardableResult
    @objc func positionBelow(_ item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
        return self.constraint(attribute: .top, toAttribute: .bottom, ofItem: item, relatedBy: relation, offset: offset, priority: priority)
    }

    /**
     Position the view to the left of an item.
     - Parameter item: Position the view to the left of this item, it may be a view or layout guide.
     - Parameter withOffset: How far to offset(seperate) the right of the view from the left of the item.
     - Parameter priority: The priority of the constraint.
     - Returns: The constraint object or `nil` if the constraint could not be made because the views do not share a common super view.
     */
    @discardableResult
    @objc func positionToTheLeading(of item: LayoutItem, withOffset offset: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
        self.trailingConstraint = self.constraint(attribute: .trailing, toAttribute: .leading, ofItem: item, relatedBy: relation, offset: -offset, priority: priority)
        return self.trailingConstraint
    }

}

// MARK: - General
@objc public extension UIView {
    @discardableResult
    @objc fileprivate func constraint(item: LayoutItem, attribute itemAttribute: NSLayoutConstraint.Attribute, toItem: LayoutItem? = nil, attribute toAttribute: NSLayoutConstraint.Attribute = .notAnAttribute, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = setConstraint(item: item, attribute: itemAttribute, toItem: toItem, attribute: toAttribute, relatedBy: relatedBy, multiplier: multiplier, offset: offset, priority: priority)
        self.addConstraint(constraint)
        return constraint
    }
}

// MARK: - Private
@objc public extension UIView {

    @discardableResult
    fileprivate func constraint(sizeAttribute: NSLayoutConstraint.Attribute, size: CGFloat = 0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return self.constraint(item: self, attribute: sizeAttribute, relatedBy: relatedBy, multiplier: 0, offset: size, priority: priority)
    }

    fileprivate func constraint(edgeAttribute: NSLayoutConstraint.Attribute, offset: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
        assert(self.superview != nil, "Can't create constraints without a super view")
        guard let superview = self.superview else {
            return nil
        }

        return superview.constraint(item: self, attribute: edgeAttribute, toItem: superview, attribute: edgeAttribute, relatedBy: relatedBy, offset: offset, priority: priority)
    }

    func constraint(attribute: NSLayoutConstraint.Attribute, toAttribute itemAttribute: NSLayoutConstraint.Attribute, ofItem item: LayoutItem, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        let commonSuperview: UIView? = {
            guard let view = item as? UIView else {
                return self.superview
            }

            return {
                var startView: UIView! = self
                var commonSuperview: UIView?
                repeat {
                    if view.isDescendant(of: startView) {
                        commonSuperview = startView
                    }
                    startView = startView.superview
                } while (startView != nil && commonSuperview == nil)
                return commonSuperview
                }()
        }()

        assert(commonSuperview != nil, "Can't create constraints without a common super view")
        if commonSuperview == nil {
            return nil
        }

        return commonSuperview!.constraint(item: self, attribute: attribute, toItem: item, attribute: itemAttribute, relatedBy: relatedBy, multiplier: multiplier, offset: offset, priority: priority)
    }

}


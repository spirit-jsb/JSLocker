//
//  JSLockerController.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

open class JSLockerController: UIViewController {
    
    private struct Constants {
        static let resizingThreshold: CGFloat = 30.0
    }
    
    private enum PresentationStyle {
        case slideover
        case popover
    }
    
    // MARK:
    open var onDismiss: (() -> Void)?
    open var onDismissCompleted: (() -> Void)?
    
    open var resizingBehavior: JSLockerResizingBehavior = .none
    open var permittedArrowDirection: UIPopoverArrowDirection = .any
    
    open var contentController: UIViewController? {
        didSet {
            if self.contentController == oldValue {
                return
            }
            if self._contentView != nil {
                fatalError("JSLockerController: contentController cannot be set while contentView is assigned")
            }
            if let oldContentController = oldValue {
                self.removeChildController(oldContentController)
            }
            if let contentController = self.contentController {
                self.addChildController(contentController)
            }
        }
    }
    open var isExpanded: Bool = false {
        didSet {
            if self.isExpanded == oldValue {
                return
            }
            self.isExpandedBeingChanged = true
            if self.isExpanded {
                self.normalPreferredContentHeight = self.preferredContentSize.height
                self.preferredContentSize.height = UIScreen.main.bounds.height
            }
            else {
                self.preferredContentSize.height = self.normalPreferredContentHeight
            }
            self.isExpandedBeingChanged = false
        }
    }
    
    open var contentView: UIView? {
        set {
            if self.contentView == newValue {
                return
            }
            if self.contentController != nil {
                fatalError("JSLockerController: contentView cannot be set while contentController is assigned")
            }
            self._contentView?.removeFromSuperview()
            self._contentView = newValue
            if let contentView = self._contentView {
                self.view.addSubview(contentView)
            }
        }
        get {
            return self.contentController?.view ?? self._contentView
        }
    }
    
    public weak var delegate: JSLockerControllerDelegate?
    
    var preferredContentWidth: CGFloat {
        return 0.0
    }
    var preferredContentHeight: CGFloat {
        return 0.0
    }
    
    private let sourceView: UIView?
    private let sourceRect: CGRect?
    private let barButtonItem: UIBarButtonItem?
    private let origin: CGFloat?
    private let direction: JSLockerPresentationDirection
    
    private var _contentView: UIView?
    
    private var isExpandedBeingChanged: Bool = false
    private var normalPreferredContentHeight: CGFloat = -1.0
    
    private var resizingHandleView: JSResizingHandleView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let newValue = self.resizingHandleView {
                self.view.addSubview(newValue)
            }
        }
    }
    private var resizingGestureRecognizer: UIPanGestureRecognizer? {
        didSet {
            if let oldRecognizer = oldValue {
                self.view.removeGestureRecognizer(oldRecognizer)
            }
            if let newRecognizer = self.resizingGestureRecognizer {
                self.view.addGestureRecognizer(newRecognizer)
            }
        }
    }
    
    private var canResize: Bool {
        return self.presentationController is JSLockerPresentationController && self.resizingBehavior != .none
    }
    
    // MARK:
    public init(sourceView: UIView, sourceRect: CGRect, origin: CGFloat = -1.0, direction: JSLockerPresentationDirection) {
        self.sourceView = sourceView
        self.sourceRect = sourceRect
        self.barButtonItem = nil
        self.origin = origin == -1.0 ? nil : origin
        self.direction = direction
        
        super.init(nibName: nil, bundle: nil)
        
        self.initialize()
    }
    
    public init(barButtonItem: UIBarButtonItem, origin: CGFloat = -1.0, direction: JSLockerPresentationDirection) {
        self.sourceView = nil
        self.sourceRect = nil
        self.barButtonItem = barButtonItem
        self.origin = origin == -1.0 ? nil : origin
        self.direction = direction
        
        super.init(nibName: nil, bundle: nil)
        
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.isAccessibilityElement = false
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.canResize {
            if self.resizingHandleView == nil {
                self.resizingHandleView = JSResizingHandleView()
            }
            if self.resizingGestureRecognizer == nil {
                self.resizingGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleResizingGesture(_:)))
            }
        }
        else {
            self.resizingHandleView = nil
            self.resizingGestureRecognizer = nil
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            self.onDismiss?()
            self.delegate?.lockerControllerWillDismiss?(self)
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isBeingDismissed {
            self.onDismissCompleted?()
            self.delegate?.lockerControllerDidDismiss?(self)
        }
    }
    
    // MARK:
    open override var preferredContentSize: CGSize {
        set {
            var newValue = newValue
            if self.isExpanded && !self.isExpandedBeingChanged {
                self.normalPreferredContentHeight = newValue.height
                newValue.height = self.preferredContentSize.height
            }
            let hasChanges = self.preferredContentSize != newValue
            super.preferredContentSize = newValue
            if hasChanges && self.presentingViewController != nil {
                (self.presentationController as? JSLockerPresentationController)?.updateContentViewFrame(animated: true)
            }
        }
        get {
            var preferredContentSize = super.preferredContentSize
            let updatePreferredContentSize = { (getWidth: @autoclosure () -> CGFloat, getHeight: @autoclosure () -> CGFloat) in
                if preferredContentSize.width == 0.0 {
                    preferredContentSize.width = getWidth()
                }
                if preferredContentSize.height == 0.0 {
                    preferredContentSize.height = getHeight()
                    if preferredContentSize.height != 0.0 && self.canResize {
                        preferredContentSize.height += JSResizingHandleView.height
                    }
                }
            }
            updatePreferredContentSize(self.preferredContentWidth, self.preferredContentHeight)
            if let contentController = self.contentController {
                let contentSize = contentController.preferredContentSize
                updatePreferredContentSize(contentSize.width, contentSize.height)
            }
            return preferredContentSize
        }
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if !self.isBeingPresented && self.presentationController is JSLockerPresentationController {
            self.presentingViewController?.dismiss(animated: false)
        }
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var frame = self.view.bounds
        if let resizingHandleView = self.resizingHandleView {
            let frames = frame.divided(
                atDistance: resizingHandleView.height,
                from: self.direction == .down ? .maxYEdge : .minYEdge
            )
            resizingHandleView.frame = frames.slice
            frame = frames.remainder
        }
        self.contentView?.frame = frame
    }
    
    open override func accessibilityPerformEscape() -> Bool {
        self.presentingViewController?.dismiss(animated: true)
        return true
    }
    
    // MARK:
    private func presentationStyle(for sourceViewController: UIViewController) -> PresentationStyle {
        guard let window = sourceViewController.view.window else {
            return UIDevice.current.userInterfaceIdiom == .phone ? .slideover : .popover
        }
        return window.traitCollection.horizontalSizeClass == .compact ? .slideover : .popover
    }
    
    private func initialize() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    // MARK:
    @objc private func handleResizingGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let presentationController = self.presentationController as? JSLockerPresentationController else {
            fatalError("JSLockerController cannot handle resizing without JSLockerPresentationController")
        }
        let translation = recognizer.translation(in: nil)
        var offset = self.direction == .down ? translation.y : -translation.y
        if self.resizingBehavior == .dismiss {
            offset = min(offset, 0.0)
        }
        switch recognizer.state {
        case .began:
            presentationController.extraContentHeightEffectWhenCollapsing = self.isExpanded ? .resize : .move
        case .changed:
            presentationController.setExtraContentHeight(offset)
        case .ended:
            if offset >= Constants.resizingThreshold {
                if self.isExpanded {
                    presentationController.setExtraContentHeight(0.0, animated: true)
                }
                else {
                    presentationController.setExtraContentHeight(0.0, updatingLayout: false)
                    self.isExpanded = true
                    self.delegate?.lockerControllerDidChangeExpandedState?(self)
                }
            }
            else if offset <= -Constants.resizingThreshold {
                if self.isExpanded {
                    presentationController.setExtraContentHeight(0.0, updatingLayout: false)
                    self.isExpanded = false
                    self.delegate?.lockerControllerDidChangeExpandedState?(self)
                }
                else {
                    self.presentingViewController?.dismiss(animated: true)
                }
            }
            else {
                presentationController.setExtraContentHeight(0.0, animated: true)
            }
        case .cancelled:
            presentationController.setExtraContentHeight(0.0, animated: true)
        default:
            break
        }
    }
}

extension JSLockerController: UIViewControllerTransitioningDelegate {
    
    // MARK: UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self.presentationStyle(for: source) == .slideover {
            return JSLockerTransitionAnimator(presenting: true, direction: self.direction)
        }
        return nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.presentationController is JSLockerPresentationController {
            return JSLockerTransitionAnimator(presenting: false, direction: self.direction)
        }
        return nil
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch self.presentationStyle(for: source) {
        case .slideover:
            return JSLockerPresentationController(presentedViewController: presented, presenting: presenting, sourceViewController: source, sourceObject: self.sourceView ?? self.barButtonItem, origin: self.origin, direction: self.direction, isInteractive: self.resizingBehavior != .none)
        case .popover:
            let presentationController = UIPopoverPresentationController(presentedViewController: presented, presenting: presenting)
            presentationController.backgroundColor = UIColor.white
            presentationController.permittedArrowDirections = self.permittedArrowDirection
            presentationController.delegate = self
            if let sourceView = self.sourceView {
                presentationController.sourceView = sourceView
                if let sourceRect = self.sourceRect {
                    presentationController.sourceRect = sourceRect
                }
            }
            else if let barButtonItem = self.barButtonItem {
                presentationController.barButtonItem = barButtonItem
            }
            else {
                fatalError("A UIPopoverPresentationController should have a non-nil sourceView or barButtonItem set before the presentation occurs")
            }
            return presentationController
        }
    }
}

extension JSLockerController: UIPopoverPresentationControllerDelegate {
 
    // MARK: UIPopoverPresentationControllerDelegate
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

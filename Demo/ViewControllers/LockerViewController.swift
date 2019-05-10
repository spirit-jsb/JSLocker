//
//  LockerViewController.swift
//  JSLocker
//
//  Created by Max on 2019/5/10.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class LockerViewController: DemoViewController {

    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(barButtonTapped(_:)))
        
        self.container.addArrangedSubview(self.createButton(title: "Show top locker (resizable)", action: #selector(showTopLockerButtonTapped(_:))))
        self.container.addArrangedSubview(self.createButton(title: "Show top locker (no animation)", action: #selector(showTopLockerNotAnimatedButtonTapped(_:))))
        self.container.addArrangedSubview(self.createButton(title: "Show top locker (custom base)", action: #selector(showTopLockerCustomOffsetButtonTapped(_:))))
        
        self.container.addArrangedSubview(self.createButton(title: "Show bottom locker (resizable)", action: #selector(showBottomLockerButtonTapped(_:))))
        self.container.addArrangedSubview(self.createButton(title: "Show bottom locker (no animation)", action: #selector(showBottomLockerNotAnimatedButtonTapped(_:))))
        self.container.addArrangedSubview(self.createButton(title: "Show bottom locker (custom base)", action: #selector(showBottomLockerCustomOffsetButtonTapped(_:))))
        
        self.container.addArrangedSubview(self.createButton(title: "Show locker (resizable, custom content)", action: #selector(showBottomLockerCustomContentControllerButtonTapped(_:))))
        
        self.container.addArrangedSubview(UIView())
    }
    
    // MAKR:
    private func presentLocker(sourceView: UIView? = nil,
                               barButtonItem: UIBarButtonItem? = nil,
                               origin: CGFloat = -1.0,
                               direction: JSLockerPresentationDirection,
                               contentController: UIViewController? = nil,
                               contentView: UIView? = nil,
                               resizingBehavior: JSLockerResizingBehavior = .none,
                               animaed: Bool = true)
    {
        let controller: JSLockerController
        if let sourceView = sourceView {
            controller = JSLockerController(sourceView: sourceView, sourceRect: sourceView.bounds, origin: origin, direction: direction)
        }
        else if let barButtonItem = barButtonItem {
            controller = JSLockerController(barButtonItem: barButtonItem, origin: origin, direction: direction)
        }
        else {
            fatalError("Presenting a locker requires either a sourceView or a barButtonItem")
        }
        controller.resizingBehavior = resizingBehavior
        if let contentView = contentView {
            controller.preferredContentSize.height = 220.0
            controller.contentView = contentView
        }
        else {
            controller.contentController = contentController
        }
        self.present(controller, animated: animaed)
    }
    
    private func actionViews() -> [UIView] {
        let spacer = UIView()
        spacer.backgroundColor = UIColor.orange
        spacer.layer.borderWidth = 1.0
        return [
            self.createButton(title: "Expand", action: #selector(expandButtonTapped(_:))),
            self.createButton(title: "Dismiss", action: #selector(dismissButtonTapped)),
            self.createButton(title: "Dismiss (no animation)", action: #selector(dismissNotAnimatedButtonTapped)),
            spacer
        ]
    }
    
    private func containerForActionViews() -> UIView {
        let container = LockerViewController.createVerticalContainer()
        for view in self.actionViews() {
            container.addArrangedSubview(view)
        }
        return container
    }
    
    // MARK:
    @objc private func barButtonTapped(_ sender: UIBarButtonItem) {
        self.presentLocker(barButtonItem: sender, direction: .down, contentView: self.containerForActionViews())
    }
    
    @objc private func showTopLockerButtonTapped(_ sender: UIButton) {
        self.presentLocker(sourceView: sender, direction: .down, contentView: self.containerForActionViews(), resizingBehavior: .dismissOrExpand)
    }
    
    @objc private func showTopLockerNotAnimatedButtonTapped(_ sender: UIButton) {
        self.presentLocker(sourceView: sender, direction: .down, contentView: self.containerForActionViews(), animaed: false)
    }
    
    @objc private func showTopLockerCustomOffsetButtonTapped(_ sender: UIButton) {
        let rect = sender.superview!.convert(sender.frame, to: nil)
        self.presentLocker(sourceView: sender, origin: rect.maxY, direction: .down, contentView: self.containerForActionViews())
    }
    
    @objc private func showBottomLockerButtonTapped(_ sender: UIButton) {
        self.presentLocker(sourceView: sender, direction: .up, contentView: self.containerForActionViews(), resizingBehavior: .dismissOrExpand)
    }
    
    @objc private func showBottomLockerNotAnimatedButtonTapped(_ sender: UIButton) {
        self.presentLocker(sourceView: sender, direction: .up, contentView: self.containerForActionViews(), animaed: false)
    }
    
    @objc private func showBottomLockerCustomOffsetButtonTapped(_ sender: UIButton) {
        let rect = sender.superview!.convert(sender.frame, to: nil)
        self.presentLocker(sourceView: sender, origin: rect.minY, direction: .up, contentView: self.containerForActionViews())
    }
    
    @objc private func showBottomLockerCustomContentControllerButtonTapped(_ sender: UIButton) {
        let controller = UIViewController()
        controller.title = "Resizable Locker"
        controller.preferredContentSize = CGSize(width: 350.0, height: 400.0)
        
        let contentController = UINavigationController(rootViewController: controller)
        contentController.navigationBar.isTranslucent = false
        
        self.presentLocker(sourceView: sender, direction: .up, contentController: contentController, resizingBehavior: .dismissOrExpand)
    }
    
    @objc private func expandButtonTapped(_ sender: UIButton) {
        guard let locker = self.presentedViewController as? JSLockerController else {
            return
        }
        locker.isExpanded = !locker.isExpanded
        sender.setTitle(locker.isExpanded ? "Return to normal" : "Expand", for: .normal)
    }
    
    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func dismissNotAnimatedButtonTapped() {
        self.dismiss(animated: false)
    }
}
/**
class MSDrawerDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(barButtonTapped))
        
 
    }
 

}

*/

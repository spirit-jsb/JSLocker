//
//  DemoViewController.swift
//  JSLocker
//
//  Created by Max on 2019/5/10.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import JSLocker

class DemoViewController: UIViewController {
    
    // MARK:
    let container: UIStackView = DemoViewController.createVerticalContainer()
    let scrollingContainer = UIScrollView(frame: .zero)

    // MAKR:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.scrollingContainer)
        self.scrollingContainer.fitIntoSuperview()
        self.scrollingContainer.addSubview(self.container)
        self.container.fitIntoSuperview(usingConstraints: true, usingLeadingTrailing: false, autoHeight: true)
    }
    
    // MARK:
    class func createVerticalContainer() -> UIStackView {
        let container = UIStackView(frame: .zero)
        container.axis = .vertical
        container.layoutMargins = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        container.isLayoutMarginsRelativeArrangement = true
        container.spacing = 16.0
        return container
    }
    
    func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: [])
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func addTitle(text: String) {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textAlignment = .center
        self.container.addArrangedSubview(titleLabel)
    }
}

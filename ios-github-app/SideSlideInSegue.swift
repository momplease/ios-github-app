//
//  SideSlideInSegue.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/4/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class SideSlideInSegue: UIStoryboardSegue {
    override func perform() {
        if source.childViewControllers.count > 0 {
            hideContentController(content: source.childViewControllers[0])
        }
        displayContentController(content: destination, parent: source)
    }
    
    func displayContentController(content: UIViewController, parent: UIViewController) {
        parent.addChildViewController(content)
        content.view.frame = parent.view.frame
        parent.view.addSubview(content.view)
        content.didMove(toParentViewController: parent)
    }
 
    func hideContentController(content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
}

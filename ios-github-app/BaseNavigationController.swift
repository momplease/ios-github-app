//
//  BaseNavigationController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 9/7/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit
import CoreGraphics

class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    public var sideGestureRecognizer: SideGestureProcessor?
    public var baseVC: BaseViewController?
    
    public var isOpened: Bool = false
    public var shouldAnimate: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        baseVC = viewControllers[0] as? BaseViewController
        
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: -5, height: 5);
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        
        view.isUserInteractionEnabled = true
        
        sideGestureRecognizer = SideGestureProcessor(with: self)
        sideGestureRecognizer!.delegate = self
        sideGestureRecognizer!.sideDelegate = baseVC
        view.addGestureRecognizer(sideGestureRecognizer!)
        
        if shouldAnimate {
            playFullSlideInAnimation()
        }
        
        view.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func playFullSlideInAnimation() {
        playSlideInAnimation(from: CGPoint(x: self.view.frame.width * 0.7, y: 0.0))
    }

    public func playFullSlideOutAnimation() {
        playSlideOutAnimation(from: CGPoint(x: 0.0, y: 0.0))
    }
    
    public func playSlideInAnimation(from position: CGPoint) {
        self.view.frame.origin.x = position.x
        UIView.animate(withDuration: 0.35) {
            self.view.frame.origin.x = 0
        }
    }
    
    public func playSlideOutAnimation(from position: CGPoint) {
        self.view.frame.origin.x = position.x
        UIView.animate(withDuration: 0.35) {
            self.view.frame.origin.x = self.view.frame.width * 0.7
        }
    }
    
    public func closeViewAnimatedFully() {
        playFullSlideInAnimation()
        isOpened = false
    }
    
    public func openViewAnimatedFully() {
        playFullSlideOutAnimation()
        isOpened = true
    }
    
    public func closeViewAnimated(from position: CGPoint) {
        playSlideInAnimation(from: position)
        isOpened = false
    }
    
    public func openViewAnimated(from position: CGPoint) {
        playSlideOutAnimation(from: position)
        isOpened = true
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

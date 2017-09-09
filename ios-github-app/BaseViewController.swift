//
//  BaseViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 6/26/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SideGestureProcessorDelegate {
    
    public var baseNC: BaseNavigationController!
    
    public lazy var tableView: UITableView? = {
        return self.view as? UITableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseNC = navigationController! as! BaseNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonDidTap(_ sender: UIBarButtonItem) {
        if !baseNC.isOpened {
            baseNC.playFullSlideOutAnimation()
            baseNC.isOpened = true
        } else {
            baseNC.playFullSlideInAnimation()
            baseNC.isOpened = false
        }
    }
    
    public func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            // nothing
        }))
        alert.show(self, sender: self)
    }   
    
    
    func sideGestureProcessor(_ processor: SideGestureProcessor, didBeganWith touches: Set<UITouch>) {
    }
    
    func sideGestureProcessor(_ processor: SideGestureProcessor, didMoveWith touches: Set<UITouch>) {
    }
    
    func sideGestureProcessor(_ processor: SideGestureProcessor, didEndWith touches: Set<UITouch>) {
    }
    
    
    /*public func animatePosition(to: CGFloat, duration: TimeInterval) {
        if to < 0.1 {
            isSuperViewOpened = false
        } else {
            isSuperViewOpened = true
        }
        
        UIView.animate(withDuration: duration,
                       animations: {
                        self.view.frame.origin.x = to
        })
    }
    
    private func finishTouchesProcessing(duration: TimeInterval, lastTouch: UITouch) {
        let offset = lastTouch.location(in: view.superview).x < (view.frame.width * 0.3) ? 0 : view.frame.width * 0.7
        animatePosition(to: offset, duration: 0.35)
        canProcessTouches = false
    }
    
    public func controllerWillEnterTransition() {
    }
    
    public func controllerWillMoveInTransition() {
    }
    
    public func controllerWillFinishTransition() {
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        controllerWillEnterTransition()
        
        movingTouchPosition = touches.first?.location(in: view.superview!)
        if movingTouchPosition.x < view.frame.width * 0.25 {
            canProcessTouches = true
            initialTouchPosition = movingTouchPosition
        } else if (movingTouchPosition.x > view.superview!.frame.width * 0.75 && isSuperViewOpened) {
            animatePosition(to: 0, duration: 0.35)
        } else {
            canProcessTouches = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canProcessTouches {
            controllerWillMoveInTransition()
            
            let x = (touches.first?.location(in: view.superview).x)!
            movingTouchPosition.x = abs(x - initialTouchPosition.x)
            view.frame.origin.x = movingTouchPosition.x
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canProcessTouches {
            controllerWillFinishTransition()
            finishTouchesProcessing(duration: 0.35, lastTouch: touches.first!)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canProcessTouches {
            finishTouchesProcessing(duration: 0.35, lastTouch: touches.first!)
        }
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

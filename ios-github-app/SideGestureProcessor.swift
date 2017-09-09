//
//  SideGestureProcessor.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 9/7/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
import CoreGraphics

protocol SideGestureProcessorDelegate {
    func sideGestureProcessor(_ processor: SideGestureProcessor, didBeganWith touches: Set<UITouch>)
    func sideGestureProcessor(_ processor: SideGestureProcessor, didMoveWith touches: Set<UITouch>)
    func sideGestureProcessor(_ processor: SideGestureProcessor, didEndWith touches: Set<UITouch>)
}

class SideGestureProcessor: UIGestureRecognizer {
    init(with navigationController: BaseNavigationController) {
        super.init(target: nil, action: nil)
        self.navigationController = navigationController
        maxOffset.x *= navigationController.view.frame.width
        cancelsTouchesInView = false
    }
    
    public var navigationController: BaseNavigationController!
    public var sideDelegate: SideGestureProcessorDelegate?
    
    private var movingTouchPosition = CGPoint(x: 0, y: 0)
    private var initialTouchPosition = CGPoint(x: 0, y: 0)
    private var initialViewPosition = CGPoint(x: 0, y: 0)
    
    private var maxOffset = CGPoint(x: 0.75, y: 0.0)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        initialTouchPosition = location(in: navigationController.view.superview!)
        initialViewPosition = navigationController.view.frame.origin
        state = .began
        sideDelegate?.sideGestureProcessor(self, didBeganWith: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        let x = location(in: navigationController.view.superview!).x
        movingTouchPosition.x = x - initialTouchPosition.x + initialViewPosition.x
        if !(navigationController.view.frame.origin.x + movingTouchPosition.x < 0.0) {
            navigationController.view.frame.origin.x = movingTouchPosition.x
        }
        state = .changed
        sideDelegate?.sideGestureProcessor(self, didMoveWith: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        finish(with: location(in: navigationController.view.superview!))
        state = .ended
        sideDelegate?.sideGestureProcessor(self, didEndWith: touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        finish(with: location(in: navigationController.view.superview!))
        state = .cancelled
    }
    
    private func finish(with position: CGPoint) {
        if navigationController.view.frame.origin.x > maxOffset.x / 2 {
            navigationController.openViewAnimated(from: navigationController.view.frame.origin)
        } else {
            navigationController.closeViewAnimated(from: navigationController.view.frame.origin)
        }
    }
    
}

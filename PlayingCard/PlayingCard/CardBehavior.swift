//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by CS193p Instructor on 10/18/17.
//  Copyright © 2017 CS193p Instructor. All rights reserved.
//
//  Modified by Parannarae
//

import UIKit

// Create own dynamic behavior (combining multiple behaviors
class CardBehavior: UIDynamicBehavior {
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true // collision boundary to bound of this view
        return behavior
    }()
    
    // make card move around more (and do not rotate)
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0   // do not lose momentum
        behavior.resistance = 0 // no friction
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
//        push.angle = (2 * CGFloat.pi).arc4random    // to make all cards move differently
        // push towards center
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x < center.x && y < center.y:
                push.angle = (CGFloat.pi/2).arc4random
            case let (x, y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi-(CGFloat.pi/2).arc4random
            case let (x, y) where x < center.x && y > center.y:
                push.angle = (-CGFloat.pi/2).arc4random
            case let (x, y) where x > center.x && y > center.y:
                push.angle = CGFloat.pi+(CGFloat.pi/2).arc4random
            default:
                push.angle = (CGFloat.pi*2).arc4random
            }
        }
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random // random from 1 ~ 3
        push.action = { [unowned push, weak self] in
            // to clean up the memory (since push is done only once and stay in heap)
            self?.removeChildBehavior(push)  // memory cycle when using self, so needs to be weak to avoid it
        }
        // rather than using animator to remove, instead add as child then remove it
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
        // push is automatically removed when it is used
    }
    
    override init() {
        super.init()
        // add behaviors
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
        // push cannot be added since it is defined as a function (instead addItem function is implemented)
    }
    
    // showing convenience init
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
}

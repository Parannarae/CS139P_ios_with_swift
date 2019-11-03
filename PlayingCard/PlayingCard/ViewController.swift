//
//  ViewController.swift
//  PlayingCard
//
//  Created by CS193p Instructor on 10/9/17.
//  Copyright © 2017 CS193p Instructor. All rights reserved.
//
//  Modified by Parannarae
//

import UIKit

class ViewController: UIViewController {
    
    private var deck = PlayingCardDeck()
    
    @IBOutlet private var cardViews: [PlayingCardView]!
    
    // dynamic animator
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    // combine all behaviors to CardBehavior.swift
    // var with closure
//    lazy var collisionBehavior: UICollisionBehavior = {
//        let behavior = UICollisionBehavior()
//        behavior.translatesReferenceBoundsIntoBoundary = true // collision boundary to bound of this view
//        animator.addBehavior(behavior)
//        return behavior
//    }()
//
//    // make card move around more (and do not rotate)
//    lazy var itemBehavior: UIDynamicItemBehavior = {
//        let behavior = UIDynamicItemBehavior()
//        behavior.allowsRotation = false
//        behavior.elasticity = 1.0   // do not lose momentum
//        behavior.resistance = 0 // no friction
//        animator.addBehavior(behavior)
//        return behavior
//    }()
    lazy var cardBehavior = CardBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            
            // add getsture
            // target: object to send gesture method when the action happens
            // #selector argument: name of a method (but only external method argument names (note that flipCard has no external argument name)
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            // add cardView a collision behavior
//            collisionBehavior.addItem(cardView)
            // add custom behavior
//            itemBehavior.addItem(cardView)
            // let the card move by pushing it
//            let push = UIPushBehavior(items: [cardView], mode: .instantaneous)
//            push.angle = (2 * CGFloat.pi).arc4random    // to make all cards move differently
//            push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random // random from 1 ~ 3
//            push.action = { [unowned push] in
//                push.dynamicAnimator?.removeBehavior(push)  // to clean up the memory (since push is done only once and stay in heap)
//            }
//            animator.addBehavior(push)
            cardBehavior.addItem(cardView)
        }
    }
    
    // make it like a concentration game (matching cards)
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2
            && faceUpCardViews[0].rank == faceUpCardViews[1].rank
            && faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        // flip on the card that is tapped
        switch recognizer.state {
        case .ended:
            // recognizer knows where (which view) the tap happends
            if let chosenCardView = recognizer.view as? PlayingCardView {
                // animate flipping
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6,
                    options: [.transitionFlipFromLeft],
                    animations: { chosenCardView.isFaceUp = !chosenCardView.isFaceUp },
                    completion: { finished in
                        // it does not make memory cycle since self does not point to this closure (only Animator has it)
                        if self.faceUpCardViewsMatch {
                            // make cards big and shrink when two cards are matched
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: { self.faceUpCardViews.forEach {
                                        // make 3 times bigger
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                    }
                                },  // only view can be modifed (unless no animation is done)
                                completion: { position in
                                    // shrink and make transparent -> then make the view hidden
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75, // little extra time to resize from 3.0 -> 1.0 -> 0.1
                                        delay: 0,
                                        options: [],
                                        animations: { self.faceUpCardViews.forEach {
                                                // make 3 times bigger
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: { position in
                                            self.faceUpCardViews.forEach {
                                                $0.isHidden = true  // view is hidden now
                                                // just clean up the animation (to default)
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                        }
                                    )
                                }
                            )
                        } else if self.faceUpCardViews.count == 2 {
                            // automatically flipped to back of the card if two are chosen
                            self.faceUpCardViews.forEach { cardView in
                                UIView.transition(
                                    with: cardView,
                                    duration: 0.6,
                                    options: [.transitionFlipFromLeft],
                                    animations: { cardView.isFaceUp = false }
                                )
                            }
                        }
                        
                }
                )
                
            }
        default:
            break
        }
    }
}

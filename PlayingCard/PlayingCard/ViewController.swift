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
            cardBehavior.addItem(cardView)
        }
    }
    
    // make it like a concentration game (matching cards)
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter {
            $0.isFaceUp
            && !$0.isHidden
            // do not add cards to faceUpCardViews if it is in animation
            && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
            && $0.alpha == 1
        }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2
            && faceUpCardViews[0].rank == faceUpCardViews[1].rank
            && faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        // flip on the card that is tapped
        switch recognizer.state {
        case .ended:
            // recognizer knows where (which view) the tap happends
            // second condition is to prevent unpredicted behavior (choosing another cards while in animation)
            //  - property (alpha) is set immediately even if animation takes some time to finish
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2 {
                lastChosenCardView = chosenCardView
                // stop moving when the card is chosen
                cardBehavior.removeItem(chosenCardView)
                // animate flipping
                // change duration of the animation to a big number to check if there is unpredicted behavior
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6,
                    options: [.transitionFlipFromLeft],
                    animations: { chosenCardView.isFaceUp = !chosenCardView.isFaceUp },
                    completion: { finished in
                        // make faceUpCardViews constant while animate (since faceUpCardViews is a dynamic variable)
                        let cardsToAnimate = self.faceUpCardViews
                        // it does not make memory cycle since self does not point to this closure (only Animator has it)
                        if self.faceUpCardViewsMatch {
                            // make cards big and shrink when two cards are matched
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6, // 3.0,
                                delay: 0,
                                options: [],
                                animations: { cardsToAnimate.forEach {
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
                                        animations: { cardsToAnimate.forEach {
                                                // make 3 times bigger
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: { position in
                                            cardsToAnimate.forEach {
                                                $0.isHidden = true  // view is hidden now
                                                // just clean up the animation (to default)
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                        }
                                    )
                                }
                            )
                        } else if cardsToAnimate.count == 2 {
                            // card chosen the first, and the second try to make a transition to both cards, so make sure that the transition only executed on the first chosen card
                            if chosenCardView == self.lastChosenCardView {
                                // automatically flipped to back of the card if two are chosen
                                cardsToAnimate.forEach { cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: 0.6,
                                        options: [.transitionFlipFromLeft],
                                        animations: { cardView.isFaceUp = false },
                                        completion: { finished in
                                            // reset the animation when there is a match
                                            self.cardBehavior.addItem(cardView)
                                        }
                                    )
                                }
                            }
                        } else {
                            if !chosenCardView.isFaceUp {
                                // when no match occurs, so cards are flipped down, make another animation
                                self.cardBehavior.addItem(chosenCardView) // no memory cycle
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

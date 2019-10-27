//
//  ViewController.swift
//  SetGame
//
//  Created by Seokhwan Moon on 20/10/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game: SetGame!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            print(game.playingBoard[cardNumber])
        }
        updateViewFromModel()
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        game.dealThreeCards()
        print(game.playingBoard.count)
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game = SetGame()
        updateViewFromModel()
    }
    
    let cardShapes = ["▲", "●", "■"]
    
    private func shape(for card: Card) -> String {
        switch card.shape {
        case .squiggle:
            return cardShapes[0]
        case .oval:
            return cardShapes[1]
        case .diamond:
            return cardShapes[2]
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.isHidden = true
            
            if index < game.playingBoard.count {
                let card = game.playingBoard[index]
                button.isHidden = false
                button.setTitle(shape(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }


}


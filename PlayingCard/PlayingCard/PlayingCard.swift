//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Seokhwan Moon on 13/10/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import Foundation

// To print nice in console, we inherit CustomStringConvertible
struct PlayingCard: CustomStringConvertible
{
    var description: String { return "\(rank), \(suit)" }
    
    var suit: Suit
    var rank: Rank
    
    // set raw value for enum
    // if Int, 0, 1, ... will be set
    // if String, it set to variables' names
    // it just needs to be unique (and contant
    enum Suit: String, CustomStringConvertible {
        var description: String { return "\(self.rawValue)" }
        
        case spades = "♠️"
        case hearts = "♥️"
        case diamonds = "♦️"
        case clubs = "♣️"
        
        static var all = [Suit.spades, .hearts, .diamonds, .clubs]
    }
    
    enum Rank: CustomStringConvertible {
        var description: String { return "\(self.order)" }
        
        case ace
        case face(String)   // for J, Q, K
        case numeric(Int)   // 2 ~ 10
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0   // nil would be better design
            }
        }
        
        static var all: [Rank] {
            // if type is speicfied, we can just use shorthad .ace than Rank.ace
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            // if first element type is specified, others can be automatically infered
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            
            return allRanks
        }
    }
}

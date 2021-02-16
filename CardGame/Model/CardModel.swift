//
//  CardModel.swift
//  CardGame
//
//  Created by Maria Kramer on 11.02.2021.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {

        var generatedNumbers = [Int]()

        var generatedCards = [Card]()

        // Randomly generate 8 pairs of cards
        while generatedNumbers.count < 8 {

            // Generate a random number
            let randomNumber = Int.random(in: 1...13)

            if generatedNumbers.contains(randomNumber) == false {

                // Create two new card objects
                let cardOne = Card()
                let cardTwo = Card()

                // Set their image names
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"

                // Add them to the array
                generatedCards += [cardOne, cardTwo]

                generatedNumbers.append(randomNumber)
                print(randomNumber)
            }
        }
        
        // Randomize the cards within the array
        generatedCards.shuffle()

        return generatedCards
    }
}

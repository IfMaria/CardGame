//
//  ViewController.swift
//  CardGame
//
//  Created by Maria Kramer on 11.02.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    var milliseconds:Int = 10 * 1000
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsArray = model.getCards()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundPlayer.playSound(effect: .shuffle)
    }
    
    //    MARK: - Timer Methods
    
    @objc func timerFired() {
        milliseconds -= 1
        
        let seconds: Double = Double(milliseconds) / 1000.0
        
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            checkForGameEnd()
            
        }
    }
    
    //    MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //        Configure the state of the cell based on the properties of the Card that it represents
        let cardCell = cell as? CardCollectionViewCell
        
        let card = cardsArray[indexPath.row]
        
        cardCell?.configureCell(card: card)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        Check if there's any time remaining. Don't let the user interact if the time if the time is 0
        if milliseconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            cell?.flipUp()
            
            soundPlayer.playSound(effect: .flip)
            
            //   Check if this is the first card that was flipped or the second card
            
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
                
            }
            else {
                
                checkForMatch(indexPath)
                
            }
        }
    }
    
    
    //    MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        //     Get the two card objects for the two indices and see if they match
        
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        //     Get the two collection view cells that represents card one and two
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //    Compare the two cards
        
        if cardOne.imageName == cardTwo.imageName {
            
            soundPlayer.playSound(effect: .match)
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //  Was that the last pair?
            
            checkForGameEnd()
        }
        else {
            
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        //    Reset the firstFleppedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd(){
        
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
                hasWon = false
                break
            }
        }
        
        if hasWon == true {
            showAlert(title: "Congratulations!", message: "You've won the game!")
        } else {
            if milliseconds <= 0 {
                showAlert(title: "Time's Up", message: "Sorry, better luck next time!")
            }
        }
        
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style:.default, handler: nil)
        alert.addAction(alertAction)
        
        //  Show the alert
        present(alert, animated: true, completion: nil)
        
    }
}

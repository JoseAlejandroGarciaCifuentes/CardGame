//
//  ViewController.swift
//  CardGame
//
//  Created by Marxtodon on 13/11/2020.
//  Copyright © 2020 Apps2m. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rightNumber: UIButton!
    @IBOutlet weak var leftnumber: UIButton!
    @IBOutlet weak var currentCard: UILabel!
    @IBOutlet weak var currentPoints: UILabel!
    
    let maxValue:Int = 21
    let minValue:Int = 0
    
    let greenCardImg = UIImage(named: "greenCard")
    let redCardImg = UIImage(named: "redCard")
    let freePointsImg = UIImage(named: "freePoints")
    
    var currentPointsValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNewValues()
    }
    
    @IBAction func leftButtonAction(_ sender: Any) {
        
        onCardClick(card: leftnumber)
        
    }
    @IBAction func rightButtonAction(_ sender: UIButton) {
        
        onCardClick(card: rightNumber)
    }
    
    func getRandomNumber() -> Int {
        return Int.random(in: -9..<9)
    }
    
    func setNewValues(){

        let rightNewValue:Int
        let leftNewValue:Int
        
        if let points = UserDefaults.standard.string(forKey: "points") {
            currentPointsValue = Int(points)!
            rightNewValue = Int(loadState(keyName: "rightCard"))!
            leftNewValue = Int(loadState(keyName: "leftCard"))!
            currentCard.text = loadState(keyName: "currentCard")
        }else{
            rightNewValue = getRandomNumber()
            leftNewValue = getRandomNumber()
            setViableStart(rightValue: rightNewValue, leftValue: leftNewValue)
            currentPointsValue = 0
        }
        
        setProperImage(card: rightNumber, newValue: rightNewValue)
        setProperImage(card: leftnumber, newValue: leftNewValue)
        
        setProperTitle(card: rightNumber, value:rightNewValue)
        setProperTitle(card: leftnumber, value:leftNewValue)
        
        generalSave()
        
        currentPoints.text = Int(currentPointsValue).description + " pts."
    }
    
    func updateScore(cardValue: Int)->Int{

        let currentScoreInt: Int = Int (currentCard.text!.description)!
        let result: Int = currentScoreInt + cardValue
        currentCard.text = result.description
        
        return result
    }
    
    func checkState(score:Int) {
        
        if score > maxValue || score < minValue {
            performSegue(withIdentifier: "lostGame", sender: nil)
            removeState(keyName: "points")
            setNewValues()

        }else{
            currentPointsValue += givePoints(percentage: calculatePercentage(score: score),score: score)
            generalSave()
            currentPoints.text = currentPointsValue.description + " pts."
        }
    }
    
    func calculatePercentage(score:Int)->Float{

        return Float(score) * 100 / Float(maxValue)
        
    }
    
    func givePoints(percentage:Float, score:Int)->Int{
        
        let lowestPoints: Int = 120
        let okayPoints: Int = 200
        let nicestPoints: Int = 500
        
        if percentage > 25 && percentage < 75{
            
            return lowestPoints
            
        }else if percentage == 0 || percentage == 100{
            
            return nicestPoints
            
        }else{
            
            return okayPoints
        }
    }
    
    
    func setViableStart(rightValue:Int, leftValue:Int){
        
        if(rightValue > minValue && leftValue > minValue){
            
            let maxPossible = maxValue - max(rightValue, leftValue)
            currentCard.text = Int.random(in: minValue..<maxPossible).description
            
        }else if(rightValue < minValue && leftValue < minValue){
            
            let minPossible = minValue - min(rightValue, leftValue)
            currentCard.text = Int.random(in: minPossible..<maxValue).description
            
        }else{
            currentCard.text = Int.random(in: minValue..<maxValue).description
        }
    }
    
    func saveState(keyName: String, value:String){
        
        UserDefaults.standard.set(value, forKey: keyName)
    }
    
    func generalSave(){
        saveState(keyName: "points", value: currentPointsValue.description)
        saveState(keyName: "rightCard", value: getCardValue(card: rightNumber).description)
        saveState(keyName: "leftCard", value: getCardValue(card: leftnumber).description)
        saveState(keyName: "currentCard", value: currentCard.text!.description)
        
    }
    
    func loadState(keyName:String) -> String{
        return UserDefaults.standard.string(forKey: keyName)!
    }
    
    func removeState(keyName: String) {
        UserDefaults.standard.removeObject(forKey: keyName)
    }
    
    func setProperImage(card: UIButton, newValue:Int){
        
        if newValue > 0{
            card.setBackgroundImage(greenCardImg, for: .normal)
        }else if newValue == 0{
            card.setBackgroundImage(freePointsImg, for: .normal)
        }else{
            card.setBackgroundImage(redCardImg, for: .normal)
        }
    }
    
    func setProperTitle(card: UIButton, value:Int){
        
        if(value != 0){
            card.setTitle(value.description, for: .normal)
        }else{
            card.setTitle("", for: .normal)
        }
        
    }
    
    func getCardValue(card: UIButton) -> Int{
        
        if !card.title(for: .normal)!.description.isEmpty {
            return Int (card.title(for: .normal)!.description)!
        }else{
            return 0
        }
        
    }
    
    func onCardClick(card:UIButton){
        
        let cardValue: Int = getCardValue(card: card)
        
        let score:Int = updateScore(cardValue: cardValue)
        
        let newRandomValue = getRandomNumber()
        
        setProperImage(card: card, newValue: newRandomValue)
        
        setProperTitle(card: card, value:newRandomValue)
        
        checkState(score: score)
        
    }

    
}


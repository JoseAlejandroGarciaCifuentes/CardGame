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
    @IBOutlet weak var currentCard: UIButton!
    @IBOutlet weak var currentPoints: UILabel!
    
    let maxValue:Int = 21
    let minValue:Int = 0
    
    var currentPointsValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightNumber.layer.cornerRadius = 20
        leftnumber.layer.cornerRadius = 20
        currentCard.layer.cornerRadius = 20
        
        repeat{
            setNewValues()
        }while !isPossibleStart()
            
    }
    
    @IBAction func leftButtonAction(_ sender: Any) {
        
        let cardValue: Int = Int (leftnumber.title(for: .normal)!.description)!
        
        let score = updateScore(cardValue: cardValue)
        
        leftnumber.setTitle(getRandomNumber().description, for: .normal)
        
        checkState(score: score)
        
    }
    @IBAction func rightButtonAction(_ sender: UIButton) {
        
        let cardValue: Int = Int (rightNumber.title(for: .normal)!.description)!
        
        let score = updateScore(cardValue: cardValue)
        
        rightNumber.setTitle(getRandomNumber().description, for: .normal)
        
        checkState(score: score)
    }
    
    func getRandomNumber() -> Int {
        return Int.random(in: -9..<9)
    }
    
    func setNewValues(){
        currentCard.setTitle(Int.random(in: 0..<21).description, for: .normal)
        leftnumber.setTitle(getRandomNumber().description, for: .normal)
        rightNumber.setTitle(getRandomNumber().description, for: .normal)
        
        if let points = UserDefaults.standard.string(forKey: "points") {
            currentPointsValue = Int(points)!
        }else{
            currentPointsValue = 0
            saveState()
        }
        currentPoints.text = Int(currentPointsValue).description + " pts."
    }
    
    func updateScore(cardValue: Int)->Int{
        
        let currentScoreInt: Int = Int (currentCard.title(for: .normal)!.description)!
        let result: Int = currentScoreInt + cardValue
        currentCard.setTitle(result.description, for: .normal)
        
        return result
    }
    
    func checkState(score:Int) {
        
        if score > maxValue || score < minValue {
            performSegue(withIdentifier: "lostGame", sender: nil)
            UserDefaults.standard.removeObject(forKey: "points")
            repeat{
                setNewValues()
            }while !isPossibleStart()
        }else{
            currentPointsValue += givePoints(percentage: calculatePercentage(score: score),score: score)
            saveState()
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
    
    func isPossibleStart() -> Bool {
        
        let rightCardValue: Int = Int (rightNumber.title(for: .normal)!.description)!
        let leftCardValue: Int = Int (rightNumber.title(for: .normal)!.description)!
        let myCardValue: Int = Int (rightNumber.title(for: .normal)!.description)!
        
        let range = 0...21
        
        return range.contains(myCardValue + leftCardValue) && range.contains(myCardValue + rightCardValue) ? true : false
    }
    
    func saveState(){
        
        UserDefaults.standard.set(currentPointsValue.description, forKey: "points")
    }
    
}


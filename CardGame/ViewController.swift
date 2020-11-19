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
    
    let maxValue:Float = 21
    let minValue:Float = 0
    
    var currentPointsValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightNumber.layer.cornerRadius = 20
        leftnumber.layer.cornerRadius = 20
        currentCard.layer.cornerRadius = 20
        setNewValues()
        
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
        currentPointsValue = 0
        currentPoints.text = Int(currentPointsValue).description + " pts."
    }
    
    func updateScore(cardValue: Int)->Int{
        
        let currentScoreInt: Int = Int (currentCard.title(for: .normal)!.description)!
        let result: Int = currentScoreInt + cardValue
        currentCard.setTitle(result.description, for: .normal)
        
        return result
    }
    
    func checkState(score:Int) {
        
        if score > 21 || score < 0 {
            performSegue(withIdentifier: "lostGame", sender: nil)
            setNewValues()
        }else{
            currentPointsValue += givePoints(percentage: calculatePercentage(score: score),score: score)
            currentPoints.text = currentPointsValue.description + " pts."
        }
    }
    
    func calculatePercentage(score:Int)->Float{

        return Float(score) * 100 / maxValue
        
    }
    
    func givePoints(percentage:Float, score:Int)->Int{
        
        
        if percentage > 25 && percentage < 75{
            
            return score * 120
            
        }else{
            
            return score * 200
        }
    }
    
    func getOnlyScore(scoreFromLabel:String)->Int{
        
        let score = scoreFromLabel.split(separator: " ")
        return score.startIndex
    }
    
}


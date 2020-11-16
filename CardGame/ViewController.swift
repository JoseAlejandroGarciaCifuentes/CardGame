//
//  ViewController.swift
//  CardGame
//
//  Created by Apps2m on 13/11/2020.
//  Copyright © 2020 Apps2m. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rightNumber: UIButton!
    @IBOutlet weak var leftnumber: UIButton!
    @IBOutlet weak var currentScore: UIButton!

    var currentNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCardValues()
       
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
    
    func setCardValues(){
        currentScore.setTitle(Int.random(in: 0..<21).description, for: .normal)
        leftnumber.setTitle(getRandomNumber().description, for: .normal)
        rightNumber.setTitle(getRandomNumber().description, for: .normal)
    }
    
    func updateScore(cardValue: Int)->Int{
        
        let currentScoreInt: Int = Int (currentScore.title(for: .normal)!.description)!
        let result: Int = currentScoreInt + cardValue
        currentScore.setTitle(result.description, for: .normal)
        
        return result
    }
    
    func checkState(score:Int) {
        
        if score > 21 || score < 0 {
            performSegue(withIdentifier: "lostGame", sender: nil)
        }else{
            //SUMAR PUNTOS
        }
    }

    
}


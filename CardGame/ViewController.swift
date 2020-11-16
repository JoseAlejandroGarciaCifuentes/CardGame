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
    //@IBOutlet weak var currentScore: UILabel!
    var currentNumber: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScore.setTitle(Int.random(in: 0..<21).description, for: .normal);
        leftnumber.setTitle(getRandomNumber().description, for: .normal);
        rightNumber.setTitle(getRandomNumber().description, for: .normal);
        // Do any additional setup after loading the view.
    }

    
        //currentScore.text! = getRandomNumber().description;
    
    
    @IBAction func leftButtonAction(_ sender: Any) {
        
        
        let currentScoreInt: Int = Int (currentScore.title(for: .normal)!.description)!;
        let leftNumberInt: Int = Int (leftnumber.title(for: .normal)!.description)!;
        
        let result: Int = currentScoreInt + leftNumberInt;
        
        currentScore.setTitle(result.description, for: .normal);
        leftnumber.setTitle(getRandomNumber().description, for: .normal);
        
    }
    @IBAction func rightButtonAction(_ sender: UIButton) {
        
        let currentScoreInt: Int = Int (currentScore.title(for: .normal)!.description)!;
        let rightNumberInt: Int = Int (rightNumber.title(for: .normal)!.description)!;
        
        let result: Int = currentScoreInt + rightNumberInt;
        
        currentScore.setTitle(result.description, for: .normal);
        rightNumber.setTitle(getRandomNumber().description, for: .normal);
    }
    
    func getRandomNumber() -> Int {
        return Int.random(in: -9..<9)
    }
}


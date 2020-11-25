//
//  secondScreenController.swift
//  CardGame
//
//  Created by Alejandro Garcia on 24/11/2020.
//  Copyright © 2020 Apps2m. All rights reserved.
//

import UIKit

class secondScreenController: UIViewController {

    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        score.text = UserDefaults.standard.string(forKey: "points")! + " points"
        
    }
}

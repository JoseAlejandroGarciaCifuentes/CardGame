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
    @IBOutlet weak var bestScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Recoge el valor guardado en userdefaults y lo pone en el label
        score.text =  UserDefaults.standard.string(forKey: "points")! + " pts."
        
        //Comprueba si existe la key en user defaults de bestScore, en caso de que exista la pone en el label.
        if let bestOne = UserDefaults.standard.string(forKey: "bestScore") {
            bestScore.text = "Best Score: " + bestOne + " pts."
        }
        
    }
}

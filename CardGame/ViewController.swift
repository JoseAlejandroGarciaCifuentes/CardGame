//
//  ViewController.swift
//  CardGame
//
//  Created by Marxtodon on 13/11/2020.
//  Copyright © 2020 Apps2m. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rightCard: UIButton!
    @IBOutlet weak var leftCard: UIButton!
    @IBOutlet weak var myCard: UILabel!
    @IBOutlet weak var currentPoints: UILabel!
    
    //Declaro y asigno constantes que indican valores máximo y mínimo que podrá poseer mi carta
    let maxValue:Int = 21
    let minValue:Int = 0
    
    //Guardo las imágenes en constantes para modificarlas más adelante
    let greenCardImg = UIImage(named: "greenCard")
    let redCardImg = UIImage(named: "redCard")
    let freePointsImg = UIImage(named: "freePoints")
    
    //Me guardo la puntuación inicial en 0
    var currentPointsValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNewValues()
    }
    
    //Accíon de la carta/botón de la izquierda, llama a función de animación y funcionalidad al ser pulsada
    @IBAction func leftButtonAction(_ sender: Any) {
        
        fade_in(card: leftCard)
        fade_out(card: leftCard)
        onCardClick(card: leftCard)
        
    }
    
    //Accíon de la carta/botón de la derecha, llama a función de animación y funcionalidad al ser pulsada
    @IBAction func rightButtonAction(_ sender: UIButton) {
        
        fade_in(card: rightCard)
        fade_out(card: rightCard)
        onCardClick(card: rightCard)
    }
    
    //Devuelve num aleatorio entre -9 y 9
    func getRandomNumber() -> Int {
        return Int.random(in: -9..<9)
    }
    
    /* - Asigna valores nuevos a las tarjetas, comprueba si hay valores guardados en userdefaults, en caso de haber carga los datos y en caso de estar vacío genera nuevos aleatorios además de comprobar y asignar un comienzo viable en función de las dos cartas superiores.
     - Reinicia la puntuación a 0
     - Llama a las funciones de colocar imágen correcta y título
     - "Guarda Partida"
     */
    func setNewValues(){

        let rightNewValue:Int
        let leftNewValue:Int
        
        if let points = UserDefaults.standard.string(forKey: "points") {
            currentPointsValue = Int(points)!
            rightNewValue = Int(loadState(keyName: "rightCard"))!
            leftNewValue = Int(loadState(keyName: "leftCard"))!
            myCard.text = loadState(keyName: "currentCard")
        }else{
            rightNewValue = getRandomNumber()
            leftNewValue = getRandomNumber()
            setViableStart(rightValue: rightNewValue, leftValue: leftNewValue)
            currentPointsValue = 0
        }
        
        setProperImage(card: rightCard, newValue: rightNewValue)
        setProperImage(card: leftCard, newValue: leftNewValue)
        
        setProperTitle(card: rightCard, value:rightNewValue)
        setProperTitle(card: leftCard, value:leftNewValue)
        
        generalSave()
        
        currentPoints.text = Int(currentPointsValue).description + " pts."
    }
    
    //Suma el valor de mi carta al de la eleigda y lo asigna al label. Devuelve el resultado de la suma
    func updateMyCard(cardValue: Int)->Int{

        let currentScoreInt: Int = Int (myCard.text!.description)!
        let result: Int = currentScoreInt + cardValue
        myCard.text = result.description
        
        return result
    }
    
    /*Comprueba el estado de la partida
     En caso de que el valor de mi carta sobrepase los rangos comprueba si ha sido la mejor puntuación, en caso de serlo se guarda en los userdefaults.
     Si se ha salido de los valores también redirigirá a otra pantalla, borrará el userdefaults de puntuación y generará valores nuevos para las cartas.
     
     En caso de seguir dentro de los valores suma puntuación al total y la asigna al label además "guarda partida".
     */
    func checkState(myCard:Int) {
        
        if myCard > maxValue || myCard < minValue {
            
            if isBestScore(){
                saveState(keyName: "bestScore", value: currentPointsValue.description)
            }
            performSegue(withIdentifier: "lostGame", sender: nil)
            
            removeState(keyName: "points")
            setNewValues()

        }else{
            currentPointsValue += givePoints(percentage: calculatePercentage(myCard: myCard),score: myCard)
            generalSave()
            currentPoints.text = currentPointsValue.description + " pts."
        }
    }
    
    //Calcula y devuelve el porcentaje base al valor de mi carta y el del máximo posible (maxvalue = 21)
    //Recibe el valor de mi carta
    func calculatePercentage(myCard:Int)->Float{

        return Float(myCard) * 100 / Float(maxValue)
        
    }
    
    //Dependiendo del porcentaje en el que se encuentre el valor de mi carta la puntuación a recibir será mayor
    //Se reciben más puntos cuando 0 y 21 que en los valores medios, por ejemplo 10.
    //Recibe el valor del porcentaje
    //Devuelve puntuación
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
    
    //Comprueba el valor de las dos cartas superiores para determian cual será el valor mínimo o máximo viable para que sea posible el comienzo del juego, de manera que si no lo es genera un número para mi carta que se encuentre dentro del rango nuevo asignado.
    //En caso de ser viable generará un num aleatorio entre dentro del rango estándar
    func setViableStart(rightValue:Int, leftValue:Int){
        
        if(rightValue > minValue && leftValue > minValue){
            
            let maxPossible = maxValue - max(rightValue, leftValue)
            myCard.text = Int.random(in: minValue..<maxPossible).description
            
        }else if(rightValue < minValue && leftValue < minValue){
            
            let minPossible = minValue - min(rightValue, leftValue)
            myCard.text = Int.random(in: minPossible..<maxValue).description
            
        }else{
            myCard.text = Int.random(in: minValue..<maxValue).description
        }
    }
    
    //Recibe nombre de la clave y valor para guardar partida
    func saveState(keyName: String, value:String){
        
        UserDefaults.standard.set(value, forKey: keyName)
    }
    //Guardado general de todas las variables
    func generalSave(){
        
        saveState(keyName: "points", value: currentPointsValue.description)
        saveState(keyName: "rightCard", value: getCardValue(card: rightCard).description)
        saveState(keyName: "leftCard", value: getCardValue(card: leftCard).description)
        saveState(keyName: "currentCard", value: myCard.text!.description)
        
    }
    
    //Devuelve el valor guardado en userdefaults dependiendo del key name pasado por parámetro para cargar partida
    func loadState(keyName:String) -> String{
        return UserDefaults.standard.string(forKey: keyName)!
    }
    //Borra la clave en user defaults de la key recibida por parámetro
    func removeState(keyName: String) {
        UserDefaults.standard.removeObject(forKey: keyName)
    }
    
    //Asigna la imágen debida en funcion del valor del parámetro al button recibido también en parámetro
    func setProperImage(card: UIButton, newValue:Int){
        
        if newValue > 0{
            card.setBackgroundImage(greenCardImg, for: .normal)
        }else if newValue == 0{
            card.setBackgroundImage(freePointsImg, for: .normal)
        }else{
            card.setBackgroundImage(redCardImg, for: .normal)
        }
    }
    
    //Asigna el título/valor al botón, ambos pasados por parámetros, en caso de ser 0 no tendrá valor ya que la carta será la de "free points"
    func setProperTitle(card: UIButton, value:Int){
        
        if(value != 0){
            card.setTitle(value.description, for: .normal)
        }else{
            card.setTitle("", for: .normal)
        }
        
    }
    
    //Devuelve el valor de la carta recibida por param comprobando antes si está vacía, en caso de estarlo este será 0
    func getCardValue(card: UIButton) -> Int{
        
        if !card.title(for: .normal)!.description.isEmpty {
            return Int (card.title(for: .normal)!.description)!
        }else{
            return 0
        }
        
    }
    /*Servirá para ejecutar la funcionalidad al pulsar las cartas
        - Recoge el valor de la carta
        - Recoge la suma de los dos
        - Genera num random
        - Coloca la imagen y título debidos
        - comprueba el estado de la partida
     */
    func onCardClick(card:UIButton){
        
        let cardValue: Int = getCardValue(card: card)
        
        let myCard:Int = updateMyCard(cardValue: cardValue)
        
        let newRandomValue = getRandomNumber()
        
        setProperImage(card: card, newValue: newRandomValue)
        
        setProperTitle(card: card, value:newRandomValue)
        
        checkState(myCard: myCard)
        
    }
    
    // Cmprueba si esta ultima score ha sido la máxima puntuación en función del valor de la última guardada
    func isBestScore() -> Bool{
        
        if let bestScore = UserDefaults.standard.string(forKey: "bestScore"){
            if Int(bestScore)! < currentPointsValue{
                return true
            }else{
                return false
            }
        }else{
            return true
        }
        
    }
    
    //Animación fade in
    func fade_in(card:UIButton) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut,animations: {
            card.alpha = 0.0
        },completion: nil)
    }
    
    //Animación fade out
    func fade_out(card:UIButton) {
        UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseOut, animations: {
            card.alpha = 1.0
        },completion: nil)
    }

    
}


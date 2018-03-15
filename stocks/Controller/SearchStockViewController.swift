//
//  SearchStockViewController.swift
//  
//
//  Created by Timothy Lee on 3/13/18.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchStockViewController: UIViewController {
    
    let STOCKS_URL = "https://www.alphavantage.co/query"
    let APP_ID = "YF4GKFKVSW54BMH4"
    
    //IBOutlet defining stockModal that will appear and disappear.
    @IBOutlet weak var stockModal: UIView!
    
    //IBOutlet defining TextField that user inputs stock name
    @IBOutlet weak var searchStockTextField: UITextField!
    
    //IBAction defining when the back button is pressed, which sends user back to main screen
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goBackToMainScreen", sender: self)
    }
    
    //IBOutlet representing the stockModal central constraint
    @IBOutlet weak var stockModalConstraint: NSLayoutConstraint!
    
    //IBAction defining when the search button is pressed, which sends user to modal with detailed Stock Info
    @IBAction func searchButtonPressed(_ sender: Any) {
        //Shake animation that plays if the text field is empty.
        if self.searchStockTextField.text == "" {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.searchStockTextField.center.x - 10, y: self.searchStockTextField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.searchStockTextField.center.x + 10, y: self.searchStockTextField.center.y))
            self.searchStockTextField.layer.add(animation, forKey: "position")
        } else {
            //If text field is not empty, the modal shows up.
            stockModalConstraint.constant = 0
            //Animation to slide in the modal over 0.3s.
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                //Changes alpha setting to 0.5, which causes background behind modal to dim.
                self.backgroundButton.alpha = 0.5
            })
        }
        
    }
    //IBAction defining when the close button is pressed, which dismisses the stock modal
    @IBAction func closeButtonPressed(_ sender: Any) {
        stockModalConstraint.constant = -400
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        })
    }
    
    //IBOutlet for background button that's screen sized, allows user to dismiss popup once done with it in addition to being able to close out from "Close" Button.
    @IBOutlet weak var backgroundButton: UIButton!
    
    @IBOutlet weak var stockModalStockName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stockModal.layer.cornerRadius = 8
    }
    
    //IBAction that initiates search for stock that user inputs
    @IBAction func searchForStockButtonPressed(_ sender: Any) {
        if let searchInput = searchStockTextField.text {

            let params : [String : String] = ["function" : "TIME_SERIES_DAILY", "symbol" : searchInput, "apikey" : "YF4GKFKVSW54BMH4"]
            self.checkStockFromInput(url: STOCKS_URL, parameters: params)
            
        } else {
            return
        }
    }
    
    //MARK: checkStockFromInput is function that takes user input and makes call to Alphavantage API
    func checkStockFromInput(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                guard let result = response.result.value else { return }
                print(type(of: result))

//                let stockName = json["Meta Data"]["2. Symbol"]
//
//                self.stockModalStockName.text = String(describing: stockName).uppercased()
                
            } else {
                
                print("Error \(String(describing: response.result.error))")
                
            }
        }
    }
}

//
//  SearchStockViewController.swift
//  
//
//  Created by Timothy Lee on 3/13/18.
//

import UIKit
import Alamofire

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
    
    @IBOutlet weak var stockModalConstraint: NSLayoutConstraint!
    
    //IBAction defining when the search button is pressed, which sends user to modal with detailed Stock Info
    @IBAction func searchButtonPressed(_ sender: Any) {
        stockModalConstraint.constant = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stockModal.layer.zPosition = 100
    }
    
    //IBAction that initiates search for stock that user inputs
    @IBAction func searchForStockButtonPressed(_ sender: Any) {
        if let searchInput = searchStockTextField.text {
            print(searchInput)
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
                
                let result = response.result.value!
                print(result)
                
            } else {
                
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
}

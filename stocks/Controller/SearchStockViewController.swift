//
//  SearchStockViewController.swift
//  
//
//  Created by Timothy Lee on 3/13/18.
//

import UIKit

class SearchStockViewController: UIViewController {
    
    //IBOutlet defining TextField that user inputs stock name
    @IBOutlet weak var searchStockTextField: UITextField!
    
    //IBAction defining when the back button is pressed, which sends user back to main screen
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goBackToMainScreen", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func searchForStockButtonPressed(_ sender: Any) {
        if let searchInput = searchStockTextField.text {
            print(searchInput)
        } else {
            return
        }
    }
    
    
}

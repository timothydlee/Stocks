//
//  ViewController.swift
//  stocks
//
//  Created by Timothy Lee on 3/5/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import Alamofire

let STOCKS_URL = ""

class ViewController: UIViewController {
    
    let STOCKS_URL = "https://www.alphavantage.co/query?"
    let APP_ID = "YF4GKFKVSW54BMH4"

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=INTL&interval=60min&apikey=\(APP_ID)").responseJSON {
            response in
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  IndividualStockModalViewController.swift
//  stocks
//
//  Created by Timothy Lee on 3/13/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit

class IndividualStockModalViewController: UIViewController {

    //Creates IBOutlet reference to the Modal view itself
    @IBOutlet weak var stockModal: UIView!
    
    //IBAction that defines how to dismiss the popup once user is done
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gives popup rounded corners.
        stockModal.layer.cornerRadius = 8
    }
    
}

//
//  customCell.swift
//  stocks
//
//  Created by Timothy Lee on 3/15/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstViewTitleLabel: UILabel!
    @IBOutlet weak var firstViewDetailLabel: UILabel!
    

    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondViewTitleLabel: UILabel!
    @IBOutlet weak var secondViewDetailLabel: UILabel!
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var showDetails = false {
        didSet {
            secondViewHeightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(showDetails ? 250 : 999))
        }
    }
    
}

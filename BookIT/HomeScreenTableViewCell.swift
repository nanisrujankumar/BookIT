//
//  HomeScreenTableViewCell.swift
//  BookIT
//
//  Created by SRAVANKUMAR VEERANTI on 28/02/2017.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit

class HomeScreenTableViewCell: UITableViewCell {

    @IBOutlet var Name: UILabel!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet var desc: UILabel!
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    @IBOutlet weak var product: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet weak var timeHeight: NSLayoutConstraint!
    @IBOutlet var days: UILabel!
    @IBOutlet weak var daysHeight: NSLayoutConstraint!
    @IBOutlet var place: UILabel!
    @IBOutlet weak var placeHeight: NSLayoutConstraint!
    @IBOutlet weak var placeImageHeight: NSLayoutConstraint!
    @IBOutlet var acceptBtn: UIButton!
    @IBOutlet weak var acceptHeight: NSLayoutConstraint!
    @IBOutlet var declineBtn: UIButton!
    @IBOutlet weak var declineHeight: NSLayoutConstraint!
    @IBOutlet weak var agency: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

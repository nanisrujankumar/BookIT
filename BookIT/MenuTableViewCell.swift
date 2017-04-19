//
//  MenuTableViewCell.swift
//  BookIT
//
//  Created by Sagar Babber on 3/1/17.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var Name: UILabel!
    @IBOutlet var menuImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

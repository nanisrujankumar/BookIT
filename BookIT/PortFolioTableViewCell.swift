//
//  PortFolioTableViewCell.swift
//  BookIT
//
//  Created by Sagar Babber on 2/28/17.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit

class PortFolioTableViewCell: UITableViewCell {
    @IBOutlet var agentName: UILabel!
    @IBOutlet var updatedDate: UILabel!
    @IBOutlet var divisionName: UILabel!
    @IBOutlet var downloadBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

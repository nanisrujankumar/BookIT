//
//  MessageTableViewCell.swift
//  BookIT
//
//  Created by Srujan on 05/04/17.
//  Copyright © 2017 SRUJAN KUMAR. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  TableViewCell.swift
//  webviewAuth
//
//  Created by user on 7/26/17.
//  Copyright © 2017 full. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var one: UILabel!
    
    @IBOutlet weak var two: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

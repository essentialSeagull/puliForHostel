//
//  mainOrderTableViewCell.swift
//  puliForHostel
//
//  Created by viplab on 2020/5/26.
//  Copyright © 2020 viplab. All rights reserved.
//

import UIKit

class mainOrderTableViewCell: UITableViewCell {
    
    @IBOutlet var userNameLabel:UILabel!
    @IBOutlet var timeLabel:UILabel!
    @IBOutlet var orderStatusLabel:UILabel!
  //  @IBOutlet var roomTypeLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

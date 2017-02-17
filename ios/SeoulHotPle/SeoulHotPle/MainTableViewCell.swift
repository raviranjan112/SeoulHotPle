//
//  MainTableViewCell.swift
//  MySNS
//
//  Created by KimJingyu on 2017. 2. 11..
//  Copyright © 2017년 JK. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var lbStationName: UILabel!
    @IBOutlet weak var btnGoChat: UIButton!
    @IBOutlet weak var ChatPopular: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

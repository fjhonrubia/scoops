//
//  FHLNewsViewCell.swift
//  Scoops
//
//  Created by javi on 2/3/16.
//  Copyright © 2016 fhl. All rights reserved.
//

import UIKit

class FHLNewsViewCell: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var valoracion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

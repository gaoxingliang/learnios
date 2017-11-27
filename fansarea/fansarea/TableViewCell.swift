//
//  TableViewCell.swift
//  fansarea
//
//  Created by edward.gao on 27/11/2017.
//  Copyright © 2017 edward.gao. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    // IBOutlet is a ref for a UI component
    // IBAction is a ref for UI component which you can touch it and do more operations
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var thumbnail: UIImageView!

    @IBOutlet weak var provinceLable: UILabel!
    @IBOutlet weak var partLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

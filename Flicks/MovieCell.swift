//
//  MovieCell.swift
//  Flicks
//
//  Created by Scotty's Macbook on 1/7/16.
//  Copyright © 2016 SM. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

   
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    @IBOutlet weak var posterView: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  CustomCell.swift
//  WalmartCodingTest
//
//  Created by Sai Suman Pothedar on 11/15/22.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var code: UILabel!
    
    @IBOutlet weak var seperator: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

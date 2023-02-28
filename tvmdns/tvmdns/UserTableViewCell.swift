//
//  UserTableViewCell.swift
//  tvmdns
//
//  Created by Skyler Hope on 2/28/23.
//

import UIKit



class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

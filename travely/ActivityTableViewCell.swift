//
//  ActivityTableViewCell.swift
//  travely
//
//  Created by Alexandra Leonidova on 4/14/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

@objc protocol ActivityCellDelegate: class {
    func checkmarkTapped(sender: ActivityTableViewCell)
}

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkedButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    
    var delegate: ActivityCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

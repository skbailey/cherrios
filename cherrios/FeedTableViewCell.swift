//
//  FeedTableViewCell.swift
//  cherrios
//
//  Created by Sherard Bailey on 10/29/20.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    var onReuse: () -> Void = {}

    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        profileImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

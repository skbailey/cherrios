//
//  FeedCollectionViewCell.swift
//  cherrios
//
//  Created by Sherard Bailey on 12/20/20.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    var onReuse: () -> Void = {}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        profileImageView.image = nil
    }
}

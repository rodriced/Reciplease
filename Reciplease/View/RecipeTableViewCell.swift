//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Rod on 26/07/2022.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(image: UIImage, title: String, subtitle: String) {
        backgroundImageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

}

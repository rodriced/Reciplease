//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Rod on 26/07/2022.
//

import UIKit
import SDWebImage

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func configure(imageUrl: URL, title: String, subtitle: String) {
        recipeImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "RecipeSample"))
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

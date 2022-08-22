//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 26/07/2022.
//

import SDWebImage
import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    func addBottomGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = recipeImageView.bounds
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        recipeImageView.layer.addSublayer(gradient)
    }

    func configure(imageUrl: URL, title: String, subtitle: String) {
        addBottomGradient()
        recipeImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "RecipePlaceholder"))
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

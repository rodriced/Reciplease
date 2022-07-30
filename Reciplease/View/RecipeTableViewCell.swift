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
        recipeImageView.sd_setImage(with: imageUrl)
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

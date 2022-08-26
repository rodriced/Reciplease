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
    @IBOutlet weak var recipeInfosView: UIView!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    func configure(recipe: Recipe) {
        ControllerHelper.addBottomGradient(to: recipeImageView)

        let foodsString = recipe.foods.map { $0.firstUppercased }.joined(separator: ", ")
        recipeImageView.sd_setImage(with: URL(string: recipe.image)!, placeholderImage: UIImage(named: "RecipePlaceholder"))
        titleLabel.text = recipe.label
        subtitleLabel.text = foodsString
        
//        let recipeInfoVC = UIStoryboard(name: "RecipeInfoViewController", bundle: nil).instantiateInitialViewController()! as! RecipeInfoViewController
//        recipeInfoVC.recipe = recipe
//        recipeInfoVC.view.frame = recipeInfosView.bounds
//        recipeInfosView.addSubview(recipeInfoVC.view)
    }
}

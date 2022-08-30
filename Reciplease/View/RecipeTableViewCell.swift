//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 26/07/2022.
//

import SDWebImage
import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: View components
    
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.isAccessibilityElement = false
        }
    }

    @IBOutlet var recipeInfosView: RecipeInfosBoxView! {
        didSet {
            recipeInfosView.isAccessibilityElement = false
        }
    }

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .none
        }
        set {}
    }

    // MARK: Initialization
    
    func configure(recipe: Recipe) {
        ControllerHelper.addBottomGradient(to: recipeImageView)

        let foodsString = recipe.foods.map { $0.firstUppercased }.joined(separator: ", ")
        let foodsCountString = String(recipe.foods.count)
        
        recipeImageView.sd_setImage(with: URL(string: recipe.image)!, placeholderImage: UIImage(named: "RecipePlaceholder"))
        titleLabel.text = recipe.label
        subtitleLabel.text = foodsString

        recipeInfosView.setupWithRecipe(recipe)

        accessibilityLabel = recipe.label + "."
            + (recipeInfosView.accessibilityText.isEmpty ? "" : " \(recipeInfosView.accessibilityText).")
            + (foodsString.isEmpty ? "" : " \(foodsCountString) ingrdients: \(foodsString)")
        accessibilityHint = "Activate to see details"
    }
}

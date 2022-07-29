//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Rod on 28/07/2022.
//

import UIKit

class RecipeViewController: UIViewController {
    var recipe: Recipe!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ingredientsTextView: UITextView!
    
    @IBOutlet var favoriteButton: UIBarButtonItem!
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        recipe.toggleFavorite()
        updateFavoriteButtonState()
    }
    
    func updateFavoriteButtonState() {
        if recipe.isFavorite {
            favoriteButton.image = UIImage(systemName: "star.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "star")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFavoriteButtonState()
        
        let imageUrl = URL(string: recipe.image)!
        imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "RecipeSample"))
        
        ingredientsTextView.text = recipe.ingredientLines.joined(separator: "\n")

        // Do any additional setup after loading the view.
    }
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

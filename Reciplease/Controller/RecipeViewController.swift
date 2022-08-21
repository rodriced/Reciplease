//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 28/07/2022.
//

import UIKit

class RecipeViewController: UIViewController {
    var recipe: Recipe!
    
    var recipeInfoVC: RecipeInfoViewController!
    @IBOutlet var recipeInfoView: UIView!
    @IBOutlet var recipeInfoView2: UIView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ingredientsTextView: UITextView!
    @IBOutlet var favoriteButton: UIBarButtonItem!
    @IBOutlet var directionsButton: UIButton!
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
//        print("favoriteButtonTapped")
        Task {
            try await recipe.toggleFavorite()
            DispatchQueue.main.async {
                self.updateFavoriteButtonState()
            }
        }
    }
    
    @IBAction func directionsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "SegueFromRecipeToDirections", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SegueFromRecipeToDirections":
            let directionsVC = segue.destination as! RecipeDirectionsViewController
            directionsVC.directionsUrl = URL(string: recipe.url)!
        case "SegueFromRecipeToRecipeInfos":
            recipeInfoVC = (segue.destination as! RecipeInfoViewController)
            recipeInfoVC.recipe = recipe
        default:
            return
        }
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
        
        recipeInfoVC.view.frame = recipeInfoView.bounds
        
        updateFavoriteButtonState()
        
        let imageUrl = URL(string: recipe.image)!
        imageView.sd_setImage(with: imageUrl)

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

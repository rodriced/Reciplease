//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 28/07/2022.
//

import UIKit

class RecipeViewController: UIViewController {
    var recipe: Recipe!
    
    // MARK: - View components

    @IBOutlet var recipeInfosBoxView: RecipeInfosBoxView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ingredientsTextView: UITextView!
    @IBOutlet var directionsButton: UIButton!
    
    @IBOutlet var favoriteButton: UIBarButtonItem!
    var activityFakeButton: UIBarButtonItem!
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View actions

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        toggleFavoriteState()
    }
    
    @IBAction func directionsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "SegueFromRecipeToDirections", sender: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueFromRecipeToDirections" {
            let directionsVC = segue.destination as! RecipeDirectionsViewController
            directionsVC.directionsUrl = URL(string: recipe.url)!
        }
    }
        
    // MARK: - Logic
    
    func toggleFavoriteState() {
        //        let oldFavoriteState = recipe.isFavorite
        //        print("favoriteButtonTapped")
                updateFavoriteButtonState(loading: true)
                Task {
        //            do {
                    try await recipe.toggleFavorite()
                    
                    DispatchQueue.main.async {
        //                // To prevent a bad state if firestore network connexion is lost
        //                let isLoadingBecauseOfFirestoreResponseDelay = self.recipe.isFavorite == oldFavoriteState
        //
        //                self.updateFavoriteButtonState(loading: isLoadingBecauseOfFirestoreResponseDelay)
                        
                        self.updateFavoriteButtonState()
                    }
        //            } catch {
        //                print("favoriteButtonTapped : \(error)")
        //            }
                }
    }

    @objc func updateFavoriteButtonState(loading: Bool = false) {
        if loading {
            navigationItem.setRightBarButton(activityFakeButton, animated: true)
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            
            navigationItem.setRightBarButton(favoriteButton, animated: true)
            if recipe.isFavorite {
                favoriteButton.image = UIImage(systemName: "star.fill")
                favoriteButton.accessibilityValue = "Selected"
            } else {
                favoriteButton.image = UIImage(systemName: "star")
                favoriteButton.accessibilityValue = "Deselected"
            }
        }
    }
    
    func initActivityStuff() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.sizeToFit()
        activityIndicator.style = .medium
        
        activityFakeButton = UIBarButtonItem(customView: activityIndicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeInfosBoxView.setupWithRecipe(recipe)
        
        initActivityStuff()
        
        updateFavoriteButtonState()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteButtonState), name: NSNotification.Name(rawValue: "favoriteRecipesChanged"), object: nil)
        
        ControllerHelper.addBottomGradient(to: imageView)
        titleLabel.text = recipe.label
        let imageUrl = URL(string: recipe.image)!
        imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "RecipePlaceholder"))

        ingredientsTextView.text = recipe.ingredientLines.joined(separator: "\n")

        titleLabel.accessibilityLabel = recipe.label + "."
            + (recipeInfosBoxView.accessibilityText.isEmpty ? "" : " \(recipeInfosBoxView.accessibilityText).")
        recipeInfosBoxView.isAccessibilityElement = false
        recipeInfosBoxView.accessibilityElements = []
        imageView.isAccessibilityElement = false
    }
}

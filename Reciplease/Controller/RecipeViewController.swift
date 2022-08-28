//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 28/07/2022.
//

import UIKit

class RecipeViewController: UIViewController {
    var recipe: Recipe!
    
//    var recipeInfoVC: RecipeInfoViewController!
    @IBOutlet var recipeInfosBoxView: RecipeInfosBoxView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ingredientsTextView: UITextView!
    @IBOutlet var directionsButton: UIButton!
    
    @IBOutlet var favoriteButton: UIBarButtonItem!
    var activityFakeButton: UIBarButtonItem!
    var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
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
    
    @IBAction func directionsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "SegueFromRecipeToDirections", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SegueFromRecipeToDirections":
            let directionsVC = segue.destination as! RecipeDirectionsViewController
            directionsVC.directionsUrl = URL(string: recipe.url)!
//        case "SegueFromRecipeToRecipeInfos":
//            recipeInfoVC = (segue.destination as! RecipeInfoViewController)
//            recipeInfoVC.recipe = recipe
        default:
            return
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
            } else {
                favoriteButton.image = UIImage(systemName: "star")
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
        
//        recipeInfoVC.view.frame = recipeInfosBoxView.bounds
        
        recipeInfosBoxView.setupWithRecipe(recipe)
        
        initActivityStuff()
        
        updateFavoriteButtonState()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteButtonState), name: NSNotification.Name(rawValue: "favoriteRecipesChanged"), object: nil)
        
        ControllerHelper.addBottomGradient(to: imageView)
        titleLabel.text = recipe.label
        let imageUrl = URL(string: recipe.image)!
        imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "RecipePlaceholder"))

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

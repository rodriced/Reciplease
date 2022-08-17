//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 17/07/2022.
//

import SwiftUI
import UIKit

class SearchViewController: UIViewController {
    var search: Search!
//    var recipes: [Recipe]? = nil

    @IBOutlet var ingredientTextField: UITextField!
    @IBOutlet var ingredientsTableView: UITableView!

    @IBOutlet var yourIngredientsLabel: UILabel!
    @IBOutlet var addIngredientButton: UIButton!
    @IBOutlet var clearAllButton: UIButton!
    @IBOutlet var searchRecipesButton: UIButton!
    
    @IBAction func addIngredientButtonTapped(_ sender: Any) {
        transferIngredientTextFieldContentToIngredientsTextView()
    }
    
    @IBAction func clearAllButtonTapped(_ sender: Any) {
        search.clear()
        ingredientsTableView.reloadData()
        updateButtonsState()
    }
    
    @IBAction func searchRecipesButtonTapped(_ sender: Any) {
        guard !search.isEmpty else { return }
        
        Task {
            let recipes = try? await RecipesAPIService.shared.searchRecipes(ingredients: search.ingredients)
            DispatchQueue.main.async {
                guard let recipes = recipes else {
                    self.present(ControllerHelper.simpleErrorAlert(message: "No recipe found !"), animated: true)
                    return
                }

                self.performSegue(withIdentifier: "SegueFromSearchToRecipes", sender: recipes)
            }
        }
//        RecipesAPIService.shared!.searchRecipes(ingredients: search.ingredients) { recipes in
//            DispatchQueue.main.async {
//                guard let recipes = recipes else {
//                    self.present(ControllerHelper.simpleErrorAlert(message: "No recipe found !"), animated: true)
//                    return
//                }
//
//                self.performSegue(withIdentifier: "SegueFromSearchToRecipes", sender: recipes)
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueFromSearchToRecipes" {
            let recipesVC = segue.destination as! RecipesTableViewController
            recipesVC.recipes = sender as! [Recipe]
            recipesVC.navigationItem.title = "Recipes found"
        }
    }

    func transferIngredientTextFieldContentToIngredientsTextView() {
        let maybeIngredients = ingredientTextField.text?
            .split(separator: ",")
            .map {
                $0.trimmingCharacters(in: .whitespaces)
            }.filter { !$0.isEmpty }
        
        guard let ingredients = maybeIngredients, !ingredients.isEmpty else { return }
        
//        guard let ingredients = ingredientTextField.text?.split(separator: ",").map{ "\($0)" } else { return }
//        guard let ingredientText = ingredientTextField.text?.trimmingCharacters(in: .whitespaces),
//              !ingredientText.isEmpty
//        else { return }
        
//        guard let ingredients = ingredientTextField.text?.split(separator: ',')
//                .split(separator: ",").map {$0} else { return }
//                .map { return "\($0)" }
//                    .map("\($0)".trimmingCharacters(in: .whitespaces)},
//              !ingredients.isEmpty
//        else { return }
        
//        search.addIngredient(ingredientText)
        search.addIngredients(ingredients)
        ingredientsTableView.reloadData()
        ingredientTextField.text = ""
        
        updateButtonsState()
        updateIngredientAddButtonState()
        updateAccessibilityState()
    }
    
    func updateButtonsState() {
        clearAllButton.isEnabled = !search.isEmpty
        searchRecipesButton.isEnabled = !search.isEmpty
    }
    
    func updateAccessibilityState() {
        yourIngredientsLabel.accessibilityLabel = search.isEmpty ? "Ingredients list is empty" : "Your ingredients : " + search.ingredients.joined(separator: ",")
//        clearAllButton.accessibilityElementsHidden = search.isEmpty
        ingredientsTableView.accessibilityElementsHidden = true
//        searchRecipesButton.accessibilityElementsHidden = search.isEmpty
    }
    
    func updateIngredientAddButtonState() {
        addIngredientButton.isEnabled = !(ingredientTextField.text?.isEmpty ?? true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ingredientsTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: "#hideKeyboard", action: nil))
        
        ingredientsTableView.dataSource = self
        
        ingredientTextField.delegate = self
       
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: ingredientTextField, queue: nil) { _ in
            self.updateIngredientAddButtonState()
        }
        
//        search = Search.initTest()
        search = Search()

        updateButtonsState()
        updateIngredientAddButtonState()
        updateAccessibilityState()
    }
}

extension SearchViewController: UITableViewDataSource {
    static let ingredientCellId = "IngredientCell"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        search.ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.ingredientCellId, for: indexPath)
        cell.textLabel?.text = "- \(search.ingredients[indexPath.row])"
        return cell
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ingredientTextField {
//            textField.resignFirstResponder()
            transferIngredientTextFieldContentToIngredientsTextView()
            return false
        }
        return true
    }
}

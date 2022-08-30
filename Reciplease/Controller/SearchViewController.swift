//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 17/07/2022.
//

import SwiftUI
import UIKit

class SearchViewController: UIViewController {
    var ingredients = [String]()

    // MARK: - View components

    var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet var ingredientTextField: UITextField!
    @IBOutlet var ingredientsTableView: UITableView!

    @IBOutlet var yourIngredientsLabel: UILabel!
    @IBOutlet var addIngredientButton: UIButton!
    @IBOutlet var clearAllButton: UIButton!
    @IBOutlet var searchRecipesButton: UIButton!
    
    // MARK: - View actions

    @IBAction func addIngredientButtonTapped(_ sender: Any) {
        transferIngredientTextFieldContentToIngredientsTextView()
    }
    
    @IBAction func clearAllButtonTapped(_ sender: Any) {
        clearIngredients()
    }
    
    @IBAction func searchRecipesButtonTapped(_ sender: Any) {
        launchSearch()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueFromSearchToRecipes" {
            let recipesVC = segue.destination as! RecipesTableViewController
            recipesVC.recipes = sender as! [Recipe]
            recipesVC.navigationItem.title = "Search result"
        }
    }

    // MARK: - Logic
    
    func clearIngredients() {
        ingredients = []
        ingredientsTableView.reloadData()
        updateButtonsState()
    }
    
    func launchSearch() {
        guard !ingredients.isEmpty else { return }
        
        updateLoadingStatus(true)
        
        Task {
            let recipes = try? await RecipesAPIService.shared.searchRecipes(ingredients: ingredients)
//            try! await Task.sleep(nanoseconds: 4_000_000_000)
            self.updateLoadingStatus(false)

            DispatchQueue.main.async {
                guard let recipes = recipes else {
                    self.present(ControllerHelper.simpleErrorAlert(message: "Network error, can't retrieve recipes."), animated: true)
                    return
                }
                
//                if recipes.isEmpty {
//                    self.present(ControllerHelper.simpleErrorAlert(message: "No recipe found !"), animated: true)
//                    return
//                }
                
                self.performSegue(withIdentifier: "SegueFromSearchToRecipes", sender: recipes)
            }
        }
    }
    
    func transferIngredientTextFieldContentToIngredientsTextView() {
        let maybeIngredients = ingredientTextField.text?
            .split(separator: ",")
            .map {
                $0.trimmingCharacters(in: .whitespaces)
            }.filter { !$0.isEmpty }
        
        guard let ingredients = maybeIngredients, !ingredients.isEmpty else { return }
        
        self.ingredients.append(contentsOf: ingredients)
        ingredientsTableView.reloadData()
        ingredientTextField.text = ""
        
        updateButtonsState()
        updateIngredientAddButtonState()
        updateAccessibilityState()
    }
    
    func updateButtonsState() {
        clearAllButton.isEnabled = !ingredients.isEmpty
        searchRecipesButton.isEnabled = !ingredients.isEmpty
    }
    
    func updateAccessibilityState() {
        yourIngredientsLabel.accessibilityLabel = ingredients.isEmpty ? "Ingredients list is empty" : "Your ingredients : " + ingredients.joined(separator: ",")
//        clearAllButton.accessibilityElementsHidden = search.isEmpty
//        searchRecipesButton.accessibilityElementsHidden = search.isEmpty
    }
    
    func updateIngredientAddButtonState() {
        let ingredientTextFieldIsEmpty = ingredientTextField.text?.isEmpty ?? true
        addIngredientButton.isEnabled = !ingredientTextFieldIsEmpty
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func updateLoadingStatus(_ loading: Bool) {
        searchRecipesButton.isEnabled = !loading
        loading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    // MARK: Initialization
    
    override func viewWillAppear(_ animated: Bool) {
        ingredientsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))

        loadingIndicator = ControllerHelper.addButtonActivityIndicator(to: searchRecipesButton)

        ingredientsTableView.dataSource = self
        ingredientsTableView.accessibilityElementsHidden = true

        ingredientTextField.delegate = self
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: ingredientTextField, queue: nil) { _ in
            self.updateIngredientAddButtonState()
        }
                
        updateButtonsState()
        updateIngredientAddButtonState()
        updateAccessibilityState()
    }
}

// MARK: - Table view data source

extension SearchViewController: UITableViewDataSource {
    static let ingredientCellId = "IngredientCell"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.ingredientCellId, for: indexPath)
        cell.textLabel?.text = "- \(ingredients[indexPath.row])"
        return cell
    }
}

// MARK: - Text field delegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ingredientTextField {
            transferIngredientTextFieldContentToIngredientsTextView()
            return false
        }
        return true
    }
}

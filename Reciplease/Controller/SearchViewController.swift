//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Rod on 17/07/2022.
//

import SwiftUI
import UIKit

class SearchViewController: UIViewController {
    var search: Search!
//    var recipes: [Recipe]? = nil

    @IBOutlet var ingredientTextField: UITextField!
    @IBOutlet var ingredientsTableView: UITableView!

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
        
//        let recipes = Array.init(repeating: Recipe.sample, count: 3)
//        self.performSegue(withIdentifier: "SegueFromSearchToRecipes", sender: self)

        RecipesAPIService.searchRecipes(ingredients: search.ingredients) { recipes in
            DispatchQueue.main.async {
                guard let recipes = recipes else {
                    self.present(ControllerHelper.simpleAlert(message: "No recipe found !"), animated: true)
                    return
                }
//                self.recipes = recipes
//                print(recipes[0])
                self.performSegue(withIdentifier: "SegueFromSearchToRecipes", sender: recipes)
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("PREPARE")
        if segue.identifier == "SegueFromSearchToRecipes" {
            let recipesVC = segue.destination as! RecipesTableViewController
            recipesVC.recipes = sender as! [Recipe]
//            recipesVC.recipes = Array(repeating: Recipe.sample, count: 4)
//                recipes = sender! as! [Recipe]
            //            let searchVC = segue.source as! SearchViewController
            //            recipes = searchVC.recipes!
            //            recipes = [Recipe.sample]
            //            recipes = Array.init(repeating: Recipe.sample, count: 3)
        }
//                        recipes = Array.init(repeating: Recipe.sample, count: 3)
        //        super.prepare(for: segue, sender: sender)
    }

    func transferIngredientTextFieldContentToIngredientsTextView() {
        guard let ingredientText = ingredientTextField.text?.trimmingCharacters(in: .whitespaces),
              !ingredientText.isEmpty
        else { return }
        
        search.addIngredient(ingredientText)
        ingredientsTableView.reloadData()
        ingredientTextField.text = ""
        updateButtonsState()
        updateIngredientAddButtonState()
    }
    
    func updateButtonsState() {
        clearAllButton.isEnabled = !search.isEmpty
        searchRecipesButton.isEnabled = !search.isEmpty
    }
    
    func updateIngredientAddButtonState() {
        addIngredientButton.isEnabled = !(ingredientTextField.text?.isEmpty ?? true)
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
        
        search = Search.initTest()
        
        updateButtonsState()
        updateIngredientAddButtonState()
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

//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Rod on 17/07/2022.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {
    var search: Search!

    @IBOutlet var ingredientTextField: UITextField!
    @IBOutlet weak var ingredientsTableView: UITableView!

    @IBOutlet var addIngredientButton: UIButton!
    @IBOutlet var clearAllButton: UIButton!
    @IBOutlet var searchRecipesButton: UIButton!
    
    @IBAction func addIngredientButtonTapped(_ sender: Any) {
        updateIngredientsTextViewWithIngredientTextFieldContent()
    }
    
    @IBAction func clearAllButtonTapped(_ sender: Any) {
        search.clear()
        ingredientsTableView.reloadData()
        updateButtonsState()
    }
    
    @IBAction func searchRecipesButtonTapped(_ sender: Any) {
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func updateIngredientsTextViewWithIngredientTextFieldContent() {
        guard let ingredientText = ingredientTextField.text?.trimmingCharacters(in: .whitespaces),
              !ingredientText.isEmpty
        else { return }
        
        search.addIngredient(ingredientText)
        ingredientsTableView.reloadData()
        ingredientTextField.text = ""
        updateButtonsState()
    }
    
    func updateButtonsState() {
        clearAllButton.isEnabled = !search.isEmpty
        searchRecipesButton.isEnabled = !search.isEmpty
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        ingredientsTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: "#hideKeyboard", action: nil))
        
        ingredientsTableView.dataSource = self
        ingredientTextField.delegate = self
        
        search = Search.initTest()
        
        updateButtonsState()
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
            updateIngredientsTextViewWithIngredientTextFieldContent()
            return false
        }
        return true
    }
}
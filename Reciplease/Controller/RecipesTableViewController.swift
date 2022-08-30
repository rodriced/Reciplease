//
//  RecipesTableViewController.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 26/07/2022.
//

import UIKit

class RecipesTableViewController: UITableViewController {
    var recipes = [Recipe]()
    private var isFavoriteRecipesTab = false

    private lazy var emptyMessage: String =
        isFavoriteRecipesTab ? "No favorites" : "No recipe found"

    enum RecipesTableState {
        case loading, empty, error, normal
    }

    private var state: RecipesTableState!

    private var indicator: UIActivityIndicatorView!

    func updateState(_ newState: RecipesTableState) {
        switch newState {
        case .loading:
            tableView.backgroundView = nil
            indicator.startAnimating()
        case .empty:
            indicator.stopAnimating()
            setTableViewBackgroundMessage(emptyMessage)
        case .error:
            indicator.stopAnimating()
            setTableViewBackgroundMessage("Network error, can't retrieve favorite recipes.\nCome back on this tab later.", isError: true)
        case .normal:
            tableView.backgroundView = nil
            indicator.stopAnimating()
        }
        state = newState
    }

    @objc func loadFavoriteRecipes() {
        updateState(.loading)

        Task {
            do {
                guard let favoriteRecipes = try await FavoriteRecipes.shared.getAll() else {
                    // Favorite recipes not ready
                    // List filling will be done on next notification reception
                    return
                }

                recipes = favoriteRecipes
                tableView.reloadData()

                if isFavoriteRecipesTab {
                    if recipes.isEmpty {
                        updateState(.empty)
                    } else {
                        updateState(.normal)
                    }
                }
            } catch {
                updateState(.error)
            }
        }
    }

    func setTableViewBackgroundMessage(_ message: String, isError: Bool = false) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 20)
//        messageLabel.textColor = isError ? UIColor.red : UIColor(named: "TextColor")
        messageLabel.textColor = UIColor(named: "TextColor")
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()

        tableView.backgroundView = messageLabel
    }

    // MARK: - Initialization
    
    override func viewWillAppear(_ animated: Bool) {
        if isFavoriteRecipesTab {
            loadFavoriteRecipes()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        indicator = ControllerHelper.addTableViewActivityIndicator(to: tableView)

        isFavoriteRecipesTab = navigationController!.tabBarItem.tag == TabBarItemTag.favorites.rawValue

        if isFavoriteRecipesTab {
            // For remote update from firestore
            NotificationCenter.default.addObserver(self, selector: #selector(loadFavoriteRecipes), name: NSNotification.Name(rawValue: "favoriteRecipesChanged"), object: nil)

            updateState(.loading)
        } else {
            recipes.isEmpty ? updateState(.empty) : updateState(.normal)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell

        let recipe = recipes[indexPath.row]
        cell.configure(recipe: recipe)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueFromRecipesToRecipe", sender: recipes[indexPath.row])
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueFromRecipesToRecipe" {
            let recipeVC = segue.destination as! RecipeViewController
            recipeVC.recipe = sender as? Recipe
        }
    }
}

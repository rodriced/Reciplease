//
//  RecipesTableViewController.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 26/07/2022.
//

import UIKit

class RecipesTableViewController: UITableViewController {
    var recipes: [Recipe] = []
    var favoriteMode = false

    func loadfavoriteRecipes() {
//        print("loadfavoriteRecipes")
        Task {
            guard let recipesAPI = RecipesAPIService.shared,
            let favoriteRecipes = await recipesAPI.loadFavoriteRecipes() else {
                self.present(ControllerHelper.simpleErrorAlert(message: "Network access error !"), animated: true)
                return
            }
            
//            guard !favoriteRecipes.isEmpty else {
//                self.present(ControllerHelper.simpleAlert(message: "No favorite recipes found"), animated: true)
//                return
//            }
            
            recipes = favoriteRecipes
            tableView.reloadData()
        }
    }
    
    func setTableViewBackgroundEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor(named: "TextColor")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()

        tableView.backgroundView = messageLabel
//        tableView.separatorStyle = .none
    }

    func restoreBackground() {
        tableView.backgroundView = nil
//        tableView.separatorStyle = .singleLine
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")

        favoriteMode = navigationController!.tabBarItem.tag == TabBarItemTag.favorites.rawValue

        if favoriteMode {
            loadfavoriteRecipes()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoriteMode {
            if recipes.isEmpty {
                setTableViewBackgroundEmptyMessage("No favorites")
            } else {
                tableView.backgroundView = nil
            }
        }
        
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell

        let recipe = recipes[indexPath.row]
        let foodsString = recipe.foods.map { $0.firstUppercased }.joined(separator: ", ")
        cell.configure(imageUrl: URL(string: recipe.image)!, title: recipe.label, subtitle: foodsString)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueFromRecipesToRecipe", sender: recipes[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueFromRecipesToRecipe" {
            let recipeVC = segue.destination as! RecipeViewController
            recipeVC.recipe = sender as? Recipe
        }
    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             // Delete the row from the data source
             tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
     }
     */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

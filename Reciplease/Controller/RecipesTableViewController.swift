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

    enum RecipesTableState {
        case loading, empty, error, normal
    }

    private var state: RecipesTableState!

    private var indicator: UIActivityIndicatorView!

//    func initActivityIndicator() {
//        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        indicator.style = .medium
//        indicator.hidesWhenStopped = true
////        indicator.center = tableView.center
//        view.addSubview(indicator)
////        indicator
//    }

    func updateState(_ newState: RecipesTableState) {
        switch newState {
        case .loading:
            tableView.backgroundView = nil
            indicator.startAnimating()
        case .empty:
            indicator.stopAnimating()
            setTableViewBackgroundMessage("No favorites")
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

        print("RecipesTableViewController.loadFavoriteRecipes")
        Task {
            do {
                guard let favoriteRecipes = try await FavoriteRecipes.shared.getAll() else {
                    // Favorite recipes not ready
                    // List filling will be done on next notification reception
                    return
                }

                print("RecipesTableViewController.loadFavoriteRecipes OK")
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
        messageLabel.textColor = isError ? UIColor.red : UIColor(named: "TextColor")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()

        tableView.backgroundView = messageLabel
    }

    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")

        if isFavoriteRecipesTab {
            loadFavoriteRecipes()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("RecipesTableViewController.viewDidLoad")

//        initActivityIndicator()
        indicator = ControllerHelper.addTableViewActivityIndicator(to: tableView)

        isFavoriteRecipesTab = navigationController!.tabBarItem.tag == TabBarItemTag.favorites.rawValue

        if isFavoriteRecipesTab {
            // For remote update from firestore
            NotificationCenter.default.addObserver(self, selector: #selector(loadFavoriteRecipes), name: NSNotification.Name(rawValue: "favoriteRecipesChanged"), object: nil)

            updateState(.loading)
        } else {
            updateState(.normal)
        }
        
//        tableView.allowsSelection = false
        
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

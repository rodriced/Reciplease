//
//  RecipeInfoViewController.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 01/08/2022.
//

import UIKit

class RecipeInfoViewController: UIViewController {
    var recipe: Recipe!

    @IBOutlet weak var globalStackView: UIStackView!
    @IBOutlet weak var scoreStackView: UIStackView!
    @IBOutlet weak var durationStackView: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    static var durationFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }
    
    static var scoreFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = false
        formatter.maximumFractionDigits = 1
        return formatter
    }

    func convertToHoursMinutes(timesInMinutes: Float) -> String? {
        return Self.durationFormatter.string(from: TimeInterval(timesInMinutes * 60.0))
    }
    
    func setupHorizontalStackView(_ stackView: UIStackView) {
        let margin = 3.0
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: margin,
            leading: margin,
            bottom: margin,
            trailing: margin
        )
        stackView.isLayoutMarginsRelativeArrangement = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalStackView.layer.borderWidth = 2.0
        globalStackView.layer.borderColor = UIColor.white.cgColor
        globalStackView.layer.cornerRadius = 10.0
        
        setupHorizontalStackView(scoreStackView)
        setupHorizontalStackView(durationStackView)

        scoreLabel.text = Self.scoreFormatter.string(from: NSNumber(value: recipe.yield))
        durationLabel.text = convertToHoursMinutes(timesInMinutes: recipe.totalTime) ?? "?"
    }

    required init?(coder: NSCoder) {
        super.init(nibName: "RecipeInfoViewController", bundle: nil)
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

//
//  RecipeInfosBoxView.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 26/08/2022.
//

import SnapKit
import UIKit

class RecipeInfosBoxView: UIView {
    struct InfoContainer {
        let view: UIView
        let labelView: UILabel
        let imageView: UIImageView
        
        init() {
            view = UIView()
            
            labelView = UILabel()
            labelView.textAlignment = .center
            labelView.font = UIFont.systemFont(ofSize: 11)
            labelView.textColor = UIColor(named: "TextColor")
            
            imageView = UIImageView()
            imageView.tintColor = UIColor(named: "TextColor")
            
            view.addSubview(labelView)
            view.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(19)
                make.trailing.equalToSuperview().inset(5)
                make.top.bottom.equalToSuperview().inset(3)
                make.leading.equalTo(labelView.snp.trailing).offset(5)
            }
            
            labelView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(5)
            }
        }

        func setupWith(labelText: String, symbolName: String) {
            labelView.text = labelText
            imageView.image = UIImage(systemName: symbolName)
        }
    }
    
    static let maxNumberOfInfos = 2

    static var totalTimeFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }
    
    static var totalTimeAccessibilityFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        return formatter
    }
    
    static var yieldFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = false
        formatter.maximumFractionDigits = 1
        return formatter
    }

    static func convertToHoursMinutes(timeInMinutes: Float) -> String? {
        return totalTimeFormatter.string(from: TimeInterval(timeInMinutes * 60.0))
    }

    var stackView: UIStackView!
    var infoContainers = [InfoContainer]()
    
    var accessibilityText = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    func initUI() {
        backgroundColor = nil
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.frame = bounds
        stackView.backgroundColor = UIColor(named: "BackgroundColor")
        stackView.layer.borderWidth = 2.0
        stackView.layer.borderColor = UIColor.white.cgColor
        stackView.layer.cornerRadius = 5.0

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
//        stackView.spacing = 5
        stackView.alignment = .fill

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        for _ in 0 ... Self.maxNumberOfInfos {
            let infoContainer = InfoContainer()
            stackView.addArrangedSubview(infoContainer.view)
            infoContainers.append(infoContainer)
        }
    }
        
    func setupWithRecipe(_ recipe: Recipe) {
        stackView.arrangedSubviews.forEach { $0.isHidden = true }
        
        var accessibilityInfos = [String]()
        var infosContainersIter = infoContainers.makeIterator()
        
        // Recipe yield
        if let yeldText = Self.yieldFormatter.string(from: NSNumber(value: recipe.yield)) {
            let infoContainer = infosContainersIter.next()!
            infoContainer.setupWith(labelText: yeldText, symbolName: "person.2.fill")
            infoContainer.view.isHidden = false

            accessibilityInfos.append("yield: \(yeldText)")
        }
        
        // Recipe total tine
        if recipe.totalTime > 0, let totalTimeText = Self.totalTimeFormatter.string(from: recipe.totalTimeInterval) {
            let infoContainer = infosContainersIter.next()!
            infoContainer.setupWith(labelText: totalTimeText, symbolName: "timer")
            infoContainer.view.isHidden = false

            if let totalTimeAccessibilityText = Self.totalTimeAccessibilityFormatter.string(from: recipe.totalTimeInterval) {
                accessibilityInfos.append("total time: \(totalTimeAccessibilityText)")
            }
        }
        
        isHidden = stackView.arrangedSubviews.first!.isHidden
        accessibilityText = accessibilityInfos.joined(separator: ", ")
    }
}

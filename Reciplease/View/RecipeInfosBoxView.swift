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
            labelView.font = UIFont.systemFont(ofSize: 10)
            
            imageView = UIImageView()
            //        imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.white
            
            view.addSubview(labelView)
            view.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(15)
                make.trailing.equalToSuperview().inset(5)
                make.top.bottom.equalToSuperview().inset(5)
                make.leading.equalTo(labelView.snp.trailing).offset(10)
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
    
    static let numberOfInfosMax = 2

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

    static func convertToHoursMinutes(timeInMinutes: Float) -> String? {
        return durationFormatter.string(from: TimeInterval(timeInMinutes * 60.0))
    }

    var stackView: UIStackView!
    var infoContainers = [InfoContainer]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    func initUI() {
//        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
//        let label = UILabel()
//        label.text = "HELLO"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(label)
        
//        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

//        label.snp.makeConstraints {make in
//            make.width.equalTo(100)
//            make.height.equalTo(20)
//            make.leading.centerY.equalToSuperview()
//        }
        
        backgroundColor = nil
        
        stackView = UIStackView()
        stackView.backgroundColor = UIColor(named: "BackgroundColor")
        
        stackView.layer.borderWidth = 2.0
        stackView.layer.borderColor = UIColor.white.cgColor
        stackView.layer.cornerRadius = 5.0

        stackView.frame = bounds
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
//        stackView.spacing = 5
        stackView.alignment = .fill

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.top.leading.trailing.equalToSuperview()
        }
        
//        infoContainers = Array(repeating: InfoContainer(), count: Self.numberOfInfosMax)
//        infoContainers.forEach { stackView.addArrangedSubview($0.view) }
        for _ in 0 ... Self.numberOfInfosMax {
            let infoContainer = InfoContainer()
            stackView.addArrangedSubview(infoContainer.view)
            infoContainers.append(infoContainer)
        }
    }
        
    func setupWithRecipe(_ recipe: Recipe) {
        stackView.arrangedSubviews.forEach { $0.isHidden = true }
        var index = 0
        
        if let yeldText = Self.scoreFormatter.string(from: NSNumber(value: recipe.yield)) {
            infoContainers[index].setupWith(labelText: yeldText, symbolName: "person.2.fill")
            infoContainers[index].view.isHidden = false
            index += 1
        }
        
        if recipe.totalTime > 0, let totalTimeText = Self.convertToHoursMinutes(timeInMinutes: recipe.totalTime) {
            infoContainers[index].setupWith(labelText: totalTimeText, symbolName: "timer")
            infoContainers[index].view.isHidden = false
        }
        
        isHidden = stackView.arrangedSubviews.first!.isHidden
    }
}

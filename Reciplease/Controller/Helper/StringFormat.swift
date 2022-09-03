//
//  StringFormat.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 10/08/2022.
//


extension String {
    var firstUppercased: String {
        guard let firstLetter = first?.uppercased() else { return self }
        return firstLetter + suffix(from: index(startIndex, offsetBy: 1))
    }
}

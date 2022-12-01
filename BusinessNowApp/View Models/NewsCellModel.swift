//
//  TableViewCellModel.swift
//  BusinessNowApp
//
//  Created by Martin Tomov on 24/11/2022.
//

import Foundation

class NewsCellModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String,
         subtitle: String,
         imageURL: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

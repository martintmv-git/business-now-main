//
//  FavNewsModel.swift
//  BusinessNowApp
//
//  Created by Martin Tomov on 24/11/2022.
//

import Foundation
import RealmSwift


class FavNewsModel: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var subtitle: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var imageData: Data? = nil
    @objc dynamic var author: String = ""
    @objc dynamic var newsDate: String = ""
    @objc dynamic var newsURL: String = ""
}

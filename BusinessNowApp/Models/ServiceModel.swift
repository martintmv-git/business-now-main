//
//  ServiceModel.swift
//  BusinessNowApp
//
//  Created by Martin Tomov on 25/11/2022.
//

import Foundation

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let author: String?
}

struct Source: Codable {
    let name: String
}

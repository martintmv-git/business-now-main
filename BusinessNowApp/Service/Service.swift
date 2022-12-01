//
//  APICaller.swift
//  BusinessNowApp
//
//  Created by Martin Tomov on 25/11/2022.
//

import Foundation

final class Service {
    
    static let shared = Service()
    
    let apiKey = "&apiKey=51e997fa85c04c298cfa08a63a2977d3"
    
    
    
    struct Constants {
        static let starterURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=51e997fa85c04c298cfa08a63a2977d3")
        static let searchURLString = "https://newsapi.org/v2/everything?q="
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.starterURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
            
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.searchURLString + query + apiKey
        
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
            
        }
        task.resume()
    }
    
}

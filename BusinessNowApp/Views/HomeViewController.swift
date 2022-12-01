//
//  ViewController.swift
//  BusinessNowApp
//
//  Created by Martin Tomov on 24/11/2022.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var detailImageURL = URL(string: "")
    var detailNewsTitle = ""
    var detailNewsAuthor = ""
    var detailNewsDate = ""
    var detailNewsDesc = ""
    var detailNewsURL = ""
    
    let noImageURL: String = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png"
    
    private var articles = [Article]()
    private var viewModels = [NewsCellModel]()
    private let searchViewController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        
        title = "Latest News"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self        
        getNews()
        createSearchBar()
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchViewController
        searchViewController.searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = articles[indexPath.row]
        
        detailNewsTitle = article.title
        detailImageURL = URL(string: article.urlToImage ?? self.noImageURL)
        detailNewsDesc = article.description ?? "Not Found"
        detailNewsDate = article.publishedAt
        detailNewsAuthor = article.author ?? "Author Unknown"
        detailNewsURL = article.url!
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToDetailViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailViewController" {
            let destination = segue.destination as! DetailViewController
            destination.imageURL = detailImageURL
            destination.newsTitle = detailNewsTitle
            destination.newsDate = detailNewsDate
            destination.newsDesc = detailNewsDesc
            destination.newsAuthor = detailNewsAuthor
            destination.newsURL = detailNewsURL
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    //Get News Func
    private func getNews() {
        Service.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsCellModel(
                        title: $0.title,
                        subtitle: $0.description ?? "Not Found",
                        imageURL: URL(string: $0.urlToImage ?? self!.noImageURL)
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Search Bar Func
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        Service.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsCellModel(
                        title: $0.title,
                        subtitle: $0.description ?? "Not Found",
                        imageURL: URL(string: $0.urlToImage ?? self!.noImageURL)
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchViewController.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


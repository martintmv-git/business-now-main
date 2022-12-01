//
//  FavNewsViewController.swift
//  BusinessNowApp
//
//  Created by Martin Tomov on 24/11/2022.
//

import UIKit
import RealmSwift

class FavNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var detailImageURL = URL(string: "")
    var detailNewsTitle = ""
    var detailNewsAuthor = ""
    var detailNewsDate = ""
    var detailNewsDesc = ""
    var detailNewsURL = ""
    
    let noImageURL: String = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png"
    
    var favNewsViewModels = [FavNewsModel]()
    
    let realm = try! Realm()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(FavNewsTableViewCell.self, forCellReuseIdentifier: FavNewsTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        getFavNews()
        tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavNews()
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favNewsViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavNewsTableViewCell.identifier, for: indexPath) as? FavNewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: favNewsViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = favNewsViewModels[indexPath.row]
        detailNewsTitle = article.title
        detailImageURL = URL(string: article.imageURL)
        detailNewsDesc = article.subtitle
        detailNewsDate = article.newsDate
        detailNewsAuthor = article.author
        detailNewsURL = article.newsURL
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToDetailFromFav", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailFromFav" {
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
    
    //Get data
    private func getFavNews() {
        favNewsViewModels = [FavNewsModel]()
        let datas = realm.objects(FavNewsModel.self)
        for data in datas.reversed() {
            favNewsViewModels.append(data)
        }
    }
}


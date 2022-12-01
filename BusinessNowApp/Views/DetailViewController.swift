//
//  DetailViewController.swift
//  BusinessNowApp
//
//  Created by Martin Tomov on 24/11/2022.
//

import UIKit
import SafariServices
import RealmSwift
import Toast_Swift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var viewSourceButton: UIButton!
    
    var imageData: Data? = nil
    var imageURL = URL(string: "")
    var newsTitle = ""
    var newsAuthor = ""
    var newsDate = ""
    var newsDesc = ""
    var newsURL = ""
    
    var newFavNews = FavNewsModel()
    
    let realm = try! Realm()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)

        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let fav = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(favTapped))
        
        fav.image = UIImage(systemName: "featured")

        navigationItem.rightBarButtonItems = [fav,share]
        
        titleLabel.numberOfLines = 0
        titleLabel.font = titleLabel.font.withSize(24)
        titleLabel.text = newsTitle
        
        authorLabel.text = newsAuthor
        
        descriptionTextView.text = newsDesc
        descriptionTextView.isEditable = false
        
        dateLabel.text = String(newsDate.prefix(upTo: newsDate.index(newsDate.startIndex, offsetBy: 10)))
         
        // News Image
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: self!.imageURL!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.imageView.image = image
                            }
                        }
                    }
                }
        
        //Button Redirecting to Web Page
        viewSourceButton.setTitle("Open in Browser", for: UIControl.State.normal)
        viewSourceButton.titleLabel!.textAlignment = .center
    }
    
    @IBAction func viewNewsSourceButtonClicked(_ sender: Any) {
        guard let url = URL(string: newsURL) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    
    //Navigation Bar Buttons Funcs
    @objc func shareTapped() {
        let url = URL(string: "\(newsURL)")!


        let activityViewController =
            UIActivityViewController(activityItems: [url],
                                     applicationActivities: nil)
        
        present(activityViewController, animated: true) {}
    }
    
    @objc func favTapped() {
        newFavNews.title = newsTitle
        newFavNews.subtitle = newsDesc
        newFavNews.author = newsAuthor
        newFavNews.newsDate = newsDate
        newFavNews.newsURL = newsURL
        newFavNews.imageURL = imageURL!.absoluteString
        
        if control() {
            realm.beginWrite()
            realm.add(newFavNews)
            try! realm.commitWrite()
            createToast(message: "Added to Favorites",color: true)
        }
    }
    
    func control() -> Bool {
        let datas = realm.objects(FavNewsModel.self)
        for data in datas {
            if data.newsURL == newFavNews.newsURL {
                //Return to Prev Page When Removed From Favorite
                _ = navigationController?.popToRootViewController(animated: true)
                createToast(message: "Added to Favorites",color: false)
                try! realm.write {
                    realm.delete(data)
                }
                return false
            }
        }
        return true
    }
    
    //Toast Swift function
    func createToast(message: String, color: Bool) {
        var style = ToastStyle()
        style.backgroundColor =  color ? .black : .red
        self.view.makeToast("\(message)",position: .bottom, style: style)
    }
}

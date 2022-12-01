//
//  NewsTableViewCell.swift
//  BusinessNowApp
//
//  Created by Martin Tomov on 24/11/2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 70
        )
        
        subtitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height/2
        )
        
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure (with viewModel: NewsCellModel) {
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        // Image
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: viewModel.imageURL!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.newsImageView.image = image
                    }
                }
            }
        }
    }
    /*
    class NewsTableViewCell: UITableViewController {
        
        let cellReuseIdentifier = "ReusableTableCell"
        var tableData = [
            (title:"Example Title 1", subtitle: "Example Subtitle 1"),
        ]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tableData.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
            let row = indexPath.row
            
            cell.textLabel?.text = tableData[row].title
            cell.detailTextLabel?.text = tableData[row].subtitle
            
            return cell
        }
        
        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        
        
        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data
                tableData.remove(at: indexPath.row)
                // Delete the row from the table itself
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        
    } */
}

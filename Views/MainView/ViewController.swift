//
//  ViewController.swift
//  NewsApp
//
//  Created by Georgios Loulakis on 13/4/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var backgrounView: UIView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsTableView: UITableView!
    
    var news:[Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        
        let newsCompletionHandler = { (fetchedNews: [Article]) in
            DispatchQueue.main.sync {
                self.news = fetchedNews
                self.newsTableView.reloadData()
            }
        }
        
        let newsListQueue = DispatchQueue(label: "NewsList", attributes: .concurrent)
        
        newsListQueue.async {
            ManagerRequest.fetchNews.shared.fetchNewsInfo(onCompletion: newsCompletionHandler)
        }

    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsInfo = news[indexPath.row]
        
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCellView" , for: indexPath) as! newsCellView
        cell.newsTitle.text = newsInfo.title
        if newsInfo.urlToImage?.isEmpty == false {
            cell.newsImage.image = UIImage(named: "\(newsInfo.urlToImage)")
        } else {
            cell.newsImage.image =  UIImage(named: "defaultImage")
        }
      
        return cell
    }
    

}


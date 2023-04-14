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
        newsTableView.delegate = self
        newsTableView.separatorColor = UIColor.clear
        
        let newsCompletionHandler = { [weak self] (fetchedNews: [Article]) in
            DispatchQueue.main.async {
                self?.news = fetchedNews
                self?.newsTableView.reloadData()
            }
        }
        
        let newsListQueue = DispatchQueue(label: "NewsList", attributes: .concurrent)
        
        newsListQueue.async {
            ManagerRequest.fetchNews.shared.fetchNewsInfo(onCompletion: newsCompletionHandler)
        }
        newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCellView")
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCellView" , for: indexPath) as! NewsTableViewCell
        
        let newsInfo = news[indexPath.row]
        
        cell.titleLabel.text = newsInfo.title
        cell.authorLabel.text = newsInfo.author
        cell.publishAdLabel.text = newsInfo.publishedAt
        if let urlString = newsInfo.urlToImage, let url = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                if let dataImage = try? Data(contentsOf: url){
                    if let image = UIImage(data: dataImage){
                        DispatchQueue.main.async {
                            cell.newsImage.image = image
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsInfo = news[indexPath.row]
        let newsDetailsViewController : NewsDetailsViewController = UIStoryboard(name: "NewsDetailsView", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailsViewController") as! NewsDetailsViewController
       
        self.present(newsDetailsViewController, animated: true, completion: nil)
        newsDetailsViewController.titleLabel.text = newsInfo.title
        newsDetailsViewController.newsExternalLink = newsInfo.url ?? ""
        if let urlString = newsInfo.urlToImage, let url = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                if let dataImage = try? Data(contentsOf: url){
                    if let image = UIImage(data: dataImage){
                        DispatchQueue.main.async {
                            newsDetailsViewController.newsImage.image = image
                        }
                    }
                }
            }
        }

    }
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

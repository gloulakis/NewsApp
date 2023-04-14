//
//  ViewController.swift
//  NewsApp
//
//  Created by Georgios Loulakis on 13/4/23.
//

import UIKit
import Kingfisher


class ViewController: UIViewController {
    @IBOutlet var backgrounView: UIView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsTableView: UITableView!
    
    var news:[Article] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.separatorColor = UIColor.clear
        newsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
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
    
    @objc func refreshData(){
         newsTableView.reloadData()
         refreshControl.endRefreshing()
     }
    
}


//MARK: Table Data
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCellView" , for: indexPath) as! NewsTableViewCell
        
        let newsInfo = news[indexPath.row]
        
        cell.titleLabel.text = newsInfo.title
        cell.authorLabel.text = newsInfo.author
        cell.sourceName.text = newsInfo.source?.name ?? ""
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let publishedAtDate = dateFormatterGet.date(from: newsInfo.publishedAt ?? "") {
            cell.publishAdLabel.text = dateFormatterPrint.string(from: publishedAtDate)
        } else {
            cell.publishAdLabel.text = newsInfo.publishedAt
        }
        
        if let newsUrlString = newsInfo.urlToImage, let url = URL(string: newsUrlString) {
            cell.newsImage.kf.indicatorType = .activity
            cell.newsImage.kf.setImage(with: url, placeholder: images.DEFAULT_IMAGE, options: [.transition(.fade(0.2))], completionHandler: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    cell.newsImage.image = images.DEFAULT_IMAGE?.withRenderingMode(.alwaysOriginal)
                }
            })
        } else {
            cell.newsImage.image = images.DEFAULT_IMAGE?.withRenderingMode(.alwaysOriginal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsInfo = news[indexPath.row]
        let newsDetailsViewController : NewsDetailsViewController = UIStoryboard(name: "NewsDetailsView", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailsViewController") as! NewsDetailsViewController
        
        self.present(newsDetailsViewController, animated: true, completion: nil)
        
        newsDetailsViewController.titleLabel.text = newsInfo.title
        newsDetailsViewController.newsExternalLink = newsInfo.url ?? ""
        
        if let newsUrlString = newsInfo.urlToImage, let url = URL(string: newsUrlString) {
            newsDetailsViewController.newsImage.kf.indicatorType = .activity
            newsDetailsViewController.newsImage.kf.setImage(with: url, placeholder: images.DEFAULT_IMAGE, options: [.transition(.fade(0.2))], completionHandler: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    newsDetailsViewController.newsImage.image = images.DEFAULT_IMAGE?.withRenderingMode(.alwaysOriginal)
                }
            })
        } else {
            newsDetailsViewController.newsImage.image = images.DEFAULT_IMAGE?.withRenderingMode(.alwaysOriginal)
        }
    }
    
}

//MARK: Cell height
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//
//  NewsDetailsViewController.swift
//  NewsApp
//
//  Created by Georgios Loulakis on 14/4/23.
//

import UIKit

class NewsDetailsViewController: UIViewController {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var OpenBrowserButton: UIButton!
    @IBOutlet var newsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var newsExternalLink: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        titleView.layer.cornerRadius = 4
        titleLabel.textColor = .white
        
        OpenBrowserButton.layer.cornerRadius = 5
        OpenBrowserButton.clipsToBounds = true
        OpenBrowserButton.backgroundColor = .orange
        OpenBrowserButton.setTitle("Go to the link", for: .normal)

    }
    
    @IBAction func openBrowserButtonPressed(_ sender: Any) {
        guard let url = URL(string: "\(newsExternalLink)") else { return }
           if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
              
           }
        self.dismiss(animated: true, completion: nil)
    }
    
}

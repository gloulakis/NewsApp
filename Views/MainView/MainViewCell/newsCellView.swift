//
//  newsCellView.swift
//  NewsApp
//
//  Created by Georgios Loulakis on 13/4/23.
//

import UIKit

class newsCellView: UITableViewCell {

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsButtonNextpage: UIButton!
    @IBOutlet weak var newsImage: UIImageView!
    
    var getNewsDetails: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func detailsButtonPressed(_ sender: Any) {
        getNewsDetails?()
    }
}

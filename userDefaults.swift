//
//  userDefaults.swift
//  NewsApp
//
//  Created by Georgios Loulakis on 13/4/23.
//

import Foundation
import UIKit

let COUNTRY = "us"
private let apiKey = "4ed2a8ca15ed415c8503d611780f19b5"
let BASE_URL = "https://newsapi.org/v2/top-headlines?country=\(COUNTRY)&apiKey=\(apiKey)"

class images {
    static let DEFAULT_IMAGE = UIImage(named: "defaultImage")
}


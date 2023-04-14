//
//  ManagerRequest.swift
//  NewsApp
//
//  Created by Georgios Loulakis on 13/4/23.
//

import Foundation

class ManagerRequest {
    final class fetchNews {
        static let shared = fetchNews()
        
        func fetchNewsInfo(onCompletion: @escaping([Article]) -> Void) {
            let url = URL(string: "\(BASE_URL)")
            guard let requestUrl = url else { fatalError() }
            
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error posting person: \(error)")
                    return
                }
                guard let data = data else {
                    print("No data returned from post")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(News.self, from: data)
                        
                        print("Menu response: \(response.articles)")
                        onCompletion(response.articles)
                    } catch {
                        print("Error decoding response: \(error)")
                        return
                    }
                } else {
                    print("Error response code: \(httpResponse.statusCode)")
                }
            }
            task.resume()
        }
    }
}

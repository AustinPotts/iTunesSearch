//
//  SearchResultController.swift
//  iTunesList
//
//  Created by Austin Potts on 9/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class SearchResultController {
    let baseURL = URL(string: "https://itunes.apple.com/")!
    
    var searchResults: [SearchResult] = []
    
    func performSearch(with searchTerm:String, resultType: ResultType, completion: @escaping (Error?) -> Void) {
        
        let searchURL = baseURL.appendingPathComponent("search")
        
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        
        let parameters: [String: String] = ["term": searchTerm,
                                            "entity": resultType.rawValue]
        
        let queryItems = parameters.compactMap({ URLQueryItem(name: $0.key, value: $0.value) })
        
        components?.queryItems = queryItems
        
        
        
        guard let requestURL = components?.url else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            //The data task has gone to the API and come back with data, response and error from API
            
            //Check for an error
            if let error = error{
                NSLog("Error Searching people: \(error)")
            }
            
            //See if there is data
            guard let data = data else {
                NSLog("No data")
                completion(nil)
                return
            }
            
            //Decode the data
            do {
                let decoder = JSONDecoder()
                
                let searchResult = try decoder.decode(SearchResults.self, from: data)
                
                self.searchResults = searchResult.results
                
            } catch {
                NSLog("Error Decoding from data: \(error)")
            }
            completion(nil)
            
            }.resume()
        
    }
    
    enum HTTPMethod: String{
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
}

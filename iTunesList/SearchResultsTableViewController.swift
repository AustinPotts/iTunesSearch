//
//  iTunesTableViewController.swift
//  iTunesList
//
//  Created by Austin Potts on 9/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchResultController = SearchResultController()
    var resultType: ResultType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResultController.searchResults.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else {return UITableViewCell()}
        
        cell.searchResult = searchResultController.searchResults[indexPath.row]
        return cell
        
    }

  

}

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {return}
        var resultType: ResultType!
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            resultType = .software
        case 1:
            resultType = .musicTrack
        case 2:
            resultType = .movie
        default:
            return
            
        }
        
        
        searchResultController.performSearch(with: searchTerm, resultType: resultType, completion: { (error) in
            if let error = error {
                NSLog("\(error)")
                return
                
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
}

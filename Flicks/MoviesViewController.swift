//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Scotty's Macbook on 1/7/16.
//  Copyright © 2016 SM. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    
    var hud: MBProgressHUD?
    var refreshControl: UIRefreshControl!
    var endpoint : String!
    var hidden: Bool?
    var filteredMovies: [NSDictionary]?
    var selectedBackgroundView: UIView?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
     
        refreshControl.addTarget(self, action: "didRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        networkRequest()
        
    }
    
    @IBAction func onTap(sender: AnyObject) {searchBar.endEditing(true)
    }
    
    func didRefresh(refreshControl: UIRefreshControl) {
        networkRequest()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies!.filter({ (movie: NSDictionary) -> Bool in
                if let title = movie["title"] as? String {
                    if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                        return  true
                    } else {
                        return false
                    }
                }
                return false
            })
        }
        tableView.reloadData()

    }
    
    func networkRequest() {
        //show HUD
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            //hide HUD
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredMovies = self.movies!
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                    }
                    
                }
                
                else {
                    print("There was a network error")
                    self.errorView.hidden = false
                }
        });
        task.resume()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if let filteredMovies = filteredMovies{
            return filteredMovies.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
    
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        if let posterPath = movie["poster_path"] as? String {
        let imageUrl = NSURL(string: baseUrl + posterPath)
        cell.posterView.setImageWithURL(imageUrl!)
        }
        
        print("row \(indexPath.row)")
        return cell
        
    }
  
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
        
        
        print("prepare for segue called")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Use a red color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.grayColor()
        cell.selectedBackgroundView = backgroundView
    }

    
}

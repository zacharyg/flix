//
//  MoviesViewController.swift
//  flix-ios
//
//  Created by Zachary West Guo on 9/20/16.
//  Copyright © 2016 zechariah. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self;
        tableView.delegate = self;

        // Do any additional setup after loading the view.
        
        //Network request snippet
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)

        let session = NSURLSession(
          configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
          delegate: nil,
          delegateQueue: NSOperationQueue.mainQueue()
        )

        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
          completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
              if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    //all the gui setup is finished before network request is done.
                    self.tableView.reloadData()
              }
            }
        })
        task.resume()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)
        cell.textLabel!.text = "\(title)"
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

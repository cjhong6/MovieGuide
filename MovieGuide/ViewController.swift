//
//  ViewController.swift
//  MovieGuide
//
//  Created by Chengjiu Hong on 10/28/16.
//  Copyright © 2016 Chengjiu Hong. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import Realm


let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
let realmObject = try! Realm()

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //array of Movie object
    var movies: [Movie]? = []
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        /*write the settings object to db for persistence
        try! realmObject.write() {
            realmObject.deleteAll()
        }
        */
        
        //Pull-To-Refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)

        
        //Realm db path: DEBUG
        print(Realm.Configuration.defaultConfiguration.description)
        
        let dbMovies = realmObject.objects(Movie.self)
        if dbMovies.count > 0 {
            print("Found movies in DB")
            var newMoviesArray = [Movie]()
            for movie in dbMovies {
                print(movie.movieTitle)
                newMoviesArray.append(movie)
            }
            movies = newMoviesArray
        } else {
            //make API call and save data in the realm db
            makeAPICall()
        }
    }

    //refreshing
    func refresh(sender:AnyObject) {
        makeAPICall()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //reloadData
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return movies?.count ?? 0
    }
    
    //reloadData 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.movie = movies![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //no hightlight when selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func makeAPICall() {
        Alamofire.request("https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)",method:.get).responseJSON { response in
                if let result = response.result.value {
                let JSON = result as! NSDictionary
                    if let status_code = JSON["status_code"] as? Int{
                        print("ERROR: Unable to hit the API with status code: \(status_code)")
                        print("Got status message: \(JSON["status_message"] as! String)")
                    }
                    else{
                        print("Connection to API successful!")
                        print(JSON["results"] as Any)
                        self.movies = Movie.movies(array: (JSON["results"] as? [NSDictionary])!)
                        self.tableView.reloadData()
                        print(self.movies?.count as Any)
                    }

            }//get response

     }//end Alamofire request
    }//end makeAPICall
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        let movieDetailController = segue.destination as! MovieDetailController
        
        movieDetailController.movie = movie
    }

    
}

//
//  DetailedViewController.swift
//  WentaoXu-Lab4
//
//  Created by labuser on 10/20/18.
//  Copyright © 2018 WashU. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    
  
    @IBAction func favorite(_ sender: Any) {
        writeToPlist()
        liked.alpha=1
    }

    @IBOutlet weak var detailedimage: UIImageView!
    
    @IBOutlet weak var OverviewLabel: UILabel!
    
    @IBOutlet weak var ReleaseLabel: UILabel!
    
    @IBOutlet weak var liked: UIImageView!
    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var movietitle: UILabel!
    var poster: UIImage!
    var overview: String!
    var release_date: String!
    var rating: Double!
    var moiveTitle: String!
    var arrayOfFavorites:[String]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
      // detailedview.backgroundColor = UIColor.gray
         display()
        readFromPlist()
        if(arrayOfFavorites.contains(moiveTitle)){
            liked.alpha=1
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        print("did")
        readFromPlist()
        if(arrayOfFavorites.contains(moiveTitle)){
            liked.alpha=1
        }else{
            liked.alpha=0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        print("sup")
        readFromPlist()
        if(arrayOfFavorites.contains(moiveTitle)){
            liked.alpha=1
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func display(){
        detailedimage.image=poster
        OverviewLabel.text="Overview: "+overview
        ReleaseLabel.text="Release date: "+release_date
        RatingLabel.text="rating:\(rating*10)"
        movietitle.text=moiveTitle
        
   
    }
    func writeToPlist(){
        let path = Bundle.main.path(forResource: "MyFavorites", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)!
        let arr = dict.object(forKey: "favoriteMovies") as! NSMutableArray
        let judge = dict.object(forKey: "favoriteMovies") as! Array<String>
        if judge.contains(moiveTitle){
            return
        }
        arr.add(moiveTitle)
        dict.write(toFile:path!,atomically:true)
    }
    func readFromPlist(){
        let path = Bundle.main.path(forResource: "MyFavorites", ofType: "plist")
        let dict:AnyObject = NSDictionary(contentsOfFile: path!)!
        arrayOfFavorites = dict.object(forKey: "favoriteMovies") as! [String]
        print(arrayOfFavorites.count)
      
        


}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}

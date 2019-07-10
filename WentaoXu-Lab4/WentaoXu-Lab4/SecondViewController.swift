//
//  SecondViewController.swift
//  WentaoXu-Lab4
//
//  Created by labuser on 10/19/18.
//  Copyright © 2018 WashU. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
//    var selectedMovie:[Movie] = []
//    var selectedImage:[UIImage] = []
    var favoritemovies:[String]=[]
    var judge: Bool = true
    @IBOutlet weak var favoritetable: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritemovies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text=self.favoritemovies[indexPath.row]
       //if(favoritemovies.contains(DetailedViewControlle))
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        print("will")
        readFromPlist()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("goodby")
    }
    func setupTableView(){
    favoritetable.delegate=self
       favoritetable.dataSource=self
      //  favoritetable.register(UITableView.self, forCellReuseIdentifier: "tablecell")
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("sup?")
            self.favoritemovies.remove(at: indexPath.row)
            let path = Bundle.main.path(forResource: "MyFavorites", ofType: "plist")
            let dict:AnyObject = NSDictionary(contentsOfFile: path!)!
            let myarray = dict.object(forKey: "favoriteMovies") as! NSMutableArray
            myarray.removeObject(at: indexPath.row)
            
                dict.write(toFile:path!,atomically:true)
            self.favoritetable.reloadData()
        }
    }
   
   
 
   
    func readFromPlist(){
        let path = Bundle.main.path(forResource: "MyFavorites", ofType: "plist")
        let dict:AnyObject = NSDictionary(contentsOfFile: path!)!
        let myarray = dict.object(forKey: "favoriteMovies") as! Array<String>
        print(myarray.count)
        favoritemovies=[]
      
        for eachmoive in myarray{
                 self.favoritemovies.append(eachmoive)
           print(eachmoive)
        
        }
        
    favoritetable.reloadData()
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        readFromPlist()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


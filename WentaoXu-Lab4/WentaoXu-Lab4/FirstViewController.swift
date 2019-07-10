//
//  FirstViewController.swift
//  WentaoXu-Lab4
//
//  Created by labuser on 10/19/18.
//  Copyright © 2018 WashU. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate{
    
  
 

 
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var MovieCV: UICollectionView!
    var dataEachPage:[Movie] = []
    var theData:[Movie] = []
    var theImageCache:[UIImage] = []
    var chosenData:Movie? = nil
    var chosenImage:UIImage? = nil
    var page:Int=1
    var totapage = 6
    // var filtered:[String]=[]
   
    @IBOutlet weak var moviecount: UILabel!
    func layout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = MovieCV.bounds.width/3-15
        let height = MovieCV.bounds.height/3-3
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        layout.itemSize=CGSize(width: width, height: height)
       
        MovieCV.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view appearing")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        page = 1
        guard let text = searchBar.text else{
            return
        }
        let formattedstr = text.replacingOccurrences(of: " ", with: "%20")
        spinner.center = view.center
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        self.spinner.startAnimating()
        theData.removeAll()
        theImageCache.removeAll()
        MovieCV.reloadData()
       
        
        DispatchQueue.global().async {
            self.fetchDataforCollectionView(keyword: formattedstr)
            
            self.fetchImages()
            DispatchQueue.main.async{
                if(self.theData.count==0){
                    self.popUpNoti(title: "Oops", message: "Sorry, We didn't find what you looked for!")}
                self.MovieCV.reloadData()
                self.spinner.stopAnimating()
            }
         
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("reloading")
        self.moviecount.text = String(self.theData.count)
        return theData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! wentaoCell
       
       cell.titles.text=theData[indexPath.row].title
       cell.posters.image=theImageCache[(indexPath.row)]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        print("xixi")
        chosenData = theData[indexPath.row]
        chosenImage = theImageCache[indexPath.row]
        print("haha")
        performSegue(withIdentifier:"tomoviedetail", sender: self)
        // let detailedVC = DetailedViewController(nibName: "DetailedViewController", bundle: nil)
     //   detailedVC.poster=theImageCache[indexPath.row]
     //   detailedVC.rating=theData[indexPath.row].vote_average
     //   detailedVC.overview=theData[indexPath.row].overview
     //   detailedVC.release_date=theData[indexPath.row].release_date
   //   navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func fetchDataforCollectionView(keyword:String){
        print("fetching")
 
       while(page<totapage){
        let url = "https://api.themoviedb.org/3/search/movie?page=\(page)&api_key=e93b42ede275f6b03eb0a3d31a1f2601&query=\(keyword)"
        let MoiveUrlString:URL = URL(string: url)!
        let data = try!Data(contentsOf: MoiveUrlString)
       let JSONresult = try!JSONDecoder().decode(APIResults.self, from: data)
            self.dataEachPage=JSONresult.results
       
            for eachpage in dataEachPage{
                self.theData.append(eachpage)
            }
       
          self.page += 1
        }
        
    }
    func fetchImages(){
        
        let imagestring = "https://image.tmdb.org/t/p/original/"
        for movie in theData{
           let path = movie.poster_path
            if path == nil{
                theImageCache.append(UIImage(named: "imageNotfound")!)
            }else{
                let finalUrl = imagestring+path!
            let posterData = try? Data(contentsOf:URL(string: finalUrl as String)!)
            theImageCache.append(UIImage(data: posterData!)!)
            
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        MovieCV.dataSource = self
        MovieCV.delegate = self
        SearchBar.delegate = self
        layout()
        spinner.hidesWhenStopped = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue")
        if segue.identifier == "tomoviedetail"{
             let detailedVC = segue.destination as! DetailedViewController
                detailedVC.poster=chosenImage
                detailedVC.rating=chosenData?.vote_average
                detailedVC.overview=chosenData?.overview
                detailedVC.release_date=chosenData?.release_date
                detailedVC.moiveTitle=chosenData?.title
            print("yes")
            
        }
    }
    func popUpNoti (title:String, message:String){
        let notification = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        notification.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{(action)in notification.dismiss(animated: true, completion: nil)}))
        self.present(notification,animated: true,completion: nil)
    }

}

//class WentaoAlertController: UIAlertController {
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.view.layoutIfNeeded()
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        print(self.presentingViewController)
//        print("goodby")
//    }
//
//}


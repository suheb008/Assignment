//
//  ViewController.swift
//  Assignment
//
//  Created by Suheb Jamadar on 26/11/17.
//  Copyright © 2017 com. Assignment.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    private let myArray: NSArray = ["First","Second","Third"]
    private var myTableView: UITableView!
    
    var feedArray = Array<Any>()
    
    let screenWidth :CGFloat = UIScreen.main.bounds.width
    let cellDefaultHeight :CGFloat = 90
    
    //refresh data
    var refreshCtrl: UIRefreshControl!
    //save image in cache..
    var cache:NSCache<AnyObject,AnyObject>!
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "feedCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        refreshInit()
        self.showWaitOverlayWithText("Feed searching....")
        APIcall()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        myTableView.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
        
    }
    
    
    func refreshInit(){
        
        self.refreshCtrl = UIRefreshControl()
        self.refreshCtrl.addTarget(self, action: #selector(FeedController.refreshTableView), for: .valueChanged)
        self.myTableView.refreshControl = self.refreshCtrl
        
        self.cache = NSCache()
    }
    
    func refreshTableView() {
        APIcall()
    }
    
    func APIcall() {
        
        weak var weakRef = self
        
        Service.sharedInstance.FetchAllFeeds(requestFor:PABaseUrl, completionBlockSuccess: { (result) in
            self.removeAllOverlays()
            //Serilazation reponce into model format
            let tupleResult = Service.sharedInstance.feedResult(providedResult: result)
            
            weakRef?.feedArray = tupleResult.0!
            //If result found then display on table view
            if( (weakRef?.feedArray.count)! > 0){
                DispatchQueue.main.async {
                    weakRef?.title = tupleResult.1 //Set title on Navigation Bar
                    weakRef?.myTableView.reloadData()
                    weakRef?.refreshCtrl?.endRefreshing()
                }
            }
            
        }) { (error) in
            //handle error here....
            self.removeAllOverlays()
            DispatchQueue.main.async {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FeedCell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        if(feedArray.count > 0) {
            
            let feed :Feed = feedArray[indexPath.row] as! Feed
            
                        let titleLabel = UILabel()
                        titleLabel.frame = CGRect.init(x: 93, y: 9, width: 260 , height: 26)
                        titleLabel.text = feed.feedTitle
                        cell.addSubview(titleLabel)
            
                        let descriptionLabel = UILabel()
                        descriptionLabel.frame = CGRect.init(x: 96, y: 36, width: 257 , height: 44)
                        descriptionLabel.text = feed.description
                        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                        descriptionLabel.numberOfLines = 0
                        descriptionLabel.sizeToFit()
                        cell.addSubview(descriptionLabel)
              //cell.descriptionView.frame = CGRect.init(x: 96, y: 36, width: 236, height: 44)
            
            cell.cellConfigration(feed: feed)
            
            if (self.cache.object(forKey: feed.profileURL as AnyObject) != nil){
                
                // Use cache
                let profileImage = UIImageView()
                profileImage.frame = CGRect.init(x: 9, y: 5, width: 80, height: 80)
                profileImage.image = self.cache.object(forKey: feed.profileURL as AnyObject) as? UIImage
                cell .addSubview(profileImage)
                
            }else{
                
                let artworkUrl = feed.profileURL
                let url:URL! = URL(string: artworkUrl)
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            // Before we assign the image, check whether the current cell is visible
                            if let updateCell :FeedCell = tableView.cellForRow(at: indexPath) as?FeedCell {
                                let img:UIImage! = UIImage(data: data)
                                updateCell.profilePic?.image = img
                                
                                self.cache.setObject(img, forKey:feed.profileURL as AnyObject)
                            }
                        })
                    }
                })
                task.resume()
            }
            
            return cell
        }else {
            let titleLabel = UILabel()
            titleLabel.frame = CGRect.init(x: 93, y: 9, width: 260 , height: 26)
            titleLabel.text = "Sorry no feed found"
            cell.addSubview(titleLabel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let feed:Feed = feedArray[indexPath.row] as! Feed
        let frameS :CGRect = dynamicTextHeight(text: feed.description, font: UIFont.systemFont(ofSize: 16), width: Double(screenWidth-100))
        
        if(frameS.height+60 > cellDefaultHeight) {
            return frameS.height+60
        }else
        {
            return cellDefaultHeight
        }
    }
    
    func dynamicTextHeight(text:String,font:UIFont,width:Double)->CGRect {
        
        let myAttributes1 = [ NSFontAttributeName: font ]
        
        let attributedText = NSAttributedString(string: text, attributes: myAttributes1)
        
        var rect:CGRect
        rect = attributedText.boundingRect(with: CGSize(width: width, height: DBL_MAX), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return rect
    }
}


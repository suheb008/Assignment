//
//  FeedController.swift
//  Assignment
//
//  Created by Suheb Jamadar on 26/11/17.
//  Copyright © 2017 com. Assignment.com. All rights reserved.
//

import UIKit
 
class FeedController: UITableViewController {

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
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        refreshInit()
         self.showWaitOverlayWithText("Feed searching....")
        APIcall()
    }
    
    //Refresh Controller setup
    func refreshInit(){
        
        self.refreshCtrl = UIRefreshControl()
        self.refreshCtrl.addTarget(self, action: #selector(FeedController.refreshTableView), for: .valueChanged)
        self.refreshControl = self.refreshCtrl
        
        self.cache = NSCache()
        
    }
    
    func refreshTableView() {
     APIcall()
    }
//Fetch all post from API
    func APIcall(){
        
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
                    weakRef?.tableView.reloadData()
                    weakRef?.refreshControl?.endRefreshing()
                }
            }
            
        }) { (error) in
            //handle error here....
               self.removeAllOverlays()
             DispatchQueue.main.async {
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
         let cell : FeedCell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
   
        if(feedArray.count > 0) {
        
        let feed :Feed = feedArray[indexPath.row] as! Feed
       
            cell.cellConfigration(feed: feed)
        


        if (self.cache.object(forKey: feed.profileURL as AnyObject) != nil){
          
            // Use cache
            print("Cached image used, no need to download it")
            
            cell.profilePic?.image = self.cache.object(forKey: feed.profileURL as AnyObject) as? UIImage
       
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
            
            cell.titleLabel.text = "Sorry no feed found"
            return cell
        }
    }
    
  override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    let feed:Feed = feedArray[indexPath.row] as! Feed
    let frameS :CGRect = dynamicTextHeight(text: feed.description, font: UIFont.systemFont(ofSize: 16), width: Double(screenWidth-100))

    if(frameS.height+60 > cellDefaultHeight) {
    return frameS.height+60
    }else
    {
        return cellDefaultHeight
    }

    }
    
    //Calculate Dynamic height according to text
    func dynamicTextHeight(text:String,font:UIFont,width:Double)->CGRect {
        
        let myAttributes1 = [ NSFontAttributeName: font ]
        
        let attributedText = NSAttributedString(string: text, attributes: myAttributes1)
        
        var rect:CGRect
        rect = attributedText.boundingRect(with: CGSize(width: width, height: DBL_MAX), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return rect
        
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  Manager.swift
//  Assignment
//
//  Created by Suheb Jamadar on 28/11/17
//  Copyright © 2017 com. Assignment.com. All rights reserved.
//

import Foundation

struct Service {
    
    static let sharedInstance = Service()
     typealias JSONDictionary = [String: Any]
    
//Pull All feeds
func FetchAllFeeds(requestFor:String, completionBlockSuccess successBlock: @escaping ((_ responce:Dictionary<AnyHashable, Any>) -> Void), andFailureBlock failBlock: @escaping ((_ _errorResponce:AnyObject) -> Void)) {
   
    // Create NSURL Ibject
    let myUrl = NSURL(string: requestFor);
    if(myUrl == nil) {
        
        
         failBlock("" as AnyObject )
        return
    }
    
    // Creaste URL Request
    let request = NSMutableURLRequest(url:myUrl! as URL);
    
    // Set request HTTP method to GET. It could be POST as well
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("ext/plain", forHTTPHeaderField: "Content-Type")
    
     // Excute HTTP Request
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        DispatchQueue.main.async {
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                failBlock(error as AnyObject)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            print("Code: \(httpResponse.statusCode)")
            
            if(httpResponse.statusCode==200)
            {
                //Convert data into Json
                    do {
                                
                    let requestReply: String = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as! String
                    let responseData = requestReply.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                                
                    if  let result =  try JSONSerialization.jsonObject(with: responseData! as Data, options:[]) as? [AnyHashable: Any] {
                        
                        successBlock(result)
                        
                    }
                                  
                    
                }
                catch let error {
                    print(error.localizedDescription)
                    
                }

            }else
            {
                failBlock(error as AnyObject)
            }
        }
    }
    
    task.resume()
    
    
}

    func feedResult(providedResult:Dictionary<AnyHashable, Any>)-> (Array<Any>?,String ){
      
        var result = Array<Any>()
        var title : String = ""
        
         if ((providedResult["rows"] != nil) && (providedResult["title"] != nil ))
        {
            let resultTemp = providedResult["rows"] as! Array<Any>
            
            for dic in resultTemp {
                
                let resultDict = dic as! Dictionary<AnyHashable,Any>
                var feed = Feed()
                 feed.profileURL = resultDict["imageHref"] as? String ?? "NA"
                 feed.feedTitle =  resultDict["title"] as? String ?? "NA"
                feed.description =  resultDict["description"] as? String ?? "NA"
                
                 result.append(feed)
                
            }
             title = providedResult["title"] as! String
            return (result,title)
        }
         else {
        return (nil,"No Feed found")
        }

    }
}

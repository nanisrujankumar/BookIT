//
//  AsynchReq.swift
//
//  Created by Rahul Kumar on 8/26/16.
//  Copyright © 2016 snyxius. All rights reserved.
//

import Foundation
//import ReachabilitySwift
import CoreData

class Singleton {
	
	static let sharedInstance = Singleton()
	static var singleUserDefaults:UserDefaults?
	static var managedContext:NSManagedObjectContext?
	let baseUrl = "https://globaltalentsystems.com/api/api.php?action="
	
	fileprivate init() {}
	
	class func userDefaultsObj()->UserDefaults{
		
		if (singleUserDefaults==nil)
		{
			singleUserDefaults = UserDefaults.standard
		}
		
		return singleUserDefaults!;
	}

	/*class func getContext () -> NSManagedObjectContext {
		
		if (managedContext==nil){
			
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			if #available(iOS 10.0, *) {
				managedContext =  appDelegate.persistentContainer.viewContext
			} else {
				managedContext = appDelegate.managedObjectContext
			}
		}
		
		return managedContext!
		
	}*/
	
	func getMethod(_ requestUrl:String,params:NSDictionary){
		
		let url = URL(string: "\(baseUrl)\(requestUrl)")
		//let reachability = Reachability()!
		
		//reachability.whenReachable = { reachability in
		let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
			if error != nil{
				NotificationCenter.default.post(name: Notification.Name(rawValue: "getError"), object: nil)
				print("Error -> \(error)")
				return
			}
			
			do {
				let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
				
				NotificationCenter.default.post(name: Notification.Name(rawValue: "getSuccess"), object: result)

				print("Result -> \(result)")
				
			} catch {
				NotificationCenter.default.post(name: Notification.Name(rawValue: "getError"), object: nil)
				print("Error -> \(error)")
			}
		}) 
		
		task.resume()
		/*}
		reachability.whenUnreachable = { reachability in
			
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nonet"), object: nil)
			
		}
		
		do {
			try reachability.startNotifier()
		} catch {
			NotificationCenter.default.post(name: Notification.Name(rawValue: "postError"), object: nil)
			print("Unable to start notifier")
		}*/
		
	
	}

	func postMethod(_ requestUrl:String,params:NSDictionary){
		
		do {
			
		/*	let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
			
			let url = URL(string:"\(baseUrl)\(requestUrl)")!
			let request = NSMutableURLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData*/
			
            let post = "email=\("")&password=\("")&deviceid=\("")"

            var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
            let postLength = "\(postData?.count)"
            let url = URL(string:"https://globaltalentsystems.com/api/api.php?action=login")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData!
			
		//	let reachability = Reachability()!
			
		//	reachability.whenReachable = { reachability in

				let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
					if error != nil{
						print("Error -> \(error)")
						NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postError"), object: nil)
						return
					}
					
					do {
						let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        print("Api Call Result -> \(result)")

						if (result?["status"])! as! String == "true"{
							
							NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginApi"), object: result)
						}
                        else if (result?["status"])! as! String == "false"{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginApi"), object: result)

                        }
						
						
					} catch {
						print("Error -> \(error)")
						NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postError"), object: nil)
					}
				}
				
				task.resume()
			//}
			/*reachability.whenUnreachable = { reachability in
				
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nonet"), object: nil)

			}*/
			
			/*do {
				try reachability.startNotifier()
			} catch {
				NotificationCenter.default.post(name: Notification.Name(rawValue: "postError"), object: nil)
				print("Unable to start notifier")
			}*/

			
		} catch {
			NotificationCenter.default.post(name: Notification.Name(rawValue: "postError"), object: nil)
			print(error)
		}
	}
}

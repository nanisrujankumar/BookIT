//
//  PortfolioDetailViewController.swift
//  BookIT
//
//  Created by Sagar Babber on 3/24/17.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit
import CoreData

class PortfolioDetailViewController: UIViewController {

	//ProgressView
	var messageFrame = UIView()
	var allview = UIView()
	var activityIndicator = UIActivityIndicatorView()
	var strLabel = UILabel()
	
	@IBOutlet weak var webView: UIWebView!
	var userDefaults = SingletonClass.userDefaultsObj()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
			ApiCall()
			
			
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func menuAction(_ sender: AnyObject) {
		DispatchQueue.main.async{
			self.navigationController!.popViewController(animated: true)
		}
	}

	
	@IBAction func notificationAction(_ sender: AnyObject) {
		
		let storyboard = UIStoryboard(name:"Main", bundle:nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
		DispatchQueue.main.async {
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
	}
	
	/*
	// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	func ApiCall() {
		
		progressBarDisplayer("Processing ...", true)
        
		/*let post = "porturl=\("\(userDefaults.value(forKey: "PortFolioDownloadLink") as! String)"),token=\("\(userDefaults.value(forKey: "Device_Token") as! String)")"
		var postData = post.data(using: String.Encoding.utf8, allowLossyConversion: true)
		let postLength = "\(postData?.count)"
		
		print("Portfolio Download link dic : \(post) \n")*/
        
        
        let postData = NSMutableData(data: "token=\(userDefaults.value(forKey: "Device_Token") as! String)".data(using: String.Encoding.utf8)!)
        postData.append("&porturl=\(userDefaults.value(forKey: "PortFolioDownloadLink") as! String)".data(using: String.Encoding.utf8)!)
        
       // print("Portfolio Download link dic : \(postData) \n")
        
        let postLength = "\(postData.length)"
		
		let url = URL(string:"https://globaltalentsystems.com/api/api.php?action=portfoliolink")!
		let request = NSMutableURLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue(postLength, forHTTPHeaderField: "Content-Length")
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpBody = postData as Data
		
		let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
			if error != nil{
				DispatchQueue.main.async {
					self.allview.removeFromSuperview()
				}
				print("Error -> \(error)")
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postError"), object: nil)
				return
			}
			
			do {
				let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
				
				print("Portfolio Download API Result : \(result!) \n")
				
				if (result?["status"])! as! String == "true"{
					
					DispatchQueue.main.async {
						self.allview.removeFromSuperview()
					}
					self.webView.loadRequest(NSURLRequest(url: NSURL(string: "http://globaltalentsystems.com/temp/Adam_Lewis.pdf")! as URL) as URLRequest)
					
				}
				else if (result?["status"])! as! String == "false"{
					DispatchQueue.main.async {
						self.allview.removeFromSuperview()
                        self.view.makeToast("Download not available.  Try again shortly, if still no download please contact")
					}
                    
                    if (result?["message"])! as! String == "logged out."{
                        let alert = UIAlertController(title: "Message", message: "Session Expired", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { action in
                            
                            var count = 0
                            let context = SingletonClass.getContext()
                            // let fetchRequest: NSFetchRequest<Info> = Info.fetchRequest()
                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Jobs")
                            do {
                                let searchResults = try SingletonClass.getContext().fetch(fetchRequest)
                                
                                count = searchResults.count
                                
                                if count != 0 {
                                    
                                    for searchResults in searchResults{
                                        //let data = (searchResults as AnyObject).value(forKey: "data") as! NSData
                                        
                                        context.delete(searchResults as! NSManagedObject)
                                        do {
                                            try context.save()
                                            
                                            print("Deleted!")
                                            
                                            let single = SingletonClass.userDefaultsObj()
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            single.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                                            self.userDefaults.set("Success", forKey: "T&CStatus")
                                            DispatchQueue.main.async {
                                                
                                                // let viewControllers = self.navigationController?.viewControllers
                                                
                                                let vc = storyboard.instantiateViewController(withIdentifier: "LoginScreenViewController") as! LoginScreenViewController
                                                
                                                //  vc.homeindex = (viewControllers?.count)! - 1
                                                
                                                self.navigationController?.pushViewController(vc, animated: true)
                                                
                                            }
                                            
                                            
                                        } catch let error as NSError  {
                                            print("Could not delete. \(error), \(error.userInfo)")
                                        } catch {
                                            
                                        }
                                        
                                    }
                                    
                                }
                                else{
                                    let single = SingletonClass.userDefaultsObj()
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    single.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                                    self.userDefaults.set("Success", forKey: "T&CStatus")
                                    DispatchQueue.main.async {
                                        
                                        // let viewControllers = self.navigationController?.viewControllers
                                        
                                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginScreenViewController") as! LoginScreenViewController
                                        
                                        //  vc.homeindex = (viewControllers?.count)! - 1
                                        
                                        self.navigationController?.pushViewController(vc, animated: true)
                                        
                                    }
                                }
                                
                            } catch {
                                print("Error with request: \(error)")
                            }
                            
                            
                        }))
                        
                        DispatchQueue.main.async(execute: {
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
				}
			}
			catch {
				DispatchQueue.main.async {
					self.allview.removeFromSuperview()
				}
				print("Error -> \(error)")
			}
		}
		task.resume()
        
        
		
	}
	
	func progressBarDisplayer(_ msg:String, _ indicator:Bool ) {
		
		strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
		strLabel.text = msg
		strLabel.textColor = UIColor.white
		allview = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.bounds.width, height: self.view.bounds.height))
		allview.backgroundColor = UIColor(white: 0, alpha: 0)
		messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
		messageFrame.layer.cornerRadius = 15
		messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
		if indicator {
			activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
			activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
			activityIndicator.startAnimating()
			messageFrame.addSubview(activityIndicator)
		}
		messageFrame.addSubview(strLabel)
		allview.addSubview(messageFrame)
		view.addSubview(allview)
	}

}


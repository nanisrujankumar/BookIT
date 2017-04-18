    //
//  PortfolioViewController.swift
//  BookIT
//
//  Created by Sagar Babber on 2/28/17.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit
import CoreData

class PortfolioViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userDefaults = SingletonClass.userDefaultsObj()
    //ProgressView
    var messageFrame = UIView()
    var allview = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    var divisionNameArr = [] as NSMutableArray
    var clientNameArr = [] as NSMutableArray
    var UpdateArr = [] as NSMutableArray
    var downloadArr = [] as NSMutableArray
	
	@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ApiCall()
        // Do any additional setup after loading the view.
			
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.logout), name: NSNotification.Name(rawValue: "logout"), object: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	@IBAction func notificationActn(_ sender: AnyObject) {
		
		let storyboard = UIStoryboard(name:"Main", bundle:nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
		DispatchQueue.main.async {
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
	}
    
	@IBAction func MenuAction(_ sender: AnyObject) {
		
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        DispatchQueue.main.async{
            self.present(vc, animated: false, completion: nil)
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
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return divisionNameArr.count
	}
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		
		let identifier = "PortFolioTableViewCell"
		
		var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PortFolioTableViewCell
		
		if cell == nil {
			cell = tableView.dequeueReusableCell(withIdentifier: "td") as? PortFolioTableViewCell
		}
        cell?.divisionName.text = divisionNameArr[indexPath.row] as? String
        cell?.agentName.text = clientNameArr[indexPath.row] as? String
        cell?.updatedDate.text = UpdateArr[indexPath.row] as? String
       // cell?.agentName.text = clientNameArr[indexPath.row] as! String
        DispatchQueue.main.async {
            self.allview.removeFromSuperview()
        }
		return cell!
		
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		     self.userDefaults.set(downloadArr[indexPath.row] as! String, forKey: "PortFolioDownloadLink")
		let storyboard = UIStoryboard(name:"Main",bundle:nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "PortfolioDetailViewController") as! PortfolioDetailViewController
		DispatchQueue.main.async{
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
    func ApiCall() {
        
        progressBarDisplayer("Processing ...", true)
        
        let post = "token=\("\(userDefaults.value(forKey: "Device_Token") as! String)")"
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let postLength = "\(postData?.count)"
        
        print("PortFolio dic : \(post) \n")
        
        let url = URL(string:"https://globaltalentsystems.com/api/api.php?action=portfolios")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData!
        
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
             guard   let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject],
                
               /* print("Jobs API Result : \(result) \n")else{
                    return
                }*/
                let data = result["data"] as? [[String:Any]] else{
                    return
                }
                print("PortFolio API Result : \(result) \n")
                if (result["status"])! as! String == "true"{
                    
                   // let data = result["data"] as? [[String:Any]]
                    for i in 0 ..< data.count{
                        //print("\(key) - \(value) ")
                        self.divisionNameArr.add(data[i]["divisionname"] as! NSString)
                        self.clientNameArr.add(data[i]["clientname"] as! NSString)
                        self.UpdateArr.add(data[i]["assn_last_update"] as! NSString)
                        self.downloadArr.add(data[i]["NewUrl"] as! NSString)
                        
                    }
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                     DispatchQueue.main.async {
                    self.tableView.reloadData()
                    }
                    
                    
                }
                else if (result["status"])! as! String == "false"{
                    DispatchQueue.main.async {
                        self.allview.removeFromSuperview()
                    }
                     self.view.makeToast("Something went wrong")
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
    
    func logout(){
        
        let alert = UIAlertController(title: "Message", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { action in
            
            NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "logout"), object: nil)
            
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

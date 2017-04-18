//
//  HomeScreenViewController.swift
//  BookIT
//
//  Created by SRAVANKUMAR VEERANTI on 26/02/2017.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit
import CoreData

class HomeScreenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet var calender: FSCalendar!
	@IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    var userDefaults = SingletonClass.userDefaultsObj()
    //ProgressView
    var messageFrame = UIView()
    var allview = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    var jobIdArr = [] as NSMutableArray
    var agencyNameArr = [] as NSMutableArray
    var agencyArr = [] as NSMutableArray
    var companyIdArr = [] as NSMutableArray
    var clientNameArr = [] as NSMutableArray
    var daysArr = [] as NSMutableArray
    var StartTimeArr = [] as NSMutableArray
    var EndTimeArr = [] as NSMutableArray
    var descriptionArr = [] as NSMutableArray
    var ExpensesArr = [] as NSMutableArray
    var locationArr = [] as NSMutableArray
    var phoneArr = [] as NSMutableArray
    var productArr = [] as NSMutableArray
    var dateArr = [] as NSMutableArray
    var typeArr = [] as NSMutableArray
    var acceptArr = [] as NSMutableArray
    var acceptClick:Int = 0
    var TempjobIdArr = [] as NSMutableArray
    var TempagencyNameArr = [] as NSMutableArray
    var TempagencyArr = [] as NSMutableArray
    var TempcompanyIdArr = [] as NSMutableArray
    var TempclientNameArr = [] as NSMutableArray
    var TempdaysArr = [] as NSMutableArray
    var TempStartTimeArr = [] as NSMutableArray
    var TempEndTimeArr = [] as NSMutableArray
    var TempdescriptionArr = [] as NSMutableArray
    var TempExpensesArr = [] as NSMutableArray
    var TemplocationArr = [] as NSMutableArray
    var TempphoneArr = [] as NSMutableArray
    var TempproductArr = [] as NSMutableArray
    var TempdateArr = [] as NSMutableArray
    var TemptypeArr = [] as NSMutableArray
    var TempacceptArr = [] as NSMutableArray
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let today = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: today)
			calender.delegate = self
			calender.dataSource = self
			calender.scope = .week
            calender.scrollEnabled = false
            calender.firstWeekday = UInt(weekDay)
    
			//  calender.weekdayHeight = 20
        
            ReadCoreData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.logout), name: NSNotification.Name(rawValue: "logout"), object: nil)
        
    }
	
	func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
		self.calendarHeightConstraint.constant = bounds.height
		self.view.layoutIfNeeded()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backAction(_ sender: Any) {
			
		/*let transition = CATransition()
			transition.duration = 0.5
			transition.type = kCATransitionPush
			transition.subtype = kCATransitionFromLeft
			view.window!.layer.add(transition, forKey: kCATransition)
			present(dashboardWorkout, animated: false, completion: nil)*/
			
			let storyboard = UIStoryboard(name:"Main",bundle:nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
			DispatchQueue.main.async{
				self.present(vc, animated: false, completion: nil)
			}
			
        
    }
	@IBAction func notificationActn(_ sender: AnyObject) {
		
		let storyboard = UIStoryboard(name:"Main", bundle:nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
		DispatchQueue.main.async {
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
	}
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return TemptypeArr.count
    }
    
   /* public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let identifier = "HomeScreenTableViewCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeScreenTableViewCell
        
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeScreenTableViewCell
        }
        
        var rowheight = 207
        
        if typeArr.count > indexPath.row{
            if typeArr[indexPath.row] as? String != nil && typeArr[indexPath.row] as? String != "" {
                rowheight -= 18
            }
        }
        else{
            rowheight -= 18
        }
        
        if clientNameArr.count > indexPath.row{
            if clientNameArr[indexPath.row] as? String != nil && clientNameArr[indexPath.row] as? String != "" {
                rowheight -= 17
            }
        }
        else{
            rowheight -= 17
        }
        
        if productArr.count > indexPath.row{
            if productArr[indexPath.row] as? String != nil && productArr[indexPath.row] as? String != "" {
                rowheight -= 17
            }
        }
        else{
            rowheight -= 17
        }
        
        if daysArr.count > indexPath.row{
            if daysArr[indexPath.row] as? String != nil && daysArr[indexPath.row] as? String != "" {
                rowheight -= 17
            }
        }
        else{
            rowheight -= 17
        }
        
        if locationArr.count > indexPath.row{
            if locationArr[indexPath.row] as? String != nil && locationArr[indexPath.row] as? String != "" {
                rowheight -= 17
            }
        }
        else{
            rowheight -= 17
        }
        
        if StartTimeArr.count > indexPath.row && EndTimeArr.count > indexPath.row{
            if StartTimeArr[indexPath.row] as? String != nil && EndTimeArr[indexPath.row] as? String != nil && StartTimeArr[indexPath.row] as? String != "" && EndTimeArr[indexPath.row] as? String != ""{
                rowheight -= 17
            }
        }
        else{
            rowheight -= 17
        }
        
        if acceptArr.count > indexPath.row{
            if acceptArr[indexPath.row] as? String != nil {
                //   cell?.acceptBtn.setTitle(typeArr[indexPath.row] as? String, for: .normal)
                
                if acceptArr[indexPath.row] as? String != "no" {
                    
                    if acceptClick == 0{
                        
                    }else if acceptClick == 1{
                      //  rowheight -= 28
                    }
                }
                else{
                   // rowheight -= 28
                    
                }
                
            }
        }
        else{
           // rowheight -= 28
        }
        
        if agencyNameArr.count > indexPath.row {
            if acceptArr[indexPath.row] as? String != nil {
                
            }
            else{
               // rowheight -= 17
            }
        }
        
        
        return CGFloat(rowheight)
    }*/
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let identifier = "HomeScreenTableViewCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeScreenTableViewCell
			
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeScreenTableViewCell
        }
        
        cell?.Name.text = ""
        cell?.desc.text = ""
        cell?.product.text = ""
        cell?.days.text = ""
        cell?.place.text = ""
        cell?.time.text = ""
        cell?.acceptBtn.setTitle("", for: .normal)
        cell?.acceptBtn.isHidden = true
        cell?.agency.text = ""
        
			if TemptypeArr.count > indexPath.row{
			if TemptypeArr[indexPath.row] as? String != nil && TemptypeArr[indexPath.row] as? String != "" {
        cell?.Name.text = TemptypeArr[indexPath.row] as? String
			}
        }
            else{
              //  cell?.nameHeight.constant = 0
        }
			
			if TempclientNameArr.count > indexPath.row{
				if TempclientNameArr[indexPath.row] as? String != nil && TempclientNameArr[indexPath.row] as? String != ""{
					cell?.desc.text = TempclientNameArr[indexPath.row] as? String
				}
            }
            else{
              //  cell?.descHeight.constant = 0
        }
        
        if TempproductArr.count > indexPath.row{
            if TempproductArr[indexPath.row] as? String != nil && TempproductArr[indexPath.row] as? String != ""{
                cell?.product.text = TempproductArr[indexPath.row] as? String
            }
        }
        else{
            //  cell?.descHeight.constant = 0
        }
			
			if TempdaysArr.count > indexPath.row{
				if TempdaysArr[indexPath.row] as? String != nil && TempdaysArr[indexPath.row] as? String != "" {
					cell?.days.text = (TempdaysArr[indexPath.row] as? String)! + " days"
				}
			}
            else{
              //  cell?.daysHeight.constant = 0
        }
			
			if TemplocationArr.count > indexPath.row{
				if TemplocationArr[indexPath.row] as? String != nil  && TemplocationArr[indexPath.row] as? String != "" {
					cell?.place.text = TemplocationArr[indexPath.row] as? String
				}
			}
            else{
             //   cell?.placeHeight.constant = 0
              //  cell?.placeImageHeight.constant = 0
        }
			
			if TempStartTimeArr.count > indexPath.row && TempEndTimeArr.count > indexPath.row{
				if TempStartTimeArr[indexPath.row] as? String != nil && TempEndTimeArr[indexPath.row] as? String != nil && TempStartTimeArr[indexPath.row] as? String != "" && TempEndTimeArr[indexPath.row] as? String != ""{
					
					cell?.time.text = (TempStartTimeArr[indexPath.row] as? String)! + " - " + (TempEndTimeArr[indexPath.row] as? String)!
					
				}
			}
            else{
              //  cell?.timeHeight.constant = 0
        }
        
        if TempagencyNameArr.count > indexPath.row{
            if TempagencyNameArr[indexPath.row] as? String != nil  && TempagencyNameArr[indexPath.row] as? String != "" {
                cell?.agency.text = TempagencyNameArr[indexPath.row] as? String
            }
        }
        else{
            //   cell?.placeHeight.constant = 0
          //  cell?.placeImageHeight.constant = 0
        }
        
        if TempacceptArr.count > indexPath.row{
            if TempacceptArr[indexPath.row] as? String != nil && TempacceptArr[indexPath.row] as? String != "" {
             //   cell?.acceptBtn.setTitle(typeArr[indexPath.row] as? String, for: .normal)
                
                if TempacceptArr[indexPath.row] as? String != "no" {
                    
                    
                    if acceptClick == 0{
                        cell?.acceptBtn.isHidden = false
                        cell?.acceptBtn.setTitle("GOT IT", for: .normal)
                        cell?.acceptBtn.isEnabled = true
                    }else if acceptClick == 1{
                       // cell?.acceptBtn.isHidden = true
                       // cell?.acceptHeight.constant = 0
                        cell?.acceptBtn.isHidden = false
                        cell?.acceptBtn.setTitle("CONFIRMED", for: .normal)
                        cell?.acceptBtn.isEnabled = false
                    }

                }
                else{
                  //  cell?.acceptBtn.isHidden = true
                  //  cell?.acceptHeight.constant = 0
                    cell?.acceptBtn.isHidden = false
                    cell?.acceptBtn.setTitle("CONFIRMED", for: .normal)
                    cell?.acceptBtn.isEnabled = false
                    
                }
                
            }
        }
        else{
          //  cell?.acceptHeight.constant = 0
        }
        
        cell?.acceptBtn.tag = indexPath.row
       
        cell?.acceptBtn.addTarget(self, action:#selector(acceptClick(sender:)), for: .touchUpInside)
     
        
        cell?.acceptBtn.layer.cornerRadius = 4.0
        cell?.acceptBtn.layer.borderWidth = 1.0
        cell?.acceptBtn.layer.borderColor = UIColor.black.cgColor
    	
      /*cell!.declineBtn.layer.cornerRadius = 4.0
        cell!.declineBtn.layer.borderWidth = 1.0
        cell!.declineBtn.layer.borderColor = UIColor.black.cgColor
        cell!.declineBtn.isHidden = true*/
        
        
        return cell!
    }
	
    func acceptClick(sender: UIButton){
        let buttonTag = sender.tag
        
        let identifier = "HomeScreenTableViewCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeScreenTableViewCell
        
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "td") as? HomeScreenTableViewCell
        }

        
        progressBarDisplayer("Processing ...", true)
        
        let post = "token=\("\(userDefaults.value(forKey: "Device_Token") as! String)")&needsaccepted=\(TempacceptArr[buttonTag] as! String)"
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let postLength = "\(postData?.count)"
        
        print("Jobs dic : \(post) \n")
        
        let url = URL(string:"https://globaltalentsystems.com/api/api.php?action=jobaccept")!
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
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                
                print("Job Accept Api Result : \(result!) \n")
                
                if (result?["status"])! as! String == "true"{
                    
                    DispatchQueue.main.async {
                        self.userDefaults.set("yes", forKey: "needsaccepted")
                            self.acceptClick = 1
                            let indexPath = IndexPath(row: buttonTag, section: 0)
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                            self.allview.removeFromSuperview()
                    }
                    
                }
                else if (result?["status"])! as! String == "false"{
                    
                    DispatchQueue.main.async {
                        self.allview.removeFromSuperview()
                        self.view.makeToast("Please contact your agent, your option have changed")
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
    
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
        if TempjobIdArr.count > indexPath.row{
            if TempjobIdArr[indexPath.row] as? String != nil {
                userDefaults.set(TempjobIdArr[indexPath.row], forKey: "Job_ID")
            }
        }
        
        if TempagencyNameArr.count > indexPath.row{
            if TempagencyNameArr[indexPath.row] as? String != nil {
                userDefaults.set(TempagencyNameArr[indexPath.row], forKey: "agencyname")
            }
        }
        
        if TempagencyArr.count > indexPath.row{
            if TempagencyArr[indexPath.row] as? String != nil {
                userDefaults.set(TempagencyArr[indexPath.row], forKey: "agent")
            }
        }
        
        if TempcompanyIdArr.count > indexPath.row{
            if TempcompanyIdArr[indexPath.row] as? String != nil {
                userDefaults.set(TempcompanyIdArr[indexPath.row], forKey: "bcompanyID")
            }
        }
        
        if TempclientNameArr.count > indexPath.row{
            if TempclientNameArr[indexPath.row] as? String != nil {
                userDefaults.set(TempclientNameArr[indexPath.row], forKey: "client")
            }
        }
        
        if TempdaysArr.count > indexPath.row{
            if TempdaysArr[indexPath.row] as? String != nil {
                userDefaults.set(TempdaysArr[indexPath.row], forKey: "days")
            }
        }
        
        if TempdescriptionArr.count > indexPath.row{
            if TempdescriptionArr[indexPath.row] as? String != nil {
                userDefaults.set(TempdescriptionArr[indexPath.row], forKey: "description")
            }
        }
        
        if TempEndTimeArr.count > indexPath.row{
            if TempEndTimeArr[indexPath.row] as? String != nil {
                userDefaults.set(TempEndTimeArr[indexPath.row], forKey: "end_time")
            }
        }
        
        if TempExpensesArr.count > indexPath.row{
            if TempExpensesArr[indexPath.row] as? String != nil {
                userDefaults.set(TempExpensesArr[indexPath.row], forKey: "expensesallowed")
            }
        }
        
        if TemplocationArr.count > indexPath.row{
            if TemplocationArr[indexPath.row] as? String != nil {
                userDefaults.set(TemplocationArr[indexPath.row], forKey: "location_add")
            }
        }
        
        if TempphoneArr.count > indexPath.row{
            if TempphoneArr[indexPath.row] as? String != nil {
                userDefaults.set(TempphoneArr[indexPath.row], forKey: "phone")
            }
        }
        
        if TempproductArr.count > indexPath.row{
            if TempproductArr[indexPath.row] as? String != nil {
                userDefaults.set(TempproductArr[indexPath.row], forKey: "product")
            }
        }
        
        if TempStartTimeArr.count > indexPath.row{
            if TempStartTimeArr[indexPath.row] as? String != nil {
                userDefaults.set(TempStartTimeArr[indexPath.row], forKey: "start_time")
            }
        }
        
        if TempdateArr.count > indexPath.row{
            if TempdateArr[indexPath.row] as? String != nil {
                userDefaults.set(TempdateArr[indexPath.row], forKey: "startdate")
            }
        }
        
        if TemptypeArr.count > indexPath.row{
            if TemptypeArr[indexPath.row] as? String != nil {
                userDefaults.set(TemptypeArr[indexPath.row], forKey: "type")
            }
        }
        
        if TempacceptArr.count > indexPath.row{
            if TempacceptArr[indexPath.row] as? String != nil {
                userDefaults.set(TempacceptArr[indexPath.row], forKey: "acceptBtn")
            }
        }
        
		
		
		let storyboard = UIStoryboard(name:"Main",bundle:nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "ExpensesViewController") as! ExpensesViewController
		DispatchQueue.main.async{
			self.navigationController?.pushViewController(vc, animated: true)
	}
		
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
    
    func ReadCoreData(){
    
        var count = 0
        //let context = SingletonClass.getContext()
        // let fetchRequest: NSFetchRequest<Info> = Info.fetchRequest()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Jobs")
        do {
            let searchResults = try SingletonClass.getContext().fetch(fetchRequest)
            
            count = searchResults.count
            
            if count != 0 {
                
                for searchResults in searchResults{
                    let Nsdata = (searchResults as AnyObject).value(forKey: "data") as! NSData
                    
                    let result = try JSONSerialization.jsonObject(with: Nsdata as Data, options: []) as? [String:AnyObject]
                    
                    let data = result?["data"] as? NSArray
                    
                    print("Jobs Data Dic Retrived : \n \(data) \n")
                    
                    let copydata = result?["data"] as! NSArray
                    
                    print("copydata \(copydata)")
                    
                    if data?.count != 0 {
                        for data in data!{
							
                            if (data as! NSDictionary).value(forKey: "Job_ID") != nil
                            {
                                self.jobIdArr.add((data as! NSDictionary).value(forKey: "Job_ID") as! NSString)
                            }
                            else{
                                self.jobIdArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "agencyname") != nil
                            {
                                self.agencyNameArr.add((data as! NSDictionary).value(forKey: "agencyname") as! NSString)
                            }
                            else{
                                self.agencyNameArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "agent") != nil
                            {
                                self.agencyArr.add((data as! NSDictionary).value(forKey: "agent") as! NSString)
                            }
                            else{
                                self.agencyArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "bcompanyID") != nil
                            {
                                self.companyIdArr.add((data as! NSDictionary).value(forKey: "bcompanyID") as! NSString)
                            }
                            else{
                                self.companyIdArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "client") != nil
                            {
                                self.clientNameArr.add((data as! NSDictionary).value(forKey: "client") as! NSString)
                            }
                            else{
                                self.clientNameArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "days") != nil
                            {
                                self.daysArr.add((data as! NSDictionary).value(forKey: "days") as! NSString)
                            }
                            else{
                                self.daysArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "description") != nil
                            {
                                self.descriptionArr.add((data as! NSDictionary).value(forKey: "description") as! NSString)
                            }
                            else{
                                self.descriptionArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "start_time") != nil
                            {
                                self.StartTimeArr.add((data as! NSDictionary).value(forKey: "start_time") as! NSString)
                            }
                            else{
                                self.StartTimeArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "end_time") != nil
                            {
                                self.EndTimeArr.add((data as! NSDictionary).value(forKey: "end_time") as! NSString)
                            }
                            else{
                                self.EndTimeArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "location_add") != nil
                            {
                                self.locationArr.add((data as! NSDictionary).value(forKey: "location_add") as! NSString)
                            }
                            else{
                                self.locationArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "expensesallowed") != nil
                            {
                                self.ExpensesArr.add((data as! NSDictionary).value(forKey: "expensesallowed") as! NSString)
                            }
                            else{
                                self.ExpensesArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "phone") != nil
                            {
                                self.phoneArr.add((data as! NSDictionary).value(forKey: "phone") as! NSString)
                            }
                            else{
                                self.phoneArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "product") != nil
                            {
                                self.productArr.add((data as! NSDictionary).value(forKey: "product") as! NSString)
                            }
                            else{
                                self.productArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "startdate") != nil
                            {
                                self.dateArr.add((data as! NSDictionary).value(forKey: "startdate") as! NSString)
                            }
                            else{
                                self.dateArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "type") != nil
                            {
                                self.typeArr.add((data as! NSDictionary).value(forKey: "type") as! NSString)
                            }
                            else{
                                self.typeArr.add("")
                            }
                            
                            if (data as! NSDictionary).value(forKey: "needsaccepted") != nil
                            {
                                self.acceptArr.add((data as! NSDictionary).value(forKey: "needsaccepted") as! NSString)
                            }
                            else{
                                self.acceptArr.add("")
                            }
                            
													
                        }
                        
                        
                       /* TempjobIdArr = jobIdArr
                        TempagencyNameArr = agencyNameArr
                        TempagencyArr = agencyArr
                        TempcompanyIdArr = companyIdArr
                        TempclientNameArr = clientNameArr
                        TempdaysArr = daysArr
                        TempdescriptionArr = descriptionArr
                        TempStartTimeArr = StartTimeArr
                        TempEndTimeArr = EndTimeArr
                        TempExpensesArr = ExpensesArr
                        TemplocationArr = locationArr
                        TempphoneArr = phoneArr
                        TempproductArr = productArr
                        TempdateArr = dateArr
                        TemptypeArr = typeArr
                       // TemptypeArr.addObjects(from: [typeArr as Any])
                        TempacceptArr = acceptArr*/
                        
                        for key in 0..<typeArr.count{
                            if typeArr[key] as! String != "" {
                                TempjobIdArr.add(jobIdArr[key] as! String)
                                TempagencyNameArr.add(agencyNameArr[key] as! String)
                                TempagencyArr.add(agencyArr[key] as! String)
                                TempcompanyIdArr.add(companyIdArr[key] as! String)
                                TempclientNameArr.add(clientNameArr[key] as! String)
                                TempdaysArr.add(daysArr[key] as! String)
                                TempdescriptionArr.add(descriptionArr[key] as! String)
                                TempStartTimeArr.add(StartTimeArr[key] as! String)
                                TempEndTimeArr.add(EndTimeArr[key] as! String)
                                TempExpensesArr.add(ExpensesArr[key] as! String)
                                TemplocationArr.add(locationArr[key] as! String)
                                TempphoneArr.add(phoneArr[key] as! String)
                                TempproductArr.add(productArr[key] as! String)
                                TempdateArr.add(dateArr[key] as! String)
                                TemptypeArr.add(typeArr[key] as! String)
                                TempacceptArr.add(acceptArr[key] as! String)
                              //  TemptypeArr.add(typeArr[key] as! String)
                            }
                        }
                        
                        
                        tableView.delegate = self
                        tableView.dataSource = self
                        tableView.reloadData()
                        
                    }
                    else if data?.count != 0{
                        self.view.makeToast("No Jobs Found")
                    }
                     
                }
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
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
    
    
    
    func ApiCall() {
        
          progressBarDisplayer("Processing ...", true)
        
        let post = "token=\("\(userDefaults.value(forKey: "Device_Token") as! String)")"
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let postLength = "\(postData?.count)"
        
        print("Jobs dic : \(post) \n")
        
        let url = URL(string:"https://globaltalentsystems.com/api/api.php?action=jobs")!
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
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                
                print("Jobs API Result : \(result!) \n")
                
                if (result?["status"])! as! String == "true"{
                    
                    
                    let context = SingletonClass.getContext()
                    let entity =  NSEntityDescription.entity(forEntityName: "Jobs", in: context)
                    
                    let transc = NSManagedObject(entity: entity!, insertInto: context)
                    transc.setValue(data!, forKey: "data")
                    
                    do {
                        try context.save()
                        
                        print("Jobs Data saved! \n")
                        
                        DispatchQueue.main.async {
                               self.allview.removeFromSuperview()
                        }
                        
                        self.ReadCoreData()
                        
                    } catch let error as NSError  {
                        DispatchQueue.main.async {
                            self.allview.removeFromSuperview()
                        }
                        print("Could not save \(error), \(error.userInfo)")
                    } catch {
                        DispatchQueue.main.async {
                            self.allview.removeFromSuperview()
                        }
                        
                    }
                    
                }
                else if (result?["status"])! as! String == "false"{
                    DispatchQueue.main.async {
                        self.allview.removeFromSuperview()
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
    
}
		


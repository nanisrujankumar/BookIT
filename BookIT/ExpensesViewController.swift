//
//  ExpensesViewController.swift
//  BookIT
//
//  Created by Sagar Babber on 3/24/17.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

class ExpensesViewController: UIViewController {

	@IBOutlet weak var type: UILabel!
	@IBOutlet weak var client: UILabel!
	@IBOutlet weak var product: UILabel!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var time: UILabel!
	@IBOutlet weak var days: UILabel!
	@IBOutlet weak var location: UILabel!
    @IBOutlet var mapView: GMSMapView!
	@IBOutlet weak var notes: UILabel!
	@IBOutlet weak var gotItBtn: UIButton!
	@IBOutlet weak var addExpensesBtn: UIButton!
	@IBOutlet weak var agency: UILabel!
	@IBOutlet weak var agencyName: UILabel!
    
    var messageFrame = UIView()
    var allview = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
	
    var userDefaults = SingletonClass.userDefaultsObj()
    
    var job_id_str = String()
    var agencyName_str = String()
    var agent_str = String()
    var companyId_str = String()
    var clientName_str = String()
    var days_str = String()
    var description_str = String()
    var endtime_str = String()
    var expenses_str = String()
    var location_str = String()
    var phone_str = String()
    var product_str = String()
    var startTime_str = String()
    var date_str = Double()
    var type_str = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addExpensesBtn.isHidden = true
        agencyName.text = ""
        agency.text = ""
        client.text = ""
        days.text = ""
        notes.text = ""
        type.text = ""
        date.text = ""
        time.text = ""
        location.text = ""
        
        
        
        gotItBtn.layer.cornerRadius = 4.0
        gotItBtn.layer.borderWidth = 1.0
        gotItBtn.layer.borderColor = UIColor.black.cgColor
        
        addExpensesBtn.layer.cornerRadius = 4.0
        addExpensesBtn.layer.borderWidth = 1.0
        addExpensesBtn.layer.borderColor = UIColor.black.cgColor
        
        if userDefaults.value(forKey: "Job_ID") as? String != nil{
            job_id_str = userDefaults.value(forKey: "Job_ID") as! String
           // userDefaults.set("", forKey: "Job_ID")
        }
        
        if userDefaults.value(forKey: "agencyname") as? String != nil{
           agencyName_str = userDefaults.value(forKey: "agencyname") as! String
            userDefaults.set("", forKey: "agencyname")
            agencyName.text = agencyName_str
        }
        
        if userDefaults.value(forKey: "agent") as? String != nil{
            agent_str = userDefaults.value(forKey: "agent") as! String
            userDefaults.set("", forKey: "agent")
            agency.text = agent_str
        }
        
        if userDefaults.value(forKey: "bcompanyID") as? String != nil{
            companyId_str = userDefaults.value(forKey: "bcompanyID") as! String
            //userDefaults.set("", forKey: "bcompanyID")
        }
        
        if userDefaults.value(forKey: "client") as? String != nil{
           clientName_str = userDefaults.value(forKey: "client") as! String
            userDefaults.set("", forKey: "client")
            client.text = clientName_str
        }
        
        if userDefaults.value(forKey: "days") as? String != nil{
           days_str = userDefaults.value(forKey: "days") as! String
            userDefaults.set("", forKey: "days")
            days.text = days_str
        }
        
        if userDefaults.value(forKey: "description") as? String != nil{
          description_str = userDefaults.value(forKey: "description") as! String
            userDefaults.set("", forKey: "description")
            
        }
        
        if userDefaults.value(forKey: "end_time") as? String != nil{
            endtime_str = userDefaults.value(forKey: "end_time") as! String
            userDefaults.set("", forKey: "end_time")
        }
        
        if userDefaults.value(forKey: "expensesallowed") as? String != nil{
           expenses_str = userDefaults.value(forKey: "expensesallowed") as! String
            userDefaults.set("", forKey: "expensesallowed")
            if expenses_str == "yes" {
                addExpensesBtn.isHidden = false
            }else{
                addExpensesBtn.isHidden = true
            }
        }
        
        if userDefaults.value(forKey: "location_add") as? String != nil{
           location_str = userDefaults.value(forKey: "location_add") as! String
            userDefaults.set("", forKey: "location_add")
            location.text = location_str
        }
        
        if userDefaults.value(forKey: "phone") as? String != nil{
           phone_str = userDefaults.value(forKey: "phone") as! String
            userDefaults.set("", forKey: "phone")
            notes.text = phone_str
        }
        
        if userDefaults.value(forKey: "product") as? String != nil{
          product_str = userDefaults.value(forKey: "product") as! String
            userDefaults.set("", forKey: "product")
        }
        
        if userDefaults.value(forKey: "start_time") as? String != nil{
           startTime_str = userDefaults.value(forKey: "start_time") as! String
            userDefaults.set("", forKey: "start_time")
            time.text = startTime_str + " - " + endtime_str
        }
        
        if userDefaults.value(forKey: "startdate") as? String != nil{
            date_str = (userDefaults.value(forKey: "startdate") as! NSString).doubleValue
            //userDefaults.set("", forKey: "startdate")
            let date1 = Date(timeIntervalSince1970: date_str as TimeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd-MM-yyyy" //Specify your format that you want
            let strDate = dateFormatter.string(from: date1)
            print("date \(strDate)")
            date.text = strDate
        }
        
        if userDefaults.value(forKey: "type") as? String != nil{
          type_str = userDefaults.value(forKey: "type") as! String
            userDefaults.set("", forKey: "type")
            type.text = type_str
        }
        if userDefaults.value(forKey: "needsaccepted") as? String == "yes"{
            gotItBtn.setTitle("CONFIRMED", for: .normal)
            gotItBtn.isEnabled = false
        }else{
            gotItBtn.setTitle("GOT IT", for: .normal)
            gotItBtn.isEnabled = true
        }
        
        if userDefaults.value(forKey: "acceptBtn") as? String == "no"{
            gotItBtn.isHidden = false
            gotItBtn.setTitle("CONFIRMED", for: .normal)
            gotItBtn.isEnabled = false
        }else{
            gotItBtn.isHidden = false
            gotItBtn.setTitle("GOT IT", for: .normal)
            gotItBtn.isEnabled = true
        }
        
        
       // let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
       // let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
       // view = mapView
        
        // Creates a marker in the center of the map.
        
      //  let address = "500 S. Buena Vista Street Room 8006"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location_str, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error!)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                print("lat", coordinates.latitude)
                print("long", coordinates.longitude)
                
                let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude,
                                                                  longitude: coordinates.longitude, zoom: 10)
                self.mapView.camera = camera
                self.mapView.isMyLocationEnabled = true
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                //marker.title = "Sydney"
                //marker.snippet = "Australia"
                marker.map = self.mapView
                
                
            }
        })
        
        
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

	@IBAction func gotItActn(_ sender: AnyObject) {
        
        progressBarDisplayer("Processing ...", true)
        
        let post = "token=\("\(userDefaults.value(forKey: "Device_Token") as! String)")&needsaccepted=\("\(userDefaults.value(forKey: "acceptBtn") as! String)")"
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
                        self.allview.removeFromSuperview()
                    }
                    self.gotItBtn.setTitle("GOT IT", for: .normal)
                    self.gotItBtn.isEnabled = false
                    
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
    
    @IBAction func backActn(_ sender: Any) {
        DispatchQueue.main.async{
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    @IBAction func notificationActn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
	
	@IBAction func expensesActn(_ sender: AnyObject) {
		
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddExpenseViewController") as! AddExpenseViewController
        DispatchQueue.main.async {
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
	
	
}

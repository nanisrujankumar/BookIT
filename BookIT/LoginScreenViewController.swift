//
//  LoginScreenViewController.swift
//  BookIT
//
//  Created by Sagar Babber on 2/24/17.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit
import Toast_Swift
import CoreData

class LoginScreenViewController: UIViewController,UITextFieldDelegate {
	@IBOutlet weak var borderView: UIView!
	@IBOutlet weak var emailText: UITextField!
	@IBOutlet weak var passText: UITextField!
    var messageFrame = UIView()
    var allview = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
	var userDefaults = SingletonClass.userDefaultsObj()
    var officeNameArr = [] as NSMutableArray
    var officeIdArr = [] as NSMutableArray
    var modelIdArr = [] as NSMutableArray

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
			emailText.delegate = self
			passText.delegate = self
            emailText.text = ""
            passText.text = ""
			borderView.layer.borderWidth = 1.0
			borderView.layer.borderColor = UIColor.black.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
      /*  var count = 0
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
                    } catch let error as NSError  {
                        print("Could not delete. \(error), \(error.userInfo)")
                    } catch {
                        
                    }
                    
                }
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }*/

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
//        if textField == emailText {
//            passText.becomeFirstResponder()
//        }
        return true
    }
    
    
	@IBAction func loginAction(_ sender: AnyObject){
        
        emailText.resignFirstResponder()
        passText.resignFirstResponder()
        
        let device_id = UIDevice.current.identifierForVendor?.uuidString
        print("device : \(device_id!) \n")
        if emailText.text! != "" {
            
					 if passText.text! != "" {
                        
                        
                        let bool = isValidEmail(testStr: emailText.text!)
                        
                        if bool == true {

                            progressBarDisplayer("Processing ...", true)
                            
                            
                            let post = "email=\(emailText.text!)&password=\(passText.text!)&deviceid=\(device_id!)"
                            var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
                            let postLength = "\(postData?.count)"
                            print("Login dic : \(post) \n")
                            
                            
                            let url = URL(string:"https://globaltalentsystems.com/api/api.php?action=login")!
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
                                    
                                    print("Login API Result : \(result!) \n")
                                    
                                    if (result?["status"])! as! String == "true"{
                                        
                                        let data = result?["officeIDs"] as? NSArray
                                        
                                        if data?.count != 0 {
                                            for data in data!{
                                                
                                                self.officeIdArr.add(data)
                                                
                                            }
                                        }
                                        
                                        let data1 = result?["officenames"] as? NSArray
                                        
                                        if data1?.count != 0 {
                                            for data1 in data1!{
                                                
                                                self.officeNameArr.add(data1)
                                                
                                            }
                                        }
                                        
                                        let data2 = result?["modelIDs"] as? NSArray
                                        
                                        if data2?.count != 0 {
                                            for data2 in data2!{
                                                
                                                self.modelIdArr.add(data2)
                                                
                                            }
                                        }
                                        
                                        let token = (result?["token"])! as! String
                                        let firstName = (result?["firstname"])! as! String
                                        
                                        self.userDefaults.set("Success", forKey: "LoginStatus")
                                        self.userDefaults.set("\(token)", forKey: "Device_Token")
                                        self.userDefaults.set("\(firstName)", forKey: "firstname")
                                        self.userDefaults.set(self.emailText.text, forKey: "emailid")
                                        self.userDefaults.set(self.officeIdArr, forKey: "OfficeIdArr")
                                        self.userDefaults.set(self.officeNameArr, forKey: "OfficeNameArr")
                                        self.userDefaults.set(self.modelIdArr, forKey: "ModelIdArr")
                                        
                                     /*   DispatchQueue.main.async {
                                            self.allview.removeFromSuperview()
                                        }*/
                                        
                                        self.ApiCall()
                                        
                                        
                                        
                                        
                                    }
                                    else if (result?["status"])! as! String == "false"{
                                        DispatchQueue.main.async {
                                            self.allview.removeFromSuperview()
                                        }
                                        self.view.makeToast("Invalid email or password")
                                        
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
                        else{
                            self.view.makeToast("Invalid email format")
                        }
                
							 }
					else
					{
							self.view.makeToast("Please enter password")
					}
					
        }
				else{
					self.view.makeToast("Please enter email-id")
					
		}
		
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
	@IBAction func forgotAction(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotScreenViewController") as! ForgotScreenViewController
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
    
    func ApiCall() {
        
      //  progressBarDisplayer("Processing ...", true)
        
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
                         //   self.allview.removeFromSuperview()
                        }
                        
                        if self.userDefaults.value(forKey: "T&CStatus") as? String != nil {
                            
                            let storyboard = UIStoryboard(name:"Main",bundle:nil)
                            let  vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
                            DispatchQueue.main.async{
                                
                                self.allview.removeFromSuperview()
                                self.navigationController?.pushViewController(vc, animated: true)
                        }
                        }
                        else{
                            let storyboard = UIStoryboard(name:"Main",bundle:nil)
                            let  vc = storyboard.instantiateViewController(withIdentifier: "TermsAndCondViewController") as! TermsAndCondViewController
                            DispatchQueue.main.async{
                                
                                self.allview.removeFromSuperview()
                                self.navigationController?.pushViewController(vc, animated: true)
                        }
                           
                        }
                        
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
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 100
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height - 100
            }
        }
    }

}

//
//  MyProfileViewController.swift
//  BookIT
//
//  Created by SRAVANKUMAR VEERANTI on 25/02/2017.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit
import CoreData

class MyProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var scrollView: UIScrollView!
	@IBOutlet weak var oldPassText: UITextField!
	@IBOutlet weak var newPassText: UITextField!
    @IBOutlet var profileImage: UIImageView!
    let imagePickerController = UIImagePickerController()
    //ProgressView
    var messageFrame = UIView()
    var allview = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    var userDefaults = SingletonClass.userDefaultsObj()
        
    var selectedImage:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
			oldPassText.delegate = self
			newPassText.delegate = self
			oldPassText.text = ""
			newPassText.text = ""
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.logout), name: NSNotification.Name(rawValue: "logout"), object: nil)

        
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
//        if textField == oldPassText {
//            newPassText.becomeFirstResponder()
//        }
		return true
	}
	
    @IBAction func backAction(_ sender: Any) {
			let storyboard = UIStoryboard(name:"Main",bundle:nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        vc.newImage = selectedImage
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
	
	@IBAction func PicActn(_ sender: AnyObject) {
		
        
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(imagePickerController, animated: true, completion: nil)
		
	}
	

	@IBAction func update(_ sender: AnyObject) {
	
        if oldPassText.text! != "" {
            
            if newPassText.text! != "" {
                
                progressBarDisplayer("Processing ...", true)
                
                
                let post = "oldpassword=\(oldPassText.text!)&newpassword=\(newPassText.text!)&token=\("\(userDefaults.value(forKey: "Device_Token") as! String)")"
                var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
                let postLength = "\(postData?.count)"
                print("ChangePassword dic : \(post) \n")
                
                
                let url = URL(string:"https://globaltalentsystems.com/api/api.php?action=changepassword")!
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
                        
                        print("ChangePassword API Result : \(result!) \n")
                        
                        if (result?["status"])! as! String == "true"{
                            
                            
                            DispatchQueue.main.async {
                                self.allview.removeFromSuperview()
                            }
                            
                            self.view.makeToast("Password changed successfully")
                            
                        }
                        else if (result?["status"])! as! String == "false"{
                            DispatchQueue.main.async {
                                self.allview.removeFromSuperview()
                            }
                            self.view.makeToast("Password doesn't match")
                            
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
            else
            {
                self.view.makeToast("Please enter new password")
            }
            
        }
        else{
            self.view.makeToast("Please enter old password")
            
        }

        
	}
    
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        profileImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
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
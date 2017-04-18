//
//  AddExpenseViewController.swift
//  BookIT
//
//  Created by SRAVANKUMAR VEERANTI on 30/03/2017.
//  Copyright © 2017 SRUJAN KUMAR. All rights reserved.
//

import UIKit
import DatePickerDialog
import Toast_Swift
import CoreData

class AddExpenseViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var ExpenseType: UIButton!
    @IBOutlet var offceName: UIButton!
    @IBOutlet var expenseAMNT: UITextField!
    @IBOutlet var expenseDate: UIButton!
    @IBOutlet var ExpenceImage: UIImageView!
    @IBOutlet var pickerOuView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var pickerDone: UIButton!
    var typevalue:Int = 0
    var officeNamevalue:Int = 0
    var pickerValue:Int = 0
    var modelIdName:Int = 0
    var officeNameArr = [] as NSMutableArray
    var modelIdArr = [] as NSMutableArray
    
    let imagePickerController = UIImagePickerController()
    var userDefaults = SingletonClass.userDefaultsObj()
    var expenseTypeArr = [] as NSMutableArray

    //ProgressView
    var messageFrame = UIView()
    var allview = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    var selectedImage:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        expenseAMNT.delegate = self
        self.pickerOuView.isHidden = true
        officeNameArr = userDefaults.value(forKey: "OfficeNameArr") as! NSMutableArray
        modelIdArr = userDefaults.value(forKey: "ModelIdArr"
        ) as! NSMutableArray
        ApiCall()
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        ExpenceImage.layer.masksToBounds = false
        ExpenceImage.layer.cornerRadius = ExpenceImage.frame.size.width/2
        ExpenceImage.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
    
    @IBAction func ExpenseTypeActn(_ sender: Any) {
        
        pickerValue = 1
        pickerOuView.isHidden = false
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    @IBAction func offceNmeActn(_ sender: Any) {
        
        pickerValue = 2
        pickerOuView.isHidden = false
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    @IBAction func DateActn(_ sender: Any) {
        
        DatePickerDialog().show(title: "Select Expense Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            let formatter = DateFormatter()
           // formatter.dateStyle = .full
            formatter.dateFormat = "dd/MM/yyyy"
            if date != nil{
                //self.waketime.text = formatter.string(from: date!)
                
                self.expenseDate.setTitle(formatter.string(from: date!), for: .normal)
                self.expenseDate.setTitleColor(UIColor.black, for: .normal)
            }
            
        }
        
    }
    
    @IBAction func pickerDoneActn(_ sender: Any) {
        
        
        pickerOuView.isHidden = true
        if pickerValue == 1 {
        
            ExpenseType.setTitle(expenseTypeArr[typevalue] as? String, for: .normal)
            pickerValue = 0
            typevalue = 0
        }
        else if pickerValue == 2{
            offceName.setTitle(officeNameArr[officeNamevalue] as? String, for: .normal)
            modelIdName = officeNamevalue
            pickerValue = 0
            officeNamevalue = 0
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func SubmitActn(_ sender: Any) {
        
        if selectedImage != nil && ExpenseType.title(for: .normal) != "Select Expense Type" && offceName.title(for: .normal) != "Select Office Name" && expenseAMNT.text! != "" && expenseDate.title(for: .normal) != "Select Date" {
            
            SubmitApiCall()
            
        }
        else{
            
            if selectedImage == nil{
                self.view.makeToast("Please upload expense photo")
                return
            }
            
            if ExpenseType.title(for: .normal) == "Select Expense Type"{
                self.view.makeToast("Please Select Expense Type")
                return
            }
            
            if offceName.title(for: .normal) == "Select Office Name"{
               self.view.makeToast("Please Select Office Name")
                return
            }
            
            if expenseAMNT.text! == ""{
                self.view.makeToast("Please Enter Expense Amount")
                return
            }
            
            if expenseDate.title(for: .normal) == "Select Date"{
                self.view.makeToast("Please Select Expense Date")
                return
            }
            
        }
        
    }
    
    @IBAction func expenseImageActn(_ sender: Any) {
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        self.present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //imageApiCall(selectedImage!)
        // Set photoImageView to display the selected image.
        ExpenceImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    func ApiCall() {
        
        progressBarDisplayer("Processing ...", true)
        
        let post = "token=\("\(userDefaults.value(forKey: "Device_Token") as! String)")&bcompanyID=\("\(userDefaults.value(forKey: "bcompanyID") as! String)")"
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let postLength = "\(postData?.count)"
        
        print("ExpenseType dic : \(post) \n")
        
        let url = URL(string:"https://globaltalentsystems.com/api/api.php?action=expensetypes")!
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
                
                print("ExpenseType API Result : \(result!) \n")
                
                if (result?["status"])! as! String == "true"{
                    
                    DispatchQueue.main.async {
                        self.allview.removeFromSuperview()
                    }
                    
                    let data = result?["data"] as? NSArray
                    
                    if data?.count != 0 {
                        
                        for data in data!{
                            
                            let str = data as! NSString
                            
                            if str != ""{
                                self.expenseTypeArr.add(data)
                            }
                            
                            
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
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerValue == 1 {
            return expenseTypeArr.count
        }
        else if pickerValue == 2{
           return officeNameArr.count
        }
        else{
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerValue == 1 {
            return (expenseTypeArr[row] as! NSString) as String
        }
        else if pickerValue == 2{
            return (officeNameArr[row] as! NSString) as String
        }
        else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerValue == 1 {
          typevalue = row
        }
        else if pickerValue == 2{
            officeNamevalue = row
        }
        else{
            
        }
        
        
    }
    
    func SubmitApiCall(){
        
        progressBarDisplayer("Processing ...", true)
        
        let boundary = "------VohpleBoundary4QuqLuM1cE5lMwCy"
        
        let parameters :NSDictionary = ["token":userDefaults.value(forKey: "Device_Token") as! String,"bcompanyID":userDefaults.value(forKey: "bcompanyID") as! String,"ExpenseType":ExpenseType.title(for: .normal)!,"ExpenseAmount":expenseAMNT.text!,"ExpenseDate":expenseDate.title(for: .normal)!,"JobID":userDefaults.value(forKey: "Job_ID") as! String,"JobDate":userDefaults.value(forKey: "startdate") as! String,"modelcode":modelIdArr[modelIdName]]
        
        print("Save Expense Dict : \(parameters) \n")
        
        modelIdName = 0
        
        let body = NSMutableData()
        
          for (key, value) in parameters {
         body.appendString(string: "--\(boundary)\r\n")
         body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
         body.appendString(string: "\(value)\r\n")
         }
         
         body.appendString(string: "--\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = "image.jpg"
        
        let filePathKey = "ExpenseReceipt[image]"
        
        let imageData = UIImageJPEGRepresentation(selectedImage!, 1)
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        let postLength = "\(body.length)"
        
        let url = URL(string:"https://globaltalentsystems.com/api/api.php?action=expense")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("multipart/form-data; boundary=------VohpleBoundary4QuqLuM1cE5lMwCy", forHTTPHeaderField: "Content-Type")
        request.httpBody = body as Data
        
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
                
                print("Save Expense API Result : \(result!) \n")
                
                if (result?["status"])! as! String == "true"{
                    
                    DispatchQueue.main.async {
                        self.selectedImage = nil
                        self.ExpenceImage.image = UIImage(named:"user")
                        self.ExpenseType.setTitle("Select Expense Type", for: .normal)
                        self.offceName.setTitle("Select Office Name", for: .normal)
                        self.expenseAMNT.text = ""
                        self.expenseDate.setTitle("Select Date", for: .normal)
                        self.allview.removeFromSuperview()
                        self.view.makeToast("Expenses Saved Successfully")
                    }
                    
                }
                else if (result?["status"])! as! String == "false"{
                    
                    DispatchQueue.main.async {
                        self.selectedImage = nil
                        self.ExpenseType.setTitle("Select Expense Type", for: .normal)
                        self.offceName.setTitle("Select Office Name", for: .normal)
                        self.expenseAMNT.text = ""
                        self.expenseDate.setTitle("Select Date", for: .normal)
                        self.ExpenceImage.image = UIImage(named:"user")
                        self.allview.removeFromSuperview()
                        self.view.makeToast("No expense saved")
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
                    self.view.makeToast("Something went wrong .. Try Again")
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

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

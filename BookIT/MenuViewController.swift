//
//  MenuViewController.swift
//  BookIT
//
//  Created by Sagar Babber on 3/1/17.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var SideView: UIView!
    @IBOutlet var profileImage: UIImageView!
    var nameArr = [String]()
    var imageArr = [String]()
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    var userDefaults = SingletonClass.userDefaultsObj()
    var tableData:[Chat] = []
    var newImage: UIImage? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
				self.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
			tableView.dataSource = self
			tableView.delegate = self
        
        name.text =  userDefaults.value(forKey: "firstname") as! String?
        email.text =  userDefaults.value(forKey: "emailid") as! String?
        
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.SideView.addGestureRecognizer(gestureSwift2AndHigher)
        nameArr = ["Jobs / Go See","Skills","Portfolios","Messages","Terms & Conditons","Feedback","Rating","logout"]
        
        imageArr = ["drawer_03","drawer_06","drawer_08","drawer_11","drawer_15","drawer_19","drawer_23","drawer_19"]
        
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        if newImage != nil {
            profileImage.image = newImage!
        }
			
    }
    
    func sendText(image:UIImage) {
        
        print("Menu View Controller Called")
        
        DispatchQueue.main.async {
          self.profileImage.image = image  
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func someAction(_ sender:UITapGestureRecognizer){
		// do other task
		self.dismiss(animated: false, completion: nil)
	}
	
	@IBAction func picActn(_ sender: AnyObject) {
		
		let storyboard = UIStoryboard(name:"Main",bundle:nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
		let navController = UINavigationController.init(rootViewController: vc)
		navController.isNavigationBarHidden = true
		self.present(navController, animated: false, completion: nil)
		
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
		return nameArr.count
	}
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		
		let identifier = "MenuTableViewCell"
		
		var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MenuTableViewCell
		
		if cell == nil {
			cell = tableView.dequeueReusableCell(withIdentifier: "td") as? MenuTableViewCell
		}
        
        cell?.Name.text = nameArr[indexPath.row]
        cell?.menuImage.image = UIImage(named:imageArr[indexPath.row])
		
		return cell!
		
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		let storyboard = UIStoryboard(name:"Main",bundle:nil)

		if indexPath.row == 0 {
			
			let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
			let navController = UINavigationController.init(rootViewController: vc)
			navController.isNavigationBarHidden = true
			self.present(navController, animated: false, completion: nil)
			
		}
		else if indexPath.row == 1 {
			
			let vc = storyboard.instantiateViewController(withIdentifier: "SkillsViewController") as! SkillsViewController
			let navController = UINavigationController.init(rootViewController: vc)
			navController.isNavigationBarHidden = true
			self.present(navController, animated: false, completion: nil)
			
		}
		else if indexPath.row == 2 {
			
			let vc = storyboard.instantiateViewController(withIdentifier: "PortfolioViewController") as! PortfolioViewController
			let navController = UINavigationController.init(rootViewController: vc)
			navController.isNavigationBarHidden = true
			self.present(navController, animated: false, completion: nil)
			
		}
		else if indexPath.row == 3 {
			
            let contact = Contact()
            contact.name = "Player 1"
            contact.identifier = "12345"
            
            let chat = Chat()
            chat.contact = contact
            
            let texts:[String] = []
            
            var lastMessage:Message!
            for text in texts {
                let message = Message()
                message.text = text
                message.sender = .Someone
                message.status = .Received
                message.chatId = chat.identifier
                
                LocalStorage.sharedInstance.storeMessage(message: message)
                lastMessage = message
            }
            
            chat.numberOfUnreadMessages = texts.count
            chat.lastMessage = lastMessage
            
            self.tableData.append(chat)
            
			let vc = storyboard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
			let navController = UINavigationController.init(rootViewController: vc)
			navController.isNavigationBarHidden = true
            vc.chat = tableData[0]
			self.present(navController, animated: false, completion: nil)
        
        }
		else if indexPath.row == 4 {
			
			let vc = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
			let navController = UINavigationController.init(rootViewController: vc)
			navController.isNavigationBarHidden = true
			self.present(navController, animated: false, completion: nil)
			
		}
		else if indexPath.row == 5 {
			
			let vc = storyboard.instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
			let navController = UINavigationController.init(rootViewController: vc)
			navController.isNavigationBarHidden = true
			self.present(navController, animated: false, completion: nil)
			
		}
		else if indexPath.row == 6 {
			
			/*let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
			let navController = UINavigationController.init(rootViewController: vc)
			navController.isNavigationBarHidden = true
			self.present(navController, animated: false, completion: nil)*/
			self.dismiss(animated: false, completion: nil)
			
		}
        else if indexPath.row == 7{
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
            self.dismiss(animated: false, completion: nil)
            
        }
		
		
		
		
	}
	
}

//
//  TermsViewController.swift
//  BookIT
//
//  Created by Sagar Babber on 2/28/17.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit
import CoreData

class TermsViewController: UIViewController {

    var userDefaults =  SingletonClass.userDefaultsObj()
    override func viewDidLoad() {
        super.viewDidLoad()

        
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

	@IBAction func menu(_ sender: AnyObject) {
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

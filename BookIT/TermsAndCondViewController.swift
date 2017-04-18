//
//  TermsAndCondViewController.swift
//  BookIT
//
//  Created by Srujan on 10/04/17.
//  Copyright © 2017 SRUJAN KUMAR. All rights reserved.
//

import UIKit

class TermsAndCondViewController: UIViewController {
var userDefaults = SingletonClass.userDefaultsObj()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func acceptActn(_ sender: Any) {
        self.userDefaults.set("Success", forKey: "T&CStatus")
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        let  vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
        DispatchQueue.main.async{
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }

}

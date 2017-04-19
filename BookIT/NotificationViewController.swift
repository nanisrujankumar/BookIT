//
//  NotificationViewController.swift
//  BookIT
//
//  Created by Sagar Babber on 3/2/17.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

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
	@IBAction func backActn(_ sender: AnyObject) {
		DispatchQueue.main.async{
			self.navigationController!.popViewController(animated: true)
		}
		
	}

}

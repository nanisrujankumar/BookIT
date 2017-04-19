//
//  ViewController.swift
//  BookIT
//
//  Created by Sagar Babber on 2/24/17.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let storyboard = UIStoryboard(name:"Main", bundle:nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "IntroScreenViewController")  as! IntroScreenViewController
        DispatchQueue.main.async{
            self.navigationController?.pushViewController(vc, animated: true)}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}


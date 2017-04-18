//
//  MessageViewController.swift
//  BookIT
//
//  Created by SRAVANKUMAR VEERANTI on 06/03/2017.
//  Copyright © 2017 snyxius. All rights reserved.
//

import UIKit
import CoreData

class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, InputbarDelegate, MessageGatewayDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputbar:Inputbar!
    @IBOutlet var tapgesture: UITapGestureRecognizer!
    
    @IBOutlet weak var agentText: UILabel!
    @IBOutlet weak var dropDownTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var agentArray:Array<String>?
    var message:Array<String>? = []
    var messageStatus:Array<String>?
    var agentIdArray:NSArray?
    var modeIDArray:NSArray?
    var selectedOfficeId:NSNumber?
    var selectedModelId:NSNumber?
    var msg:String = ""
    
    //ProgressView
    var messageFrame = UIView()
    var allview = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    var chat:Chat! {
        didSet {
            self.title = "Player 1"
        }
    }
    
    private var tableArray:TableArray!
    private var gateway:MessageGateway!
    var userDefaults = SingletonClass.userDefaultsObj()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //tapgesture.cancelsTouchesInView = false
        agentArray = SingletonClass.userDefaultsObj().value(forKey: "OfficeNameArr") as! Array<String>?
        agentIdArray = SingletonClass.userDefaultsObj().value(forKey: "OfficeIdArr") as? NSArray
        modeIDArray = SingletonClass.userDefaultsObj().value(forKey: "ModelIdArr") as? NSArray
        
        dropDownTableView.isHidden = true
        dropDownTableView.tag = 0
        
        self.setInputbar()
        self.setTableView()
        self.setGateway()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.logout), name: NSNotification.Name(rawValue: "logout"), object: nil)
        
        
      /*  NotificationCenter.default.addObserver(self, selector: #selector(self.successResponse), name: NSNotification.Name(rawValue: "postSuccess"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.errorResponse), name: NSNotification.Name(rawValue: "postError"), object: nil)
        
        
        let token = SingletonClass.userDefaultsObj().value(forKey: "Device_Token")
        let dateStr          = Date()
        let formatter        = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy hh:mma"
        let date = formatter.string(from: dateStr)
        let dataParams = ["token":token!,"officeID":agentIdArray![0],"modelID":modeIDArray![0],"dtaetostartat":date] as [String : Any]
        SingletonClass.sharedInstance.allPostMethod("getchat", params: (dataParams as NSDictionary) as! Dictionary<String, Any>)*/
        
    }
    
    
    func successResponse(_ notification: NSNotification){
        
        DispatchQueue.main.async {
            self.allview.removeFromSuperview()
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "postError"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "postSuccess"), object: nil)
        
        let userInfo = notification.userInfo
        
        if userInfo?["status"] as! String == "true" && userInfo?["message"] as! String == "message sent"{
            
            DispatchQueue.main.async {
            let message = Message()
            message.text = self.msg
            message.date = NSDate()
            message.chatId = "1234" //self.chat.identifier
            self.dropDownTableView.tag = 0
            //Store Message in memory
            self.tableArray.addObject(message: message)
            
            //Insert Message in UI
            let indexPath = self.tableArray.indexPathForMessage(message: message)
            self.tableView.beginUpdates()
            if self.tableArray.numberOfMessagesInSection(section: indexPath.section) == 1 {
                self.tableView.insertSections(NSIndexSet(index:indexPath.section) as IndexSet, with:.none)
            }
            self.tableView.insertRows(at: [indexPath as IndexPath], with:.bottom)
            self.tableView.endUpdates()
            
            self.tableView.scrollToRow(at: self.tableArray.indexPathForLastMessage() as IndexPath, at:.bottom, animated:true)
            
            //Send message to server
            self.gateway.sendMessage(message: message)
            }
            
            
        }
        else{
            
            DispatchQueue.main.async {
                self.inputbar.inputResignFirstResponder()
                self.allview.removeFromSuperview()
            self.view.makeToast("Something went wrong .. Try Again")
            }
            
        }
    }
    
    func errorResponse(){
        self.inputbar.inputResignFirstResponder()
        DispatchQueue.main.async {
            self.allview.removeFromSuperview()
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "postError"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "postSuccess"), object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuAction(_ sender: Any) {
        self.inputbar.inputResignFirstResponder()
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        DispatchQueue.main.async{
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func agentActn(_ sender: Any) {
        
        self.inputbar.inputResignFirstResponder()
        
        if dropDownTableView.isHidden{
            self.tapgesture.cancelsTouchesInView = false
            dropDownTableView.tag = 1
            dropDownTableView.delegate = self
            dropDownTableView.dataSource = self
            dropDownTableView.isHidden = false
            tableHeight.constant = CGFloat((agentArray?.count)!) * 40
        }
        else{
            dropDownTableView.isHidden = true
            tableHeight.constant = 0
            dropDownTableView.tag = 0
        }
        
    }

    @IBAction func notificationAtn(_ sender: Any) {
        self.inputbar.inputResignFirstResponder()
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
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
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        self.view.keyboardTriggerOffset = inputbar.frame.size.height
        self.view.addKeyboardPanning() {[unowned self](keyboardFrameInView:CGRect, opening:Bool, closing:Bool) in
            /*
             self.view.removeKeyboardControl()
             */
            
            var toolBarFrame = self.inputbar.frame
            toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height
            self.inputbar.frame = toolBarFrame
            
            var tableViewFrame = self.tableView.frame
            tableViewFrame.size.height = toolBarFrame.origin.y - 64
            self.tableView.frame = tableViewFrame
            
            self.tableViewScrollToBottomAnimated(animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated:Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
        self.view.removeKeyboardControl()
        self.gateway.dismiss()
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        self.chat.lastMessage = self.tableArray!.lastObject()
    }
    
    // MARK -
    
    func setInputbar() {
        self.inputbar.placeholder = nil
        self.inputbar.inputDelegate = self
        //   self.inputbar.leftButtonImage = UIImage(named:"share")
        self.inputbar.rightButtonText = "Send"
        self.inputbar.rightButtonTextColor = UIColor(red:0, green:124/255, blue:1, alpha:1)
    }
    
    func setTableView() {
        self.tableArray = TableArray()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect(x:0, y:0,width:self.view.frame.size.width,height:10))
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
        
        self.tableView.register(MessageCell.self, forCellReuseIdentifier:"MessageCell")
    }
    
    func setGateway() {
        self.gateway = MessageGateway.sharedInstance
        self.gateway.delegate = self
        self.gateway.chat = self.chat
        self.gateway.loadOldMessages()
    }
    
    // MARK - Actions
    
    @IBAction func userDidTapScreen(_ sender: Any) {
        self.inputbar.inputResignFirstResponder()
    }
    
    
    // MARK - TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dropDownTableView.tag == 1{
            
            return 1
        }
        else{
            
            return self.tableArray.numberOfSections
        }
        //return self.tableArray.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if dropDownTableView.tag == 1{
            
            return (agentArray?.count)!
        }
        else{
            
            return self.tableArray.numberOfMessagesInSection(section: section)
        }
       // return self.tableArray.numberOfMessagesInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if dropDownTableView.tag == 1{
            let identifier = "AgentCellTableViewCell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AgentCellTableViewCell
            
            if cell == nil {
                cell = tableView.dequeueReusableCell(withIdentifier: "AgentCellTableViewCell") as? AgentCellTableViewCell
            }
            
            cell?.name.text = agentArray![indexPath.row]
            return cell!
        }
        else{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        DispatchQueue.main.async {
        cell.message = self.tableArray.objectAtIndexPath(indexPath: indexPath as NSIndexPath)
        }
        return cell;
            
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if dropDownTableView.tag == 1{
            self.tapgesture.cancelsTouchesInView = true
            dropDownTableView.isHidden = true
            print(indexPath.row)
            tableHeight.constant = 0
            agentText.text = agentArray?[indexPath.row]
            selectedModelId = modeIDArray?[indexPath.row] as! NSNumber?
            selectedOfficeId = agentIdArray?[indexPath.row] as! NSNumber?
            
          /*  NotificationCenter.default.addObserver(self, selector: #selector(self.successResponse), name: NSNotification.Name(rawValue: "postSuccess"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.errorResponse), name: NSNotification.Name(rawValue: "postError"), object: nil)
            
            let token = SingletonClass.userDefaultsObj().value(forKey: "Device_Token")
            let dateStr          = Date()
            let formatter        = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy hh:mma"
            let date = formatter.string(from: dateStr)
            let dataParams = ["token":token!,"officeID":selectedOfficeId!,"modelID":selectedModelId!,"dtaetostartat":date] as [String : Any]
            SingletonClass.sharedInstance.allPostMethod("getchat", params: (dataParams as NSDictionary) as! Dictionary<String, Any>)*/
        }
        
        
    }
    
    // MARK - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dropDownTableView.tag == 1{
            return 40
        }
        else{
            let message = self.tableArray.objectAtIndexPath(indexPath: indexPath as NSIndexPath)
            return message.height
        }
        
    }
    
    /* func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 40
     }
     
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return self.tableArray.titleForSection(section: section)
     }
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let frame = CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 40)
     
     let view = UIView(frame:frame)
     view.backgroundColor = UIColor.clear
     view.autoresizingMask = .flexibleWidth
     
     let label = UILabel()
     label.text = self.tableView(tableView, titleForHeaderInSection: section)
     label.textAlignment = .center
     label.font = UIFont(name:"Helvetica", size:20)
     label.sizeToFit()
     label.center = view.center
     label.font = UIFont(name:"Helvetica", size:13)
     label.backgroundColor = UIColor(red:207/255, green:220/255, blue:252/255, alpha:1)
     label.layer.cornerRadius = 10
     label.layer.masksToBounds = true
     label.autoresizingMask = []
     view.addSubview(label)
     
     return view
     }*/
    
    func tableViewScrollToBottomAnimated(animated:Bool) {
        let numberOfSections = self.tableArray.numberOfSections
        let numberOfRows = self.tableArray.numberOfMessagesInSection(section: numberOfSections-1)
        if numberOfRows > 0 {
            self.tableView.scrollToRow(at: self.tableArray.indexPathForLastMessage() as IndexPath, at:.bottom, animated:animated)
        }
    }
    
    // MARK - InputbarDelegate
    
    func inputbarDidPressRightButton(inputbar:Inputbar) {
        
        if selectedOfficeId != nil && selectedModelId != nil {
            progressBarDisplayer("Processing ...", true)
            NotificationCenter.default.addObserver(self, selector: #selector(self.successResponse), name: NSNotification.Name(rawValue: "postSuccess"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.errorResponse), name: NSNotification.Name(rawValue: "postError"), object: nil)
            
            msg = inputbar.text.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines)
            let token = SingletonClass.userDefaultsObj().value(forKey: "Device_Token")
            
            let dataParams = ["token":token!,"officeID":selectedOfficeId!,"modelID":selectedModelId!,"message":msg] as [String : Any]
            SingletonClass.sharedInstance.allPostMethod("chat", params: (dataParams as NSDictionary) as! Dictionary<String, Any>)
        }
        else{
            self.inputbar.inputResignFirstResponder()
            DispatchQueue.main.async {
            self.view.makeToast("Please Select Agent")
            }
        }
        
        
        
        
    }
    
    func inputbarDidPressLeftButton(inputbar:Inputbar) {
        /* let alertView = UIAlertView(title: "Left Button Pressed", message: nil, delegate: nil, cancelButtonTitle: "OK")
         alertView.show()*/
    }
    
    func inputbarDidChangeHeight(newHeight:CGFloat) {
        //Update DAKeyboardControl
        self.view.keyboardTriggerOffset = newHeight
    }
    
    // MARK - MessageGatewayDelegate
    
    func gatewayDidUpdateStatusForMessage(message:Message) {
        /*  let indexPath = self.tableArray.indexPathForMessage(message: message)
         let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! MessageCell
         cell.updateMessageStatus()*/
    }
    
    func gatewayDidReceiveMessages(array:[Message]) {
        self.tableArray.addObjectsFromArray(messages: array)
        self.tableView.reloadData()
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

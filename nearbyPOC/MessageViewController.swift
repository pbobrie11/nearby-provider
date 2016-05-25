//
//  ViewController.swift
//  nearbyPOC
//
//  Created by Zack on 3/30/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit

let cellIdentifier = "messageCell"

let myDevId = UIDevice.currentDevice().identifierForVendor!.UUIDString

class MessageViewController: UITableViewController {
    
    let openSans = UIFont(name: "OpenSans-Semibold", size: 16)
    
    let openSansLarge = UIFont(name: "OpenSans-Semibold", size: 24)
    
    
    
    //create UI Color used in CC App
    let uglyBlue = UIColor(colorLiteralRed: 43/255, green: 107/255, blue: 125/255, alpha: 1)
    
    let sea = UIColor(colorLiteralRed: 55/255, green: 139/255, blue: 127/255, alpha: 1)
    
    let lightBlueGrey = UIColor(colorLiteralRed: 213/255, green: 232/255, blue: 236/255, alpha: 1)
    
    /**
    * @property
    * The left button to use in the nav bar.
    */
    var leftBarButton: UIBarButtonItem! {
        get {
            return navigationItem.leftBarButtonItem
        }
        set(leftBarButton) {
            navigationItem.leftBarButtonItem = leftBarButton
            navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: openSans!], forState: .Normal)
            navigationItem.leftBarButtonItem?.tintColor = uglyBlue
        }
    }
    
    /**
    * @property
    * The right button to use in the nav bar.
    */
    var rightBarButton: UIBarButtonItem! {
        get {
            return navigationItem.rightBarButtonItem
        }
        set(rightBarButton) {
            navigationItem.rightBarButtonItem = rightBarButton
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: openSans!], forState: .Normal)
            navigationItem.rightBarButtonItem?.tintColor = uglyBlue
        }
    }
    
    var messArray = [Message]()
    var chargeMessages = [String]()
    var i = 0
    
    
    //variable to handle name of device / provider

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        checkForId()
        
        tableView.separatorColor = lightBlueGrey
        
        let logo = UIImage(named: "logo")
        let logoView = UIImageView(image: logo)
        self.navigationItem.titleView = logoView
        
        self.tableView.rowHeight = CGFloat(90)
    }

    
    //creating "alert" with input for Device Name / ID
    
    var titleMessage = "No Device ID found"
    var displayMessage = "Please Enter Your Device Name or ID"
    
    var confirmedStatement = " has confirmed your charge"
    var declinedStatement = " has declined your charge"
    var confirmed = "Confirmed"
    var declined = "Declined"
    
    
    func checkForId(){
        var idCheck: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("id")
        
        if idCheck == nil {
            showAlert()
        } else {
            var idString: String = (idCheck as? String)!
        }
        
    
    }
    
    func showAlert() {
        var idTextField : UITextField?
        let alertController = UIAlertController(title: titleMessage, message: displayMessage, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler {(textField) in
            idTextField = textField
            textField.placeholder = "     ID"
            textField.keyboardType = .EmailAddress
            }
        let sub = UIAlertAction(title: "Submit", style: .Cancel, handler: { (action) -> Void in
            var id: NSString = (idTextField?.text)!
            NSUserDefaults.standardUserDefaults().setObject(id, forKey: "id")
        })
        alertController.addAction(sub)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    

    
    func addMessage(message: String) {
        var delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var messageToFill = Message(state: " ", name: " ", devId: " ", recId: " ", amt: " ")
        
        let fullMessage = messageToFill.stringToObject(message)
        
        let state = fullMessage.state
        let name = fullMessage.name
        let devId = fullMessage.devId
        let recId = fullMessage.recId
        let amt = fullMessage.amt
        
        
        if myDevId == recId {
            print("repeat ID")
            checkState(state, name: name)
        } else {
            messArray.append(fullMessage)
            
            let chargeMessage = "Charge " + name
            chargeMessages.append(chargeMessage)
        }
        
        
        tableView.reloadData()
    }
    
    func checkState(state: String, name: String){
        var delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if state == "3" && delegate.allowPaymentAlert == true {
            
        paymentAlert(confirmedStatement, name: name, result: confirmed)
            delegate.controlState = 0
            delegate.revert()
            delegate.allowPaymentAlert = false
            
            changeChargingState()
        } else if state == "4" && delegate.allowPaymentAlert == true {
        paymentAlert(declinedStatement, name: name, result:  declined)
            
       
            delegate.controlState = 0
            delegate.revert()
            delegate.allowPaymentAlert = false
            changeChargingState()
        }
    }
    
    func changeChargingState() {
        
        var index: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("chargeIndex")
        
        var path = index as? Int
        
        let title = chargeMessages[path!]
        
        let chargeCheck = title.componentsSeparatedByString(" ")
        
        if chargeCheck[0] == "Charging" {
            chargeMessages[path!] = "Charge" + " " + chargeCheck[1] + " " + chargeCheck[2]
        } else {
            chargeMessages[path!] = "Charging" + " " + chargeCheck[1] + " " + chargeCheck[2]
        }
        
        tableView.reloadData()
    }
    
    func removeMessage(message: String!) {
        var messArr = message.componentsSeparatedByString(",")
        var nameToRemove = messArr[1]
        
        var keyArray = [String]()
        
        for keys in messArray {
            var counter = 0
            keyArray.append(messArray[counter].name)
            counter += 1
        }
        
        
        if let index = keyArray.indexOf(nameToRemove)
        {
            messArray.removeAtIndex(index)
        }
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
        
        tableView.reloadData()
    }
    
    func paymentAlert(message: String, name: String, result: String){
        let baseMessage = name + message
        
        let alertController = UIAlertController(title: result, message: baseMessage, preferredStyle: .Alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: { (action) -> Void in
        })
        alertController.addAction(dismiss)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
       // delegate.revert()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cgUglyBlue = uglyBlue.CGColor
        
        let cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = chargeMessages[indexPath.row]
        
        var frame = CGRect(x: 675,y: 34,width: 40,height: 40)
        var imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "cellArrow")
        
        cell.textLabel?.textColor = uglyBlue
        cell.textLabel?.font = openSansLarge
        
        if messArray.isEmpty {
            cell.willRemoveSubview(imageView)
        } else {
            cell.addSubview(imageView)
        }
        
        return cell
    }
    
    func changeCellTitle (path : Int) {
      let title = chargeMessages[path]
    
        let chargeCheck = title.componentsSeparatedByString(" ")
        
        if chargeCheck[0] == "Charge" {
            chargeMessages[path] = "Charging" + " " + chargeCheck[1] + " " + chargeCheck[2]
        } else {
            chargeMessages[path] = "Charge" + " " + chargeCheck[1] + " " + chargeCheck[2]
        }
        
        tableView.reloadData()
    }
    
    /*func formMessageForPayment(path: Int) {
        var name = nameArr[path]
        var devName = UIDevice.currentDevice().identifierForVendor!.UUIDString
        var recId = devArr[path]
        
        var completeMessage = name + "," + devName + "," + recId
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.sendPayMessage(completeMessage)
    }
    */
    func setMessageById(path: Int){
        
        print(messArray)
        var name = messArray[path].name
        var devId = messArray[path].devId
        
        
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: "payName")
        NSUserDefaults.standardUserDefaults().setObject(devId, forKey: "payRecId")
    }
    
    func presentPayment(vc: UIViewController){
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func currentCharge(path: Int) {
        NSUserDefaults.standardUserDefaults().setObject(path, forKey: "chargeIndex")
    }
    
    @IBAction func unwindToHere(segue: UIStoryboardSegue){
        
    }
    
    
    // MARK: - UItableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        
        changeCellTitle(indexPath.row)
       // formMessageForPayment(indexPath.row)
        setMessageById(indexPath.row)
        
        currentCharge(indexPath.row)

       // let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let payView = delegate.paymentVc
        // presentPayment(payView)
        
        
        let mainstoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let payvc : UIViewController = mainstoryboard.instantiateViewControllerWithIdentifier("pmt")
        let navController : UINavigationController!
        let navRoot = UINavigationController(rootViewController: payvc)
        presentPayment(navRoot)
        
        print(messArray[indexPath.row].state)
        print(messArray[indexPath.row].name)
        print(messArray[indexPath.row].devId)
        print(messArray[indexPath.row].recId)
        print(messArray[indexPath.row].amt)
    }
}


    




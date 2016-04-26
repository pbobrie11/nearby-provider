//
//  ViewController.swift
//  nearbyPOC
//
//  Created by Zack on 3/30/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit

let cellIdentifier = "messageCell"

class MessageViewController: UITableViewController {
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
        }
    }
    
    var nameArr = [String]()
    var devArr = [String]()
    var recArr = [String]()
    var chargeMessages = [String]()
    
    var messDict = [String: String]()
    
    //variable to handle name of device / provider
    
    var provDict = ["Leo's": "www.google.com", "James'": "www.yahoo.com", "Jeff's": "www.bing.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        checkForId()
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
        
        
        let messArr = message.componentsSeparatedByString(",")
        let state = messArr[0]
        let name = messArr[1]
        let devId = messArr[2]
        let recId = messArr[3]
        let amt = messArr[4]
        
        let myDevId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        devArr.append(devId)
        recArr.append(recId)
        
        if myDevId == recId {
            print("repeat ID")
            checkState(state, name: name)
        } else {
            devArr.append(devId)
            recArr.append(recId)
            let chargeMessage = "Charge " + name
            nameArr.append(name)
            chargeMessages.append(chargeMessage)
        }
        
        
        tableView.reloadData()
    }
    
    func checkState(state: String, name: String){
        if state == "3" {
            paymentAlert(confirmedStatement, name: name, result: confirmed)
        } else if state == "4" {
            paymentAlert(declinedStatement, name: name, result:  declined)
        }
    }
    
    func removeMessage(message: String!) {
        var messArr = message.componentsSeparatedByString(",")
        var nameToRemove = messArr[1]
        
        if let index = nameArr.indexOf(nameToRemove)
        {
            nameArr.removeAtIndex(index)
            recArr.removeAtIndex(index)
            devArr.removeAtIndex(index)
        }
        tableView.reloadData()
    }
    
    func paymentAlert(message: String, name: String, result: String){
        let baseMessage = name + message
        
        let alertController = UIAlertController(title: result, message: baseMessage, preferredStyle: .Alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: { (action) -> Void in
        })
        alertController.addAction(dismiss)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = chargeMessages[indexPath.row]
        return cell
    }
    
    func changeCellTitle (path : Int) {
      let title = chargeMessages[path]
    
        let chargeCheck = title.componentsSeparatedByString(" ")
        
        if chargeCheck[0] == "Charge" {
            nameArr[path] = "Charging" + " " + chargeCheck[1]
        } else {
            nameArr[path] = "Charge" + " " + chargeCheck[1]
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
        var name = nameArr[path]
        var recId = devArr[path]
        
        let recArr = name.componentsSeparatedByString(" ")
        var payName = recArr[1]
        
        NSUserDefaults.standardUserDefaults().setObject(payName, forKey: "payName")
        NSUserDefaults.standardUserDefaults().setObject(recId, forKey: "payRecId")
    }
    
    func presentPayment(vc: UIViewController){
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func unwindToHere(segue: UIStoryboardSegue){
        
    }
    
    // MARK: - UItableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        changeCellTitle(indexPath.row)
       // formMessageForPayment(indexPath.row)
        setMessageById(indexPath.row)

       // let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let payView = delegate.paymentVc
        // presentPayment(payView)
        
        
        let mainstoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let payvc : UIViewController = mainstoryboard.instantiateViewControllerWithIdentifier("pmt")
        let navController : UINavigationController!
        let navRoot = UINavigationController(rootViewController: payvc)
        presentPayment(navRoot)
    }
}


    




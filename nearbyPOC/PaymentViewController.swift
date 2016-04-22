//
//  PaymentViewController.swift
//  nearbyPOC
//
//  Created by Zack on 4/20/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    @IBAction func cancel(sender: AnyObject) {
        self.performSegueWithIdentifier("unwind", sender: self)
    }
    
    @IBOutlet weak var amtField: UITextField!
   
    @IBOutlet weak var sendCharge: UIButton!
    
    var state : String = " "
    var provNameString : String = " "
    var devID : String = " "
    var recIdStoreString: String = " "
    var amt : String = " "
    
    //-------//
    var payNameString: String = " "
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.sizeToFit()
        
        // Inputs for MESSAGE and Labels
        
        //state
        var state = "2"
        
        //content / name (provider)
        var provName : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("id")
        provNameString = provName as! String
        
        //devName
        var devName = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        //recId == devId of patient
        var recIdStore : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("payRecId")
        recIdStoreString = recIdStore as! String
        
        //amt = from label
        
        //-----------------*
        var payName : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("payName")
        payNameString = payName as! String

        
        amtField.keyboardType = UIKeyboardType.DecimalPad
        
       /* var nameLabel = UILabel(frame: CGRectMake(0,0,200,21))
        nameLabel.center = CGPointMake(160, 284)
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.text = recIdStoreString
        self.view.addSubview(nameLabel)
        */
        
        sendCharge.backgroundColor = UIColor(red: 32.0/255.0, green: 157.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        sendCharge.layer.cornerRadius = 5
        sendCharge.layer.borderWidth = 1
        //sendCharge.te
        
        messageLabel.text = "Please enter how much you would like to charge " + payNameString + " below:"
        
        
        sendCharge.addTarget(self, action: "sendPaymentMessage:", forControlEvents: .TouchUpInside)
        
    }
    
    
    func sendPaymentMessage(sender: UIButton!){
        let sendState = state
        let sendName = provNameString
        let sendDevId = devID
        let sendRecId = recIdStoreString
        let sendAmt = amt
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.sendPayment(sendState, content: sendName, devId: sendDevId, recId: sendRecId, amt: sendAmt)
    }
    
    func formMessageForPayment(path: Int) {
        var provName : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("id")
        var devName = UIDevice.currentDevice().identifierForVendor!.UUIDString
        var recId : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("payRecId")
        
        //var completeMessage = name + "," + devName + "," + recId
        
      //  delegate.sendPayMessage(completeMessage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Inputs for MESSAGE and Labels
        
        //state
        var state = "2"
        
        //content / name (provider)
        var provName : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("id")
        var provNameString : String = provName as! String
        
        //devName
        var devName = UIDevice.currentDevice().identifierForVendor!.UUIDString
       
        //recId == devId of patient
        var recIdStore : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("payRecId")
        var recIdStoreString: String = recIdStore as! String
        
        //amt = from label
        
        //-----------------*
        var payName : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("payName")
        var payNameString: String = payName as! String
        
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
        

        
    }
    
    func unwindToTable(){
       // var messageViewController : MessageViewController!
        //messageViewController = MessageViewController()
        //presentViewController(messageViewController, animated: true, completion: nil)
        
        
    }
    
    func formMessageForPayment(path: Int) {
        var provName : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("id")
        var devName = UIDevice.currentDevice().identifierForVendor!.UUIDString
        var recId : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("payRecId")
        
        //var completeMessage = name + "," + devName + "," + recId
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
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

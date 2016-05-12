//
//  PaymentViewController.swift
//  nearbyPOC
//
//  Created by Zack on 4/20/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    
    //navController.navigationBar.barTintColor = UIColor.whiteColor()
    
    @IBOutlet weak var messageLabel: UILabel!
    
    let openSans = UIFont(name: "OpenSans-Semibold", size: 16)
    
    let openSansLarge = UIFont(name: "OpenSans-Semibold", size: 20)
    
    let uglyBlue = UIColor(colorLiteralRed: 43/255, green: 107/255, blue: 125/255, alpha: 1)
    
    
    @IBAction func cancel(sender: AnyObject) {
        self.performSegueWithIdentifier("unwind", sender: self)
    }
    
    @IBOutlet weak var amtField: UITextField!
   
    @IBOutlet weak var sendCharge: UIButton!
    
    @IBOutlet weak var line: UIView!
    
    
    //colors
    
    let sea = UIColor(colorLiteralRed: 55/255, green: 139/255, blue: 127/255, alpha: 1)
    
    let lightBlueGrey = UIColor(colorLiteralRed: 213/255, green: 232/255, blue: 236/255, alpha: 1)
    
    var state : String = " "
    var provNameString : String = " "
    var devID : String = UIDevice.currentDevice().identifierForVendor!.UUIDString
    var recIdStoreString: String = " "
    var amt : String = " "
    
    //-------//
    var payNameString: String = " "
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: openSans!], forState: .Normal)
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : uglyBlue, NSFontAttributeName : openSans!]
        
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem?.tintColor = uglyBlue
        
        self.title = "Request a Payment"
        
        messageLabel.sizeToFit()
        messageLabel.textColor = uglyBlue
        
        // Inputs for MESSAGE and Labels
        
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
        
        sendCharge.backgroundColor = sea
        sendCharge.layer.cornerRadius = 5
        sendCharge.layer.borderWidth = 1
        sendCharge.titleLabel?.font = openSansLarge

        
        messageLabel.text = "Please enter how much you would like to charge " + payNameString + " below:"
        
        
        sendCharge.addTarget(self, action: "validateAmt:", forControlEvents: .TouchUpInside)
        
        line.backgroundColor = lightBlueGrey
        
    }
    
    func invalidAmt(){
        
        let alertController = UIAlertController(title: "Invalid Input", message: "Please input an amount greater than zero or cancel the charge", preferredStyle: .Alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: { (action) -> Void in
        })
        alertController.addAction(dismiss)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func validateAmt(sender: UIButton!){
        let fieldAmt = amtField.text
        let amtAsInt : Int? = Int(amtField.text!)
        let sendAmt : String = " "
        
        if fieldAmt?.characters.count > 0 {
            if amtAsInt != 0 {
                sendPaymentMessage()
            } else {
                invalidAmt()
            }
        } else {
            invalidAmt()
        }

    }
    
    func sendPaymentMessage(){
        
        let fieldAmt = amtField.text
        
        let state = "2"
        
        //insert if functiont to handle nil values for amt field below
        
        var message = Message(state: state, name: provNameString, devId: devId, recId: recIdStoreString, amt: fieldAmt!)
        
    
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

        delegate.controlState = 1
        
        delegate.allowPaymentAlert = true
        
        delegate.checkValidity(message)
        
        
        //also dismiss View ftb
        self.performSegueWithIdentifier("unwind", sender: self)
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

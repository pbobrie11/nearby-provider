//
//  PaymentViewController.swift
//  nearbyPOC
//
//  Created by Zack on 4/20/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var recLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func cancel(sender: AnyObject) {
        self.performSegueWithIdentifier("unwind", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        var provName : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("id")
        var provNameString : String = provName as! String
        
        var devName = UIDevice.currentDevice().identifierForVendor!.UUIDString
       
        var recIdStore : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("payRecId")
        var recIdStoreString: String = recIdStore as! String
        
       /* var nameLabel = UILabel(frame: CGRectMake(0,0,200,21))
        nameLabel.center = CGPointMake(160, 284)
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.text = recIdStoreString
        self.view.addSubview(nameLabel)
        */
        
        recLabel.text = recIdStoreString
        nameLabel.text = provNameString
        
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

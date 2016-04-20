//
//  DataManager.swift
//  nearbyPOC
//
//  Created by Zack on 4/7/16.
//  Copyright © 2016 Zack. All rights reserved.
//


import Foundation

class DataManager {
    
    class func grabNames(success: ((data: NSData) -> Void)) {
        //1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //2
            let filePath = NSBundle.mainBundle().pathForResource("blpProfilePage",ofType:"json")
            
            var readError:NSError?
            do {
                let data = try NSData(contentsOfFile:filePath!, options: NSDataReadingOptions.DataReadingUncached)
                success(data: data)
            } catch let error as NSError {
                readError = error
            } catch {
                fatalError()
            }
        })
}
}

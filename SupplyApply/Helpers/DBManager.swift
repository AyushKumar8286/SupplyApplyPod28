//
//  DBManager.swift
//  SupplyApply
//
//  Created by Mac3 on 16/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import CoreData

let notificationTableName = "NotificationTable"

class DBManager: NSObject {

//    static func getAppDelegate() -> AppDelegate? {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            return appDelegate
//        } else {
//            return nil
//        }
//    }
//
//    static func getManagedContext()-> NSManagedObjectContext? {
//        let context = getAppDelegate()?.persistentContainer.viewContext
//        return context
//    }
//
//    static func saveContext() {
//        getAppDelegate()?.saveContext()
//    }
//    
//    static func addNotificationToDB(name : String?, time:String) {
//        
//        let managedContext = DBManager.getManagedContext()
//        let request = NSFetchRequest<NSManagedObject>(entityName: notificationTableName)
//        request.returnsObjectsAsFaults = false
//        let data = NotificationTable(context: managedContext!)
//        data.name = name
//        data.time = time
//        DBManager.saveContext()
//        print(request)
//    }
    
//    static func fetchNotificationDetailToDB() -> ([String] , [String]) {
//        
//        var notificationName = [String]()
//        var notificationTime = [String]()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSManagedObject>(entityName: notificationTableName)
//        request.returnsObjectsAsFaults = false
//        
//        do {
//            
//            let results = try context.fetch(request) as? [NotificationTable]
//            if results?.count != 0 {
//                for i in 0..<(results?.count)! {
//                    notificationName.append(results?[i].name ?? "")
//                    notificationTime.append(results?[i].time ?? "")
//                }
//            }
//            print(request)
//        } catch {
//            print("Failed")
//        }
//        
//        return (notificationName, notificationTime)
//    }
}

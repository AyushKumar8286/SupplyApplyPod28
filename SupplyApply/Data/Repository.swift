//
//  Repository.swift
//  Deponet-Options
//
//  Created by SunTec on 17/01/19.
//  Copyright © 2019 Mac6. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AVKit

class Repository {
    static let shared = Repository()
    private init(){}
    var isNetworkAvailable  = false
    
    //function to get unique string id created from timestamp
    func getNewUniqueId() -> String{
        return  "\(Date().timeIntervalSince1970)"
    }
    
    func getGUIDAsString() -> String{
        return UUID().uuidString
    }
    
    func getDeviceOSVersion() -> String{
        return UIDevice.current.systemVersion
    }
    
    func getAppVersionNoAndCode()->(vNo : String, vCdoe : String){
        return (Bundle.main.releaseVersionNumber ?? "1.0.0", Bundle.main.buildVersionNumber ?? "1")
    }
    
}

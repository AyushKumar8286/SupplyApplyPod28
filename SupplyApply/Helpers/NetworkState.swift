//
//  NetworkState.swift
//  Deponet-Options
//
//  Created by Shashi Shekhar on 07/03/19.
//  Copyright © 2019 Mac6. All rights reserved.
//


import Foundation
import Alamofire

struct NetworkState {
    
    var isConnected: Bool {
        return NetworkReachabilityManager(host: "www.apple.com")!.isReachable
    }
    
}

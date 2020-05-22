//
//  APIRouteConfiguration.swift
//  SHNetworlLayer
//
//  Created by shashi on 1/20/19.
//  Copyright © 2019 shashi. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRouteConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    
}

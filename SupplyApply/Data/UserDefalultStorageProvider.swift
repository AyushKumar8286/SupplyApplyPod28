//
//  UserDefalultStorage.swift
//  Deponet-Options
//
//  Created by SunTec on 24/01/19.
//  Copyright © 2019 Mac6. All rights reserved.
//

import Foundation

enum UserDefalultStorageKeys : String{
    case isLoggedIn
    case userData
    case customerID
    case productId
    case productName
    case shipAddressId
    case billAddressid
    case isCallFor
    case isShipIn
}

extension UserDefaults {
    
    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefalultStorageKeys.isLoggedIn.rawValue)
    }
    
    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefalultStorageKeys.isLoggedIn.rawValue)
    }
    
    func setUserData(value: User){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            set(encoded, forKey: UserDefalultStorageKeys.userData.rawValue)
            
        }
    }
    
    func getUserData() -> User!{
        
        if let savedPerson = data(forKey: UserDefalultStorageKeys.userData.rawValue) {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                return loadedPerson
            }
        }
        return nil
    }
    
    func setCutomerID(value: String){
        set(value, forKey: UserDefalultStorageKeys.customerID.rawValue)
    }
    
    func getCutomerID() -> String{
        return string(forKey: UserDefalultStorageKeys.customerID.rawValue) ?? ""
    }
    
    func setProductID(value: String){
        set(value, forKey: UserDefalultStorageKeys.productId.rawValue)
    }
    
    func getProductID() -> String{
        return string(forKey: UserDefalultStorageKeys.productId.rawValue) ?? ""
    }
    
    
    func setProductName(value: String){
        set(value, forKey: UserDefalultStorageKeys.productName.rawValue)
    }
    
    func getProductName() -> String{
        return string(forKey: UserDefalultStorageKeys.productName.rawValue) ?? ""
    }
    
    func setShipAddressId(value: String){
        set(value, forKey: UserDefalultStorageKeys.shipAddressId.rawValue)
    }
    
    func getShipAddressId() -> String{
        return string(forKey: UserDefalultStorageKeys.shipAddressId.rawValue) ?? ""
    }
    
    func setBillAddressId(value: String){
        set(value, forKey: UserDefalultStorageKeys.billAddressid.rawValue)
    }
    
    func getBillAddressId() -> String{
        return string(forKey: UserDefalultStorageKeys.billAddressid.rawValue) ?? ""
    }
    
    func setisCallfor(value: String){
        set(value, forKey: UserDefalultStorageKeys.isCallFor.rawValue)
    }
    
    func getisCallFor() -> String{
        return string(forKey: UserDefalultStorageKeys.isCallFor.rawValue) ?? ""
    }
    
    func setShipIn(value: Bool) {
        set(value, forKey: UserDefalultStorageKeys.isShipIn.rawValue)
    }
    
    func isShipIn()-> Bool {
        return bool(forKey: UserDefalultStorageKeys.isShipIn.rawValue)
    }
    
    func clearAll(){
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
}

//
//  Extensions.swift
//  ContainerControllerDemo
//
//  Created by SunTec on 29/01/19.
//  Copyright © 2019 SunTec. All rights reserved.
//

import Foundation
import UIKit

class Validator {
    
    class func isValidEmail(_ email: String)-> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    class func isValidPassword(_ password: String)-> Bool{
        return password.count > 7
    }
    
    class func isValidString(_ password: String)-> Bool{
        return password.count > 0
    }
    
    class func isValidMobile(_ mobile: String)-> Bool{
        let mobileRegEx = "^\\d{10}$"
        let mobilePred = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
        return mobilePred.evaluate(with: mobile)
    }
}


extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIView {
    
    func addDesign(cornerRadius: CGFloat, shadowWidth: CGFloat, shadowHeight: CGFloat, corners: CACornerMask?) {
        
        if shadowHeight > 0 || shadowWidth > 0 {
            self.layer.shadowColor = Colors.shadow?.cgColor
            self.layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 0.5
        }
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        if let corners = corners {
            self.layer.maskedCorners = corners
        }        
    }
    
    func removeDesign(){
        if #available(iOS 11.0, *) {
            self.layer.shadowColor = Colors.shadow?.cgColor
        } else {
            // Fallback on earlier versions
        }
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.layer.cornerRadius = 0
    }
}

extension Dictionary {
    
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
    
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

class KeyChainUserInfoSave {
    
    class func saveUserInfo(email: String, password: String) {
        let pswrd = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: email,
                                    kSecAttrServer as String: Bundle.main.infoDictionary?["BASE_URL"] as? String ?? "",
                                    kSecValueData as String: pswrd]
        _ = SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { fatalError("Data not saved") }
    }
    
    class func getEmailIdOrPassword() -> (String, String) {
        let attributes: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                         kSecAttrServer as String: Bundle.main.infoDictionary?["BASE_URL"] as? String ?? "",
                                         kSecReturnAttributes as String: true,
                                         kSecReturnData as String: true]
        
        // 2
        var item: CFTypeRef?
        let status = SecItemCopyMatching(attributes as CFDictionary, &item)
        guard status != errSecItemNotFound else { fatalError("Item not found") }
        guard status == errSecSuccess else {  fatalError("Cannot find user credentials in Keychain") }
        
        // 3
        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8),
            let account = existingItem[kSecAttrAccount as String] as? String else {
                fatalError("Unexpected password data")
        }
        return (account, password)
    }
    
    class func removeKeyChainInfo() {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: Bundle.main.infoDictionary?["BASE_URL"] as? String ?? ""]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { fatalError("Info not deleted") }
        
    }
}

extension String {
    
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
  
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

extension UILabel {
    
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}

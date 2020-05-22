//
//  LoginViewController.swift
//  Deponet-Options
//
//  Created by Mac6 on 1/9/19.
//  Copyright © 2019 Mac6. All rights reserved.
//

import UIKit

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

class LoginViewController: CustomViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var showPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.addDesign(cornerRadius: 30, shadowWidth: 0, shadowHeight: 2, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        userNameField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    @IBAction func handleLoginAction() {
        if self.validateUserInput(){
            if SHRestClient.isConnectedToInternet() {
                self.performLogin()
                KeyChainUserInfoSave.saveUserInfo(email: userNameField.text!, password: passwordTextField.text!)
            } else {
                self.showNoInternetWarning()
            }
        }
    }
    
    
    func validateUserInput()-> Bool {
        let isValidEmail = Validator.isValidEmail(userNameField.text ?? "")
        let isValidPassword = Validator.isValidPassword(passwordTextField.text ?? "")
        
        if !isValidEmail {
//            self.showToast(message : "Please enter a valid Email Address.", type: .failure)
            self.view.makeToast("Please enter a valid Email Address.")
            return false
        } else  if !isValidPassword {
//            self.showToast(message : "Please enter a valid Password.", type: .failure)
            self.view.makeToast("Please enter a valid Password.")
            return false
        } else {
            return true
        }
    }
    
    
    func performLogin() {
        self.showLoading(isLoading: true)
        let email = userNameField.text!
        let pwd = passwordTextField.text!
        
        SHRestClient.login(email: email, password: pwd) { result in
            self.showLoading(isLoading: false)
            switch result {
            case .success(let response):
                if response.success ?? false {
                    self.loginComplete(user: response)
                } else {
//                    self.showToast(message : response.message ?? "Failed to login. Please try after sometime.", type: .failure)
                    self.view.makeToast(response.message ?? "Failed to login. Please try after sometime.")
                }
            case .failure(let error):
                print(error.localizedDescription)
//                self.showToast(message : "Failed to login. Please try after sometime.", type: .failure)
                self.view.makeToast("Failed to login. Please try after sometime.")
            }
        }
    }
    
    
    func loginComplete(user: User){
        UserDefaults.standard.setLoggedIn(value: true)
        UserDefaults.standard.setUserData(value: user)
        UserDefaults.standard.setCutomerID(value: user.data?.customer?.customerID ?? "")
        
        if user.licenseVerify ?? false {
//            showToast(message: "Login Successful", type: .success)
            self.view.makeToast( "Login Successful")
            navigator.navigateAndReplacePreviews(to: .dashboard)
            
        } else if !(user.licenseVerify ?? false)  && (user.licenseUpload ?? true) {
//            showToast(message: "Your License isn't verified yet, Please try after sometime.", type: .success)
            self.view.makeToast("Your License isn't verified yet, Please try after sometime.")
            
        } else {
            self.navigator.navigate(to: .licenseValidate(customerId: user.data?.customer?.customerID ?? "", delegate: nil))
            
        }
    }
    
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        navigator.navigate(to: .forgotPassword)
    }
    
    
    @IBAction func showPasswordTapped(_ sender: Any) {
        if passwordTextField.isSecureTextEntry{
            showPassword.setImage(UIImage(named: "eyeSlash"), for: .normal)
        } else {
            showPassword.setImage(UIImage(named: "eye"), for: .normal)
        }
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    
    @IBAction func signupTapped(_ sender: Any) {
        navigator.navigate(to: .signup)
    }
    
}

extension LoginViewController :  UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            textField.resignFirstResponder()
            handleLoginAction()
        }
        return false
    }
    
}

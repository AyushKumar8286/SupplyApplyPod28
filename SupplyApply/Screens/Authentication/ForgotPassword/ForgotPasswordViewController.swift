//
//  ForgotPasswordViewController.swift
//  Deponet-Options
//
//  Created by Mac6 on 1/9/19.
//  Copyright © 2019 Mac6. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: CustomViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var otpContainer: UIView!
    @IBOutlet weak var otpTextField: UITextField!
    
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPassword: UIButton!
    
    @IBOutlet weak var confirmPasswordContainer: UIView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPassword: UIImageView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    var otp : String! {
        didSet{
            if let _ = otp {
                emailTextField.isUserInteractionEnabled = false
                if #available(iOS 11.0, *) {
                    emailTextField.textColor = Colors.tint
                } else {
                    // Fallback on earlier versions
                }
                actionButton.setTitle("RESET", for: .normal)
                otpContainer.isHidden = false
                passwordContainer.isHidden = false
                confirmPasswordContainer.isHidden = false
            } else {
                actionButton.setTitle("SEND CODE", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        containerView.addDesign(cornerRadius: 30, shadowWidth: 0, shadowHeight: 2, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        emailTextField.delegate = self
        otpTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(matchPassword), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(matchPassword), for: .editingChanged)
    }
    
    @objc func matchPassword(){
        if (confirmPasswordTextField.text != "") && (passwordTextField.text != "") && (confirmPasswordTextField.text == passwordTextField.text) {
            confirmPassword.isHidden = false
        } else {
            confirmPassword.isHidden = true
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.navigator.pop()
    }
    
    @IBAction func showPasswordTapped(_ sender: Any) {
        if passwordTextField.isSecureTextEntry{
            showPassword.setImage(UIImage(named: "eyeSlash"), for: .normal)
        } else {
            showPassword.setImage(UIImage(named: "eye"), for: .normal)
        }
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func resetPasswordButtonPressed() {
        if let _ = otp {
            self.resetPassword()
        } else {
            self.requestOTP()
        }
    }
    
    func requestOTP(){
        let email = emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        
        if Validator.isValidEmail(email) {
            if SHRestClient.isConnectedToInternet() {
                performOTPRequest(email: email)
            } else {
                self.showNoInternetWarning()
            }
        } else {
//            self.showToast(message : "Please enter a valid Email Address", type: .failure)
            self.view.makeToast("Please enter a valid Email Address")
        }
    }
    
    func performOTPRequest(email: String){
        self.showLoading(isLoading: true)
        SHRestClient.requestOTP(email: email) { result in
            self.showLoading(isLoading: false)
            switch result {
            case .success(let response):
                if response.success ?? false {
                    if let otp = response.data {
                        self.otp = otp
                    }
                } else {
//                    self.showToast(message : response.message ?? "Failed to Send Code. Please try after sometime", type: .failure)
                    self.view.makeToast(response.message ?? "Failed to Send Code. Please try after sometime")
                }
            case .failure(let error):
                print(error.localizedDescription)
//                self.showToast(message : "Failed to Send Code. Please try after sometime", type: .failure)
                self.view.makeToast("Failed to Send Code. Please try after sometime")
            }
        }
    }
    
    func resetPassword(){
        let email = emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        let otp = otpTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        let confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        
        if validateUserInput(otp: otp, password: password, confirmPassword: confirmPassword) {
            if SHRestClient.isConnectedToInternet() {
                performPasswordReset(email: email, otp: otp, password: password)
            } else {
                self.showNoInternetWarning()
            }
        }
    }
    
    func validateUserInput(otp: String, password: String, confirmPassword: String)-> Bool {
        let isValidOTP = Validator.isValidString(otp)
        let isValidPassword = Validator.isValidPassword(password)
        let confirmPassword = password == confirmPassword
        
        if !isValidOTP {
//            self.showToast(message : "Please enter a valid Code", type: .failure)
            self.view.makeToast("Please enter a valid Code")
            return false
        } else if !isValidPassword {
//            self.showToast(message : "Password must contain atleast 8 characters", type: .failure)
            self.view.makeToast("Password must contain atleast 8 characters")
            return false
        } else if !confirmPassword {
//            self.showToast(message : "Password & Confirm-Password does not match", type: .failure)
            self.view.makeToast("Password & Confirm-Password does not match")
            return false
        } else {
            return true
        }
    }
    func performPasswordReset(email: String, otp: String, password: String){
        self.showLoading(isLoading: true)
        SHRestClient.resetPassword(email: email, otp: otp, password: password) { result in
            self.showLoading(isLoading: false)
            switch result {
            case .success(let response):
                if response.success ?? false {
                    self.showAlertWithAction(title: "Reset Successful", message : response.message ?? "Your password has been changed successfully, Try signing in again with new Password.") {
                        self.navigator.pop()
                    }
                } else {
//                    self.showToast(message : response.message ?? "Failed to reset password. Please try after sometime", type: .failure)
                    self.view.makeToast(response.message ?? "Failed to reset password. Please try after sometime")
                }
            case .failure(let error):
                print(error.localizedDescription)
//                self.showToast(message : "Failed to reset password. Please try after sometime", type: .failure)
                self.view.makeToast("Failed to reset password. Please try after sometime")
            }
        }
    }
    
}

extension ForgotPasswordViewController :  UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            textField.resignFirstResponder()
            requestOTP()
        } else if textField == otpTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            textField.resignFirstResponder()
            resetPassword()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
}

//
//  SignUpViewController.swift
//  SupplyApply
//
//  Created by Yashvir on 19/03/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class SignUpViewController: CustomViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var confirmPasswordImageView: UIImageView!
    
    @IBOutlet weak var confrimTermsTextView: UITextView!
    @IBOutlet weak var confirmTermsImageView: UIImageView!
    @IBOutlet weak var confirmTerms: UIView!
    
    @IBOutlet weak var confirmLicenseTextView: UITextView!
    @IBOutlet weak var confirmLicenseImageView: UIImageView!
    @IBOutlet weak var confirmLicense: UIView!
    
    var isTermsConfirmed = false
    var isLicenseConfrimed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        containerView.addDesign(cornerRadius: 30, shadowWidth: 0, shadowHeight: 2, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        mobileTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(matchPassword), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(matchPassword), for: .editingChanged)
        
        
        let confirmTermsGesture = UITapGestureRecognizer(target: self, action: #selector(confirmTermsTapped))
        confirmTermsGesture.numberOfTapsRequired = 1
        confirmTerms.addGestureRecognizer(confirmTermsGesture)
        
        if #available(iOS 11.0, *) {
        let string = "By creating an account you agree to our Terms of Service & Privacy Policy"
        let range = (string as NSString).range(of: "Terms of Service & Privacy Policy")
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: Colors.label!
        ]
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        attributedString.addAttribute(NSAttributedString.Key.link, value: NSURL(string: "https://www.supply-apply.com/who-we-are")!, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.label!, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Colors.label!, range: range)
        
        confrimTermsTextView.tintColor = Colors.label
        confrimTermsTextView.attributedText = attributedString
        confrimTermsTextView.textContainer.lineFragmentPadding = 0
        
        let confirmLicenseGesture = UITapGestureRecognizer(target: self, action: #selector(confirmLicenseTapped))
        confirmLicenseGesture.numberOfTapsRequired = 1
        confirmLicense.addGestureRecognizer(confirmLicenseGesture)
        confirmLicenseTextView.textContainer.lineFragmentPadding = 0
        }
    }
    
    @objc func matchPassword(){
        if (confirmPasswordTextField.text != "") && (passwordTextField.text != "") && (confirmPasswordTextField.text == passwordTextField.text) {
            confirmPasswordImageView.isHidden = false
        } else {
            confirmPasswordImageView.isHidden = true
        }
    }
    
    @objc func confirmTermsTapped(){
        isTermsConfirmed = !isTermsConfirmed
        confirmTermsImageView.alpha = isTermsConfirmed ? 1.0 : 0.2
    }
    
    @objc func confirmLicenseTapped(){
        isLicenseConfrimed = !isLicenseConfrimed
        confirmLicenseImageView.alpha = isLicenseConfrimed ? 1.0 : 0.2
    }
    
    @IBAction func showPasswordTapped() {
        if passwordTextField.isSecureTextEntry{
            showPassword.setImage(UIImage(named: "eyeSlash"), for: .normal)
        } else {
            showPassword.setImage(UIImage(named: "eye"), for: .normal)
        }
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func createAccountTapped() {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        let mobile = mobileTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        
        if self.validateUserInput(name: name, email: email, mobile: mobile, password: password, confirmPassword: confirmPassword){
            if SHRestClient.isConnectedToInternet() {
                performSignup(name: name, email: email, mobile: mobile, password: password)
            } else {
                self.showNoInternetWarning()
            }
        }
    }
    
    func performSignup(name: String, email: String, mobile: String, password: String){
        self.showLoading(isLoading: true)
        SHRestClient.signup(name: name, email: email, mobile: mobile, password: password) { result in
            self.showLoading(isLoading: false)
            switch result {
            case .success(let response):
                if response.success ?? false {
                    self.showAlertWithAction(title: "Signup successful", message : "In order to complete signup you have to upload a photo or a PDF of your license.") {
                        self.navigator.navigate(to: .licenseValidate(customerId: response.customerID ?? "", delegate: self))
                    }
                } else {
//                    self.showToast(message : response.message ?? "Failed to Signup. Please try after sometime", type: .failure)
                    self.view.makeToast(response.message ?? "Failed to Signup. Please try after sometime")
                }
            case .failure(let error):
                print(error.localizedDescription)
//                self.showToast(message : "Failed to Signup. Please try after sometime", type: .failure)
                self.view.makeToast("Failed to Signup. Please try after sometime")
            }
        }
    }
    
    func validateUserInput(name: String, email: String, mobile: String, password: String, confirmPassword: String)-> Bool {
        let isValidName = Validator.isValidString(name)
        let isValidEmail = Validator.isValidEmail(email)
        let isValidMobile = Validator.isValidMobile(mobile)
        let isValidPassword = Validator.isValidPassword(password)
        let confirmPassword = password == confirmPassword
        
        if !isValidName {
//            self.showToast(message : "Please enter a valid Name", type: .failure)
            self.view.makeToast("Please enter a valid Name")
            return false
        } else if !isValidEmail {
//            self.showToast(message : "Please enter a valid Email Address", type: .failure)
            self.view.makeToast("Please enter a valid Email Address")
            return false
        } else if !isValidMobile {
//            self.showToast(message : "Please enter a valid Mobile Number", type: .failure)
            self.view.makeToast("Please enter a valid Mobile Number")
            return false
        } else if !isValidPassword {
//            self.showToast(message : "Password must contain atleast 8 characters", type: .failure)
            self.view.makeToast("Password must contain atleast 8 characters")
            return false
        } else if !confirmPassword {
//            self.showToast(message : "Password & Confirm-Password does not match", type: .failure)
            self.view.makeToast("Password & Confirm-Password does not match")
            return false
        } else  if !isTermsConfirmed {
//            self.showToast(message : "You can not proceed without accepting Terms & Conditions", type: .failure)
            self.view.makeToast("You can not proceed without accepting Terms & Conditions")
            return false
        } else  if !isLicenseConfrimed {
//            self.showToast(message : "You can not proceed if you don't have authorised License", type: .failure)
            self.view.makeToast("You can not proceed if you don't have authorised License")
            return false
        } else {
            return true
        }
    }
    
    
    @IBAction func backButtonTapped() {
        self.navigator.pop()
    }
    
    @IBAction func signinTapped() {
        self.navigator.pop()
    }
    
}

extension SignUpViewController :  UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField{
            mobileTextField.becomeFirstResponder()
        } else if textField == mobileTextField{
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField{
            confirmPasswordTextField.becomeFirstResponder()
        }
        else if textField == confirmPasswordTextField{
            textField.resignFirstResponder()
            createAccountTapped()
        }
        return false
    }
    
}

extension SignUpViewController : ExitControllerDelegate {
    
    func shouldPop() {
        self.navigator.popWithoutAnimation()
    }
}



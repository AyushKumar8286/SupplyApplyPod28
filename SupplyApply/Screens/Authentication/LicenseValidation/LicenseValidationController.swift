//
//  LicenseValidationController.swift
//  SupplyApply
//
//  Created by Yashvir on 20/03/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import MobileCoreServices

class LicenseValidationController: CustomViewController
{
    
    let documentPicker = UIDocumentPickerViewController(documentTypes:
        [ String(kUTTypePDF),
          String(kUTTypeJPEG),
          String(kUTTypePNG)
    ], in: .import)
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var fileData : Data! {
        didSet{
            if let _ = fileData {
                deleteButton.isHidden = false
                fileNameLabel.isHidden = false
            } else {
                deleteButton.isHidden = true
                fileNameLabel.isHidden = true
                imageView.image = UIImage(named: "Image Icon")
            }
        }
    }
    var fileExtension = "pdf"
    var delegate: ExitControllerDelegate!
    var customerId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    func setupViews(){
        let addPdfOrImageGesture = UITapGestureRecognizer(target: self, action: #selector(addPdfOrImage))
        addPdfOrImageGesture.numberOfTapsRequired = 1
        uploadView.addGestureRecognizer(addPdfOrImageGesture)
        
        
        let string = "Please upload a photo or a PDF of your license.\n\nAnd wait for your account confirmation. Usually it takes from 5 to 24 hours."
        let range = (string as NSString).range(of: "Please upload a photo or a PDF of your license.")

        if #available(iOS 11.0, *) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: Colors.label!
            ]
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        attributedString.addAttribute(NSAttributedString.Key.link, value: NSURL(string: "addPdfOrImage")!, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.label!, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Colors.label!, range: range)
        
        textView.tintColor = Colors.label
        textView.attributedText = attributedString
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        
        documentPicker.delegate = self
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.fileData = nil
    }
    
    @objc func addPdfOrImage(){
        self.present(documentPicker, animated: true)
    }
    
    @IBAction func continueTapped() {
        if SHRestClient.isConnectedToInternet() {
            
            if let data = fileData {
                let params : [String: Any] = [
                    "customer_id" : customerId ?? "",
                    "file" : data,
                    "token" : "75b3be012c122bddcfc8bf3f150f591f",
                    "type" : fileExtension
                ]
                
                self.showLoading(isLoading: true)
                SHRestClient.uploadLicense(params: params) { result in
                    self.showLoading(isLoading: false)
                    switch result {
                    case .success(let response):
                        if response.success ?? false {
                            self.showAlertWithAction(title: "Upload successful", message : response.message ?? "Account confirmation usually takes from 5 to 24 hours. When your account is confirmed, you'll receive a pin code on your phone. Please keep checking your messages to proceed.") {
                                if let delegate = self.delegate {
                                    delegate.shouldPop()
                                }
                                self.navigator.pop()
                            }
                        } else {
//                            self.showToast(message : response.message ?? "Failed to Upload License. Please try after sometime", type: .failure)
                            self.view.makeToast(response.message ?? "Failed to Upload License. Please try after sometime")
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
//                        self.showToast(message : "Failed to Upload License. Please try after sometime", type: .failure)
                        self.view.makeToast("Failed to Upload License. Please try after sometime")
                    }
                }
                
            } else {
//                self.showToast(message : "Please select a PDF or Image File to upload.", type: .failure)
                self.view.makeToast("Please select a PDF or Image File to upload.")
            }
        } else {
            self.showNoInternetWarning()
        }
    }
    
    @IBAction func cancelTapped() {
        if let delegate = delegate {
            delegate.shouldPop()
        }
        self.navigator.pop()
    }
    
}

extension LicenseValidationController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        self.addPdfOrImage()
        return false
    }
}

extension LicenseValidationController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let file = urls.first {
            
            do {
                self.fileData = try Data(contentsOf: file)
                self.fileExtension = file.pathExtension.lowercased()
                
                if fileExtension == "png" {
                    imageView.image = UIImage(named: "png")
                } else if fileExtension == "jpg" || fileExtension == "jpeg" {
                    imageView.image = UIImage(named: "jpg")
                } else if fileExtension == "pdf" {
                    imageView.image = UIImage(named: "pdf")
                }
                
                fileNameLabel.text = file.lastPathComponent
            } catch let error {
                print("Error: " + error.localizedDescription)
            }
        }
    }
    
}

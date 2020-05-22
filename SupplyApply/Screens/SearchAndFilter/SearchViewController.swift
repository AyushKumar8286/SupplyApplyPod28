//
//  SearchViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 05/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Speech
import Nuke

class SearchViewController: CustomViewController {

    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var subCategories : [Category] = []
    var searchProducts : [FilterProduct] = []
    var timer = Timer()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    //MARK:- IBOUTLET
    @IBOutlet weak var lblSearchProduct: UILabel!
    @IBOutlet weak var viewTableView: UITableView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var viewVoice: UIView!
    @IBOutlet var viewContent: UIView!
    @IBOutlet weak var txtViewVoiceresult: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btncCross: UIButton!
    @IBOutlet weak var iconVoice: UIImageView!
    @IBOutlet weak var btnVoice: UIButton!
    
    
   //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
//                    self.recordButton.isEnabled = true
                    break
                case .denied:
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    self.view.makeToast("User denied access to speech recognition")
                    
                case .restricted:
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    self.view.makeToast("Speech recognition restricted on this device")
                    
                case .notDetermined:
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                    self.view.makeToast("Speech recognition not yet authorized")
                }
            }
        }
    }
    //MARK:- PRIVATE METHODS
     private func setUpView() {
       
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        viewTableView.isHidden = true
        viewTableView.register(UINib(nibName: "SearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SearchTableViewCell")
        viewTableView.delegate = self
        viewTableView.dataSource = self
        txtFieldSearch.delegate = self
        viewVoice.isHidden = true
        btnSearch.isHidden = true
        btncCross.isHidden = true
    }
    
    private func getSearchList(search : String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            let params : [String: Any] = [
                "filter_name" : search
            ]
            
            self.showLoading(isLoading: true)
            SHRestClient.getSearchList(params: params, completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.searchProducts = response.products ?? []

                        if self.searchProducts.count == 0 {
                            self.viewTableView.isHidden = true
                            self.lblSearchProduct.isHidden = false
                            self.lblSearchProduct.text = response.message
                        } else {
                            self.viewTableView.isHidden = false
                            self.lblSearchProduct.isHidden = true
                            self.viewTableView.reloadData()
                        }
                        debugPrint(response)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    //                    self.parentVC.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            })
        } else {
            self.showNoInternetWarning()
        }
    }
    
    private func startRecording() throws {

        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record)
        try audioSession.setMode(AVAudioSession.Mode.measurement)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.txtViewVoiceresult.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
//                self.recordButton.isEnabled = true
//                self.recordButton.setTitle("Start Recording", for: [])
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
    }
    
    @objc func stopRecording() {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        
        viewContent.isUserInteractionEnabled = true
        viewContent.alpha = 1
        viewVoice.isHidden = true
    }
    
    //MARK:- IBACTION METHODS
    @IBAction func clickedBtnVoice(_ sender: Any) {
        viewContent.isUserInteractionEnabled = false
        viewContent.alpha = 0.2
        viewVoice.isHidden = false
    }
    
    @IBAction func clickedBtnVoiceBig(_ sender: Any) {
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self,   selector: (#selector(stopRecording)), userInfo: nil, repeats: false)
        try! startRecording()
        
//        if audioEngine.isRunning {
//            audioEngine.stop()
//            recognitionRequest?.endAudio()
//            recordButton.isEnabled = false
//            recordButton.setTitle("Stopping", for: .disabled)
//        } else {
//            try! startRecording()
//            recordButton.setTitle("Stop recording", for: [])
//        }
    }
    
    @IBAction func clcikedBtnSearch(_ sender: Any) {
        self.parentVC.navigator.navigate(to: .searchProduct(search: txtFieldSearch.text ?? "Search Product"))
    }
    
    @IBAction func clickedBtnCross(_ sender: Any) {
        
        txtFieldSearch.text = ""
        iconVoice.isHidden = false
        btnVoice.isHidden = false
        btnSearch.isHidden = true
        btncCross.isHidden = true
    }
}


//MARK:- TABLEVIEW DELEGATE AND DATA SOURCE

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        cell.selectionStyle = .none
        if let thumb = searchProducts[indexPath.row].image {
            let options = ImageLoadingOptions(
                placeholder: UIImage(named: "Image Icon"),
                transition: .fadeIn(duration: 0.0)
            )
            let url = URL(string: thumb)!
            Nuke.loadImage(with: url, options: options, into: cell.imageViewProduct)
        }
        cell.lblProductName.text = searchProducts[indexPath.row].name
        cell.lblProductPrice.text = searchProducts[indexPath.row].price
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let productname = searchProducts[indexPath.row].name ?? ""
        let productid = searchProducts[indexPath.row].productID ?? ""
        UserDefaults.standard.setProductID(value: productid)
        self.parentVC.navigator.navigate(to: .productInfo(productName: productname, productId: productid))
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}

//MARK:- TABLEVIEW DELEGATE AND DATA SOURCE

extension SearchViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField.text?.count ?? 0) > 1 {
//            viewTableView.isHidden = false
//            lblSearchProduct.isHidden = true
            self.getSearchList(search: textField.text ?? "")

            
        } else {
            lblSearchProduct.text = "Searching for product..."
            viewTableView.isHidden = true
            lblSearchProduct.isHidden = false
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if (textField.text?.count ?? 0) > 1 {
//            //            viewTableView.isHidden = false
//            //            lblSearchProduct.isHidden = true
//            self.getSearchList(search: textField.text ?? "")
//        } else {
//            lblSearchProduct.text = "Searching for product..."
//            viewTableView.isHidden = true
//            lblSearchProduct.isHidden = false
//        }
//        return true
//    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if (textField.text?.count ?? 0) > 1 {
            self.getSearchList(search: textField.text ?? "")
            iconVoice.isHidden = true
            btnVoice.isHidden = true
            btnSearch.isHidden = false
            btncCross.isHidden = false
        } else {
            lblSearchProduct.text = "Searching for product..."
            viewTableView.isHidden = true
            lblSearchProduct.isHidden = false
        }
    }
}

// MARK: SFSpeechRecognizerDelegate

extension SearchViewController : SFSpeechRecognizerDelegate {
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        if available {
//            recordButton.isEnabled = true
//            recordButton.setTitle("Start Recording", for: [])
//        } else {
//            recordButton.isEnabled = false
//            recordButton.setTitle("Recognition not available", for: .disabled)
//        }
    }
}

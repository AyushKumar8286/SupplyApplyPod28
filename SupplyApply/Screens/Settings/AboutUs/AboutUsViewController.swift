//
//  AboutUsViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 27/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import GoogleMaps

class AboutUsViewController: CustomViewController {

    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var aboutUsList : AboutUs?
    var lat : Double?
    var long : Double?
    
    //MARK:- IBOUTLET
    @IBOutlet weak var viewWebView: UIWebView!
    @IBOutlet weak var lblTelephone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblFax: UILabel!
    @IBOutlet weak var viewMap: UIView!
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        getAboutUsList()
    }

    
    //MARK:- PRIVATE METHODS
    private func setUpView() {
    
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        if let html = aboutUsList?.welcomeDescription {
            viewWebView.loadHTMLString(html, baseURL: nil)
        }
        
        lat = Double(aboutUsList?.storeLat ?? "") ?? 0
        long = Double(aboutUsList?.storeLong ?? "") ?? 0
        lblTelephone.text = aboutUsList?.storeTelephone
        lblAddress.text = aboutUsList?.storeAddress
        lblEmail.text = aboutUsList?.storeEmail
        lblFax.text = aboutUsList?.storeFax
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ?? 0, longitude: long ?? 0, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.viewMap.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat ?? 0, longitude: long ?? 0)
        marker.map = mapView
    }
    
    private func getAboutUsList() {

        if SHRestClient.isConnectedToInternet() {

            self.showLoading(isLoading: true)
            
            SHRestClient.aboutUs(completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.aboutUsList = response
                        self.setUpView()
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

    
    
    @IBAction func clickedBtnFacebook(_ sender: Any) {
        
        if let url = URL(string: aboutUsList?.facebookURL ?? ""), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func clcikedBtnCall(_ sender: Any) {
        if let url = URL(string: aboutUsList?.messenger ?? ""), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func clcikedBtnWatsApp(_ sender: Any) {
        if let url = URL(string: aboutUsList?.whatsapp ?? ""), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func clickedBtnInstagram(_ sender: Any) {
        
        if let url = URL(string: aboutUsList?.instagramURL ?? ""), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func clcikedBtnMessage(_ sender: Any) {
        if let url = URL(string: aboutUsList?.messenger ?? ""), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    @IBAction func clickedBtnMap(_ sender: Any) {
        
        let testURL: NSURL = NSURL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(testURL as URL) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:"https://www.google.com/maps?center=\(lat ?? 0),\(long ?? 0)&zoom=14&views=traffic&q=\(lat ?? 0),\(long ?? 0)")!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string:"https://www.google.com/maps?center=\(lat ?? 0),\(long ?? 0)&zoom=14&views=traffic&q=\(lat ?? 0),\(long ?? 0)")!)
            }
            
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:"https://www.google.com/maps?center=\(lat ?? 0),\(long ?? 0)&zoom=14&views=traffic&q=\(lat ?? 0),\(long ?? 0)")!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string:"https://www.google.com/maps?center=\(lat ?? 0),\(long ?? 0)&zoom=14&views=traffic&q=\(lat ?? 0),\(long ?? 0)")!)
            }
        }
    }
}

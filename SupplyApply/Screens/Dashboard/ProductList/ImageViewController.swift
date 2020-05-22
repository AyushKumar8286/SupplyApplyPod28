//
//  ImageViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 27/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Nuke

class ImageViewController: CustomViewController {

    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var productname : String?
    var productmodel : String?
    var productimage : String?
    
    //MARK:- IBOUTLET
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblSerialNumber: UILabel!
    @IBOutlet weak var imageViewProductImage: UIImageView!
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var viewTop: UIView!
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    //MARK:- PRIVATE METHODS
    
     private func setUpView() {
            
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }

        viewTop.layer.cornerRadius = viewTop.layer.bounds.height/2        
        parentVC.topBar.isHidden = true
        parentVC.constraintTopBarHeight.constant = 0.0
        
        viewTop.layer.cornerRadius = viewTop.layer.bounds.height/2
        viewScroll.delegate = self
        viewScroll.minimumZoomScale = 1.0
        viewScroll.maximumZoomScale = 10.0
        lblProductName.text = productname
        lblSerialNumber.text = productmodel
        let option = ImageLoadingOptions(
            placeholder: UIImage(named: "Image Icon"),
            transition: .fadeIn(duration: 0.0)
        )
        let url = URL(string: productimage ?? "")!
        Nuke.loadImage(with: url, options: option, into: imageViewProductImage)
        
            
        parentVC.rightTopBarItem.isHidden = true
        parentVC.bottomBar.isHidden = true
        parentVC.leftTopBarItem.layer.cornerRadius = 20
        parentVC.leftTopBarItem.layer.shadowRadius = 1
    }
    
    @IBAction func clickedBackBtn(_ sender: Any) {
        self.parentVC.navigator.pop()
    }
}

extension ImageViewController : UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return imageViewProductImage
    }
}

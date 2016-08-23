//
//  DetailMenuViewController.swift
//  OkonomiyakiBeacon
//
//  Created by BBaoBao on 7/3/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class DetailMenuViewController: UIViewController {

    // MARK: Variables
    
    var productObject:PFObject!
    var productImage:UIImageView = UIImageView()
    var productDes:UITextView = UITextView()
    var titleLabel = UILabel()
    let gradientView = GradientView()
    var isExpanded:Bool!
    @IBOutlet weak var btExit: MKButton!
    
    // MARK: View Did Load
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        self.view.backgroundColor = UIColor.blackColor()
        
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        
        isExpanded = false
        
        // Do any additional setup after loading the view.
        
        // Set drink label
        titleLabel.frame = CGRect(x: 0, y: dvHeight*2/3-50, width: dvWidth, height: 50)
        titleLabel.frame.insetInPlace(dx: 10, dy: 10)
        var priceFile:String = productObject["ProductPrice"] as! String
        titleLabel.attributedText = NSAttributedString.attributedStringForTitleText(productObject["ProductName"] as! String + " - " + priceFile)
        titleLabel.font = UIFont(name: "Helvetica-Light", size: 30)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.view.addSubview(titleLabel)
        //self.view.bringSubviewToFront(titleLabel)
        
        // Set drink description
        var desFile:String = productObject["ProductDescription"] as! String
        productDes.frame = CGRect(x: 0, y: dvHeight*2/3, width: dvWidth, height: 100)
        productDes.text = desFile
        productDes.font = UIFont(name: "Helvetica-Light", size: 15)
        productDes.textColor = UIColor.whiteColor()
        productDes.backgroundColor = UIColor.blackColor()
        productDes.editable = false
        productDes.selectable = false
        self.view.addSubview(self.productDes)
        self.view.bringSubviewToFront(self.productDes)
        
        // Set drink image
        var imageFile:PFFile = productObject["ProductImage"] as! PFFile
        imageFile.getDataInBackgroundWithBlock({(data, error) in
            if error == nil {
                self.productImage.frame = CGRect(x: 0, y: 0, width: dvWidth, height: (dvWidth*363)/305)
                self.productImage.image = UIImage(data: data!)
                self.view.addSubview(self.productImage)
                self.view.sendSubviewToBack(self.productImage)
                self.productImage.addSubview(self.gradientView)
                self.gradientView.frame = FrameCalculator.frameForGradient(featureImageFrame: self.productImage.frame)
                self.gradientView.setNeedsDisplay()
            }
        })
        
        // Exit Button
        btExit.cornerRadius = 30.0
        btExit.backgroundLayerCornerRadius = 30.0
        btExit.maskEnabled = false
        btExit.circleGrowRatioMax = 1.75
        btExit.rippleLocation = .Center
        btExit.aniDuration = 0.85
        self.view.bringSubviewToFront(btExit)
        
        btExit.layer.shadowOpacity = 0.75
        btExit.layer.shadowRadius = 3.5
        btExit.layer.shadowColor = UIColor.blackColor().CGColor
        btExit.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btExit(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewDidDisappear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }


}

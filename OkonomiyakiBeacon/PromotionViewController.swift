//
//  PromotionViewController.swift
//  OkonomiyakiBeacon
//
//  Created by BBaoBao on 7/1/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class PromotionViewController: UIViewController {

    var promotionsFileArray: NSArray = NSArray()
    var noticeLabel:UILabel = UILabel()
    var imageView:UIImageView = UIImageView()
    var promotionLabel:UILabel = UILabel()
    var beacons : AnyObject = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get beacons
        println(beacons)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateView:", name: "updateBeaconTableView", object: nil)
        queryParseMethod()
        self.view.backgroundColor = UIColor.MKColor.Blue
        noticeLabel.frame = CGRectMake(0, 0, self.view.frame.width, 200)
        noticeLabel.text = "Please go to nearby our restaurants to receive promotion information"
        noticeLabel.textColor = UIColor.whiteColor()
        noticeLabel.font = UIFont(name: "Helvetica Neue-Light", size: 20)
        noticeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        noticeLabel.numberOfLines = 0
        noticeLabel.textAlignment = .Center
        noticeLabel.center = self.view.center
        self.view.addSubview(noticeLabel)
        // Do any additional setup after loading the view.
        
        imageView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        imageView.image = UIImage(named: "Promotion.png")
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(imageView)
        self.view.bringSubviewToFront(imageView)
        imageView.hidden = true
        promotionLabel.frame = CGRectMake(0, 0, self.view.frame.width, 200)
        //Estimote
        estimoteFunction()
    }
    
    func updateView(note: NSNotification!){
        beacons = note.object!
        if beacons.count != 0 {
            imageView.hidden = false
            promotionLabel.hidden = false
            if promotionsFileArray.count != 0 {
                var promotionObject:PFObject = promotionsFileArray.objectAtIndex(promotionsFileArray.count-1) as! PFObject
                var imageFile:PFFile = promotionObject["PromotionImage"] as! PFFile
                imageFile.getDataInBackgroundWithBlock({(data, error) in
                    if error == nil {
                        self.imageView.image = UIImage(data: data!)
                        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                        self.view.addSubview(self.imageView)
                        self.view.bringSubviewToFront(self.imageView)
                    }
                })
                //promotionLabel.text = "今、わが店はこんの産品を１０%割り引くいたします。 \nいただきます！"
                promotionLabel.text = promotionObject["PromotionDescription"] as? String
                promotionLabel.textColor = UIColor.whiteColor()
                promotionLabel.font = UIFont(name: "Helvetica Neue-Light", size: 30)
                promotionLabel.numberOfLines = 0
                promotionLabel.textAlignment = NSTextAlignment.Center
                self.view.addSubview(promotionLabel)
                self.view.bringSubviewToFront(promotionLabel)
            }
        } else {
            imageView.hidden = true
            promotionLabel.hidden = true
        }
    }
    
    func estimoteFunction() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Define the query that will provide the data for the table view
    func queryParseMethod() {
        //println("Start query")
        var query = PFQuery(className: "Promotion")
        query.orderByAscending("PromotionID")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) promotions.")
                self.promotionsFileArray = objects!
                //println(self.promotionsFileArray)
            }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

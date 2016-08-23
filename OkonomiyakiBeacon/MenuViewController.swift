//
//  MenuViewController.swift
//  OkonomiyakiBeacon
//
//  Created by BBaoBao on 7/3/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var productsFileArray: NSArray = NSArray()
    var refreshControl: UIRefreshControl!
    let nodeConstructionQueue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set delegate and DataSource
        menuCollectionView!.dataSource = self
        menuCollectionView!.delegate = self
        // Config Refresh Control
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("imageRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.menuCollectionView?.addSubview(refreshControl)
        self.queryParseMethod()
        
        //Get device size
        let bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        
        //Change status bar color
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        /*
        // Transparent navigation bar
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clearColor()
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]*/
    }
    
    // Define the query that will provide the data for the table view
    func queryParseMethod() {
        print("Start query")
        var query = PFQuery(className: "Product")
        query.orderByAscending("ProductID")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Suprintlly retrieved \(objects!.count) products.")
                self.productsFileArray = objects!
                print(self.productsFileArray)
            }
            self.menuCollectionView.reloadData()
        }
    }
    
    // imageRefresh function
    func imageRefresh() {
        queryParseMethod()
        self.refreshControl.endRefreshing()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setting Collection View
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.productsFileArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCell", forIndexPath: indexPath) as! MenuCollectionViewCell
        
        // Configure the cell
        var drinkObject:PFObject = productsFileArray.objectAtIndex(indexPath.row) as! PFObject
        var imageFile:PFFile = drinkObject["ProductImage"] as! PFFile
        // Set init image if drink image in cell doesn't load.
        var initImage = UIImage(named: "DefaultProduct")
        //cell.drinkImageView.image = initImage
        cell.featureImageSizeOptional = initImage?.size
        //cell.titleLabel.attributedText = NSAttributedString.attributedStringForTitleText("Drink")
        imageFile.getDataInBackgroundWithBlock({(data, error) in
            if error == nil {
                cell.configureCellDisplayWithDrinkInfo(drinkObject, data: data!, nodeConstructionQueue: self.nodeConstructionQueue)
                
            }
        })
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var promotionObject:PFObject = productsFileArray.objectAtIndex(indexPath.row) as! PFObject
        self.performSegueWithIdentifier("DetailMenuSegue", sender: promotionObject)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailMenuSegue"){
            var detailDrinkView:DetailMenuViewController = segue.destinationViewController as! DetailMenuViewController
            detailDrinkView.productObject = sender as! PFObject
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 202, height: 240)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
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

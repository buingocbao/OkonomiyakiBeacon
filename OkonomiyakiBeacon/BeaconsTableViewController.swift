//
//  BeaconsTableViewController.swift
//  OkonomiyakiBeacon
//
//  Created by BBaoBao on 7/2/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class BeaconsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var beaconTableView: UITableView!
    var beacons : AnyObject = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(beacons)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateView:", name: "updateBeaconTableView", object: nil)
        //listen for notifications with selector updateView
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func updateView(note: NSNotification!){
        beacons = note.object!
        beaconTableView.reloadData() //update table data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return beacons.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell", forIndexPath: indexPath) as! UITableViewCell
        
        let major = beacons[indexPath.row].major as NSNumber
        var majorString = major.stringValue
        
        let minor = beacons[indexPath.row].minor as NSNumber
        var minorString = minor.stringValue
        
        let proximity = beacons[indexPath.row].proximity
        var proximityString = String()


        // Configure the cell...
        switch proximity!
        {
        case .Near:
            proximityString = "Near"
        case .Immediate:
            proximityString = "Immediate"
        case .Far:
            proximityString = "Far"
        case .Unknown:
            proximityString = "Unknown"
        }
        
        cell.textLabel?.text = "Major: \(majorString) Minor: \(minorString) \n Proximity: \(proximityString) "
        cell.textLabel?.numberOfLines = 0
        //display beacon values in cell text label

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

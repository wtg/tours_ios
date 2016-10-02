//
//  InfoViewController.swift
//  RPI Tours
//
//  Created by Jacob Speicher on 8/1/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import ReachabilitySwift
import CoreLocation
import TNImageSliderViewController

class InfoViewController: UITableViewController {
    
    //MARK: IBOutlets
    @IBOutlet var landmarkDescriptionLabel: UILabel!
    @IBOutlet var descriptionCell: UITableViewCell!
    
    //MARK: Global Variables
    var landmarkName:String = ""
    var landmarkDesc:String = ""
    var landmarkInformation: [Landmark] = []
    var imageSliderVC: TNImageSliderViewController!
    var landmark: Landmark = Landmark()
    
    @IBAction func pressedRouteTo(sender: AnyObject) {
        self.performSegueWithIdentifier("showDirections", sender: self)
    }
    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "imageSlider" {
            imageSliderVC = segue.destinationViewController as! TNImageSliderViewController
        }
        
        if segue.identifier == "showDirections" {
            let routeLand = Landmark(name: landmarkName, desc: landmarkDesc, lat: landmark.getLat(), long: landmark.getLong())
            let routeWaypoint = tourWaypoint(lat: landmark.getLat(), long: landmark.getLong())
            let routeTour = Tour(name: landmarkName, desc: landmarkDesc, distance: 0, duration: 0, waypoints: [routeWaypoint], landmarks: [routeLand])
            
            let controller = (segue.destinationViewController as! SelectedTourViewController)
            controller.selectedTour = routeTour
        }
    }
    
    //MARK: System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.landmarkName
        
        let chosenLandmark = searchForLandmark()
        landmark = chosenLandmark
        
        self.landmarkDescriptionLabel.text = chosenLandmark.getDesc()
        
        imageSliderVC.images = chosenLandmark.getImages()
        
        //set the imageSlider options
        var options = TNImageSliderViewOptions()
        options.pageControlHidden = false
        options.scrollDirection = .Horizontal
        options.shouldStartFromBeginning = true
        options.imageContentMode = .ScaleAspectFit
        options.pageControlCurrentIndicatorTintColor = UIColor.redColor()
        
        imageSliderVC.options = options
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Helper Functions
    func searchForLandmark() -> Landmark {
        for landmark in landmarkInformation {
            if landmark.getName() == self.landmarkName {
                return landmark
            }
        }
        
        let blankLandmark = Landmark(name: "landmarkName", desc: "I'm sorry, there is no information yet for this landmark.", lat: 0.0, long: 0.0)
        blankLandmark.setImages(["https://c1.staticflickr.com/5/4034/4544827697_6f73866999_b.jpg"])
        
        return blankLandmark
    }
    
    //MARK: TableView Functions
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return UITableViewAutomaticDimension
        }
        
        return 300
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return UITableViewAutomaticDimension
        }
        
        return 300
    }
}
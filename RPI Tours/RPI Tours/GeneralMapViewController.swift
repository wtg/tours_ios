//
//  GeneralMapViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/16/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation
import MapboxDirections

class GeneralMapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //MARK: IBOutlets
    @IBOutlet var mapView: MGLMapView!
    
    //MARK: Global Variables
    var tappedLandmarkName:String = ""
    //var tappedLandmarkDesc:String = ""
    
    //MARK: System Function
    override func viewDidLoad() {
        
        let locationManager = CLLocationManager()
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {

            let campusBuildings = buildCSV()

            
            super.viewDidLoad()
            
            
            //Put points on the map for the buildings on campus
            for item in campusBuildings {
                let point = MGLPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: item.buildingLat, longitude: item.buildingLong)
                point.title = item.buildingName
                
                mapView.addAnnotation(point)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Mapbox Helper Functions
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    func mapView(mapView: MGLMapView, tapOnCalloutForAnnotation annotation: MGLAnnotation) {
        tappedLandmarkName = annotation.title!!
        //tappedLandmarkDesc = annotation.subtitle!!
        self.performSegueWithIdentifier("showInfo", sender: self)
    }
    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showInfo" {
            let controller = segue.destinationViewController as! InfoViewController
            
            controller.landmarkName = self.tappedLandmarkName
            //controller.landmarkDesc = self.tappedLandmarkDesc
            
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem ()
            controller.navigationItem.leftItemsSupplementBackButton = true //Make a back button
        }
    }
    
    
}

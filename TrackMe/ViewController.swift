//
//  ViewController.swift
//  TrackMe
//
//  Created by robin on 2018-03-18.
//  Copyright © 2018 robin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation     // import this if you need to do something with the user's current location

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // -- MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
    
    // -- MARK: Variables
    var manager : CLLocationManager!
    var myLocations: [CLLocation] = []
    
    // -- MARK: Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // STEP 1: Set up our manager variable
        
        manager = CLLocationManager()
        manager.delegate = self
        
        // tell the gps how accurate we want the
        // location detection to be
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // ask the user for permission to get their location
        manager.requestAlwaysAuthorization()
        
        // get the user's current location
        manager.startUpdatingLocation()
        
        
        // STEP 2: Setup your map variable
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // -- MARK: Location functions
    
    
    // This function gets run every time the person's location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastPosition = locations.count-1
        label.text = "\(locations[lastPosition])"
        
        // update the map to show the person's current location
        let coordinate = mapView.userLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    
        // Take the person's location and add it to the myLocations array
        // myLocations stores the person's location as he moves around
        myLocations.append(locations[0] as CLLocation)
        
        // Draw line to show where the person is moving
        // You need minimum 2 coordinates in the array to draw a line,
        // therefore we put in a myLocations.count > 2 check to ensure
        // that there are enough coordinates in the array to draw the line.
        if (myLocations.count > 2) {
        
            let i = myLocations.count - 1     // most recent position (now)
            let j = myLocations.count - 2     // second most recent position (1 second ago)
        
            let pos1 = myLocations[i].coordinate
            let pos2 = myLocations[j].coordinate
        
            var abc = [pos1, pos2]
        
            // create a polyline
            let polyline = MKPolyline(coordinates: &abc, count: abc.count)
        
            // add the polyline to the map
            mapView.add(polyline)
        }

    }
    
    
    // -- MARK: UI Nonsense
    
    // this function shows a polyline on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // show the line on the map!
        if (overlay is MKPolyline) {
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            // pick a color for your line
            renderer.strokeColor = UIColor.magenta
            
            // pick a width for your line
            renderer.lineWidth = 2
            
            return renderer
            
        }
        return MKOverlayRenderer()

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


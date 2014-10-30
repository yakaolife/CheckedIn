//
//  MapViewViewController.swift
//  CheckedIn
//
//  Created by Cindy Zheng on 10/29/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit
import MapKit

class MapViewViewController: UIViewController , MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var events:[ParseEvent]?
    var geoLocations: [CLLocation]?
    var annotations: Array<MKPointAnnotation>!
    var center: CLLocationCoordinate2D!
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true , completion: nil	)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events Location"

        self.mapView.delegate = self
        //TODO: will filter events by segment control  
        fetechAllEvents()
        //TODO: will open location request , now using apple headquarter
        let myLocation = CLLocation(latitude: 37.4201828357191,longitude: -122.2141283997882)
        
        let center = myLocation.coordinate
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: center, span: self.mapView.region.span)
        self.mapView.setRegion(region, animated: true )
        self.mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
    }
    
    func fetechAllEvents(){
        var events = ParseEvent.query() as PFQuery
        events.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            self.events = objects as? Array
            for obj in objects {
                var event = obj as ParseEvent
                self.addAnotation(event)
            }
        }
    }
    func addAnotation(event:ParseEvent) {
        var geoLocation:CLLocation?
        var geocoder:CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(event.fullAddress, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                println("geolocation Error", error)
            }
            else {
                if let placemark = placemarks?[0] as? CLPlacemark {
                    var placemark:CLPlacemark = placemarks[0] as CLPlacemark
                    let lat = placemark.location.coordinate.latitude
                    let long = placemark.location.coordinate.longitude
                    let pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    pointAnnotation.title = event.EventName
                    self.mapView.addAnnotation(pointAnnotation)
                }
            }
        })
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIView
        }
        return view
    }
}

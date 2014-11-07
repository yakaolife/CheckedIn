//
//  EventMapTableViewCell.swift
//  CheckedIn
//
//  Created by Cindy Zheng on 11/2/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit
import MapKit


class EventMapTableViewCell: UITableViewCell,MKMapViewDelegate , UIAlertViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var urlString :String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.delegate = self
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func addAnotation(event:ParseEvent) {
        let annotation = myAnnotation()
        var geoLocation:CLLocation?
        var geocoder:CLGeocoder = CLGeocoder()
        let addressString = "http://maps.apple.com/?q=\(event.fullAddressWithoutZipCode!)"
        urlString = addressString.stringByReplacingOccurrencesOfString(" ", withString: "+")
        geocoder.geocodeAddressString(event.fullAddress!, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                println("geolocation Error", error)
            }
            else {
                if let placemark = placemarks?[0] as? CLPlacemark {
                    var placemark:CLPlacemark = placemarks[0] as CLPlacemark
                    let lat = placemark.location.coordinate.latitude
                    let long = placemark.location.coordinate.longitude
                    let pointAnnotation:myAnnotation = myAnnotation()
                    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    pointAnnotation.title = event.fullAddress!
                    pointAnnotation.objectID = event.objectId
                    
                    annotation.setCoordinate(placemark.location.coordinate)
                    self.mapView.addAnnotation(pointAnnotation)
                    self.mapView.setRegion(MKCoordinateRegion(center: placemark.location.coordinate, span: MKCoordinateSpanMake(0.01, 0.01)), animated: false)
                    self.mapView.layer.cornerRadius = 9.0
                    self.mapView.layer.masksToBounds = true
     
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

    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        if control == view.rightCalloutAccessoryView {
            if let eventAnnotation = view.annotation  as? myAnnotation {
                let alertView = UIAlertView(title: "show in map", message: "will open map application", delegate: self, cancelButtonTitle: "cancel", otherButtonTitles: "Ok")
                alertView.show()
    
             }
        }
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 1 {
            let url = NSURL(string: self.urlString!)
            UIApplication.sharedApplication().openURL(url!)
        }
    }
}

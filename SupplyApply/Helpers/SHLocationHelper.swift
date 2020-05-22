//
//  SHLocationHelper.swift
//  amey-operativeLive
//
//  Created by Shashi on 08/05/19.
//  Copyright © 2019 Mac6. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Contacts

protocol SHLocationDelegate {
    func didGetLocation(location : CLLocation?)
    func didGetAddress(address : String, location: CLLocation?)
}

class SHLocationHelper : NSObject, CLLocationManagerDelegate {
    
    static let shared = SHLocationHelper()
    private override init(){}
    private var locationManager = CLLocationManager()
    var delegate : SHLocationDelegate!
    private var shouldFetchAddress = false
    
    func determineMyCurrentLocation() {
        shouldFetchAddress = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func getUserAddress() {
        shouldFetchAddress = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func getAdressName(location: CLLocation){
        var adressString : String = ""
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("Hay un error")
            } else {
                let place = placemark! as [CLPlacemark]
                if #available(iOS 11.0, *) {
                    adressString = self.getFormatedAddress(places: place)
                }else{
                    if place.count > 0 {
                        let place = placemark![0]
                        
                        if place.thoroughfare != nil {
                            adressString = adressString + place.thoroughfare! + ", "
                        }
                        if place.subThoroughfare != nil {
                            adressString = adressString + place.subThoroughfare! + "\n"
                        }
                        if place.locality != nil {
                            adressString = adressString + place.locality! + " - "
                        }
                        if place.postalCode != nil {
                            adressString = adressString + place.postalCode! + "\n"
                        }
                        if place.subAdministrativeArea != nil {
                            adressString = adressString + place.subAdministrativeArea! + " - "
                        }
                        if place.country != nil {
                            adressString = adressString + place.country!
                        }
                        
                    }
                    
                }
                
                
            }
            
            self.delegate?.didGetAddress(address: adressString, location: location)
        }
    }
    
    func getCordinateForAddressText(_ address:String, getLocationCompleationHandler: @escaping (CLLocationCoordinate2D?) -> ()) {
        var returnLocation:CLLocationCoordinate2D? = CLLocationCoordinate2D()
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            let placemark = placemarks?.first
            returnLocation = placemark?.location?.coordinate
            getLocationCompleationHandler(returnLocation)
        }
        
    }
    
    func getLocationForAddress(address : String) -> (Double, Double){
        var locationCoordinates : CLLocation!
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if let location = placemarks.first?.location{
                    locationCoordinates = location
                }
            }
        }
        if let location = locationCoordinates{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            return (lat,lon)
        } else{
            return (0,0)
        }
        
    }
    
    private func getFormatedAddress(places : [CLPlacemark]?) -> String{
        guard let place = places?.first else {
            print("No placemark from Apple:)")
            return ""
        }
        
        let postalAddressFormatter = CNPostalAddressFormatter()
        postalAddressFormatter.style = .mailingAddress
        var addressString: String?
        if #available(iOS 11.0, *) {
            if let postalAddress = place.postalAddress {
                addressString = postalAddressFormatter.string(from: postalAddress)
            }
        } else {
            // Fallback on earlier versions
        }
        
        return addressString ?? ""
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()
        manager.stopMonitoringSignificantLocationChanges()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        if(shouldFetchAddress){
            self.getAdressName(location: userLocation)
        }else{
            delegate?.didGetLocation(location: userLocation)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
        if(shouldFetchAddress){
            delegate?.didGetAddress(address: "", location: nil)
        }else{
            delegate?.didGetLocation(location: nil)
        }
    }
    
}

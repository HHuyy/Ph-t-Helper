//
//  GMapViewController.swift
//  App
//
//  Created by Đừng xóa on 9/8/18.
//  Copyright © 2018 Đừng xóa. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
typealias DICT = Dictionary<AnyHashable, Any>

class GMapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconMe: UIImageView!
    var iconStatus: Bool = false
    var currentLocation: CLLocationCoordinate2D?
    var searchLocation: CLLocationCoordinate2D?
    let marker = GMSMarker()
    var polylineArr = GMSPolyline()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            guard let address = response?.firstResult(), let line = address.lines else {return}
            
            self.addressLabel.text = line.joined(separator: "\n")
            
            let labelHeight = self.addressLabel.intrinsicContentSize.height
            self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: labelHeight, right: 0)
            
            UIView.animate(withDuration: 0.25) {
                self.pinImageVerticalConstraint.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5)
                self.view.layoutIfNeeded()
            }
        }
    }

    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        marker.map = nil
        polylineArr.map = nil
    }
    
    @IBAction func ShowHideIconButton(_ sender: UIButton) {
        if iconStatus == false {
            addressLabel.isHidden = true
            iconMe.isHidden = true
            iconStatus = true
        } else {
            addressLabel.isHidden = false
            iconMe.isHidden = false
            iconStatus = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension GMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        currentLocation = manager.location?.coordinate
        locationManager.stopUpdatingLocation()
    }
}

extension GMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
}

extension GMapViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        searchLocation = place.coordinate
        mapView.camera = GMSCameraPosition.camera(withLatitude: (searchLocation?.latitude)!, longitude: (searchLocation?.longitude)!, zoom: 15)
        showMaker(position: mapView.camera.target)
        getPolylineRoute(from: currentLocation!, to: searchLocation!)
        dismiss(animated: true, completion: nil)
    }
    
    func showMaker(position: CLLocationCoordinate2D) {
        marker.position = position
        marker.map = mapView
    }
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&units=metric")!
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "-9999999999999")
                return
            }
            guard let aData = data else {return}
            do {
                if let json = try JSONSerialization.jsonObject(with: aData, options: .mutableContainers) as? DICT {
                    let routes = json["routes"] as? [DICT] ?? []
                    let zero = routes[0]
                    let overview_polyline = zero["overview_polyline"] as? DICT ?? [:]
                    let points = overview_polyline["points"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self.showPath(polyStr: points)
                    }
                }
            } catch {
                print("error in JSONSerialization")
            }
        })
        task.resume()
    }
    
    func showPath(polyStr: String) {
        polylineArr.map = nil
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView
        polylineArr = polyline
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

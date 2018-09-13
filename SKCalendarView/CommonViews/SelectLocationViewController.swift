//
//  SelectLocationViewController.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/31.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol SelectLocationDelegate {
    func selecteLocation(location: String)
}

class SelectLocationViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate, UITableViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnConfirm: UIBarButtonItem!
    
    var delegate: SelectLocationDelegate?
    
    let locationMgr = CLLocationManager()
    let geoCorder = CLGeocoder()
    var querying = false
    var locationNames = [String]()
    var selectedLocationName: String?
    var needUpdateUserLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "LocationNameCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "locationNameCell")
        
        locationMgr.delegate = self
        locationMgr.requestWhenInUseAuthorization()
        locationMgr.startUpdatingLocation()
        locationMgr.desiredAccuracy = 5
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsBuildings = true
        mapView.delegate = self
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.delegate = self
        panGestureRecognizer.addTarget(self, action: #selector(pan(_:)))
        mapView.addGestureRecognizer(panGestureRecognizer)
        
        btnConfirm.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocationName = locationNames[indexPath.row]
        btnConfirm.isEnabled = true
    }
    
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .ended:
            needUpdateUserLocation = false
            queryNames(location: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
            break;
        default:
            break;
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnConfirmTapped(_ sender: Any) {
        delegate?.selecteLocation(location: selectedLocationName ?? "")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLocationTapped(_ sender: Any) {
        needUpdateUserLocation = true
        guard let coordinate = mapView.userLocation.location?.coordinate else {
            return
        }
        mapView.setCenter(coordinate, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationNames.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationNameCell", for: indexPath) as! LocationNameCell
        cell.labelTitle.text = locationNames[indexPath.row]
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //todo
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locations.forEach({(location) in
//            print("location: \(location)")
//        })
        if needUpdateUserLocation {
            queryNames(location: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("current location: \(mapView.userLocation.location)")
            guard let coordinate = mapView.userLocation.location?.coordinate else {
                return
            }
            mapView.setCenter(coordinate, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("userLocation: \(userLocation)")
    }
    
    func queryNames(location: CLLocation) {
        if querying {
            return
        }
        locationNames.removeAll()
        tableView.reloadData()
        querying = true
        geoCorder.reverseGeocodeLocation(location, completionHandler: {(placeMarks, error) in
            self.querying = false
            if error != nil {
                print("error: \(error!)")
//                let alert = UIAlertController(title: "系统提示", message: error?.localizedDescription, preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(action) in
////                    self.dismiss(animated: true, completion: nil)
//                })
//                let retryAction = UIAlertAction(title: "重试", style: .default, handler: {(action) in
//                    self.queryNames(location: location)
//                })
//                alert.addAction(cancelAction)
//                alert.addAction(retryAction)
//                self.present(alert, animated: true, completion: nil)
            } else {
                placeMarks?.forEach({(placeMark) in
                    print("placemark: \(placeMark.subLocality)")
                    if placeMark.thoroughfare != nil {
                        var name = placeMark.thoroughfare!
                        if placeMark.subThoroughfare != nil {
                            name.append(placeMark.subThoroughfare!)
                        }
                        self.locationNames.append(placeMark.thoroughfare!)
                    }
                })
                
                self.tableView.reloadData()
                if self.locationNames.count > 0 {
                    self.selectedLocationName = self.locationNames[0]
                    self.btnConfirm.isEnabled = true
                    self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
                } else {
                    self.btnConfirm.isEnabled = false
                }
            }
        })
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

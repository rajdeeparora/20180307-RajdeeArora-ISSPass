//
//  ViewController.swift
//  JPMCCode
//
//  Created by Rajdeep Arora on 3/6/18.
//  Copyright © 2018 Rajdeep Arora. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource {
    
    var locationManager = CLLocationManager()
    private var currentPassesArray: NSArray = []
    private var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.setupIntialView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func showAlertMessage(messageTitle: NSString, withMessage: NSString) ->Void  {
        let alertController = UIAlertController(title: messageTitle as String, message: withMessage as String, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Settings", style: .default) { (action:UIAlertAction!) in
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION/com.company.AppName") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        getLocationStatus()
    }
    
    func setupIntialView(){
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    func getLocationStatus(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        // Here you can check whether you have allowed the permission or not.
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorize.")
                if  let latitude: CLLocationDegrees = (locationManager.location?.coordinate.latitude),
                    
                    let longitude: CLLocationDegrees = (locationManager.location?.coordinate.longitude){
                _ = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
                
                
                let strUrl = String(format: urlforpass, latitude , longitude)
                ServicesCall.sharedInstance.executeService(urlPath: strUrl, httpMethodType: "GET", body: nil) { (result, error) in
                    if let error = error {
                        appDelegate.simpleAlertWithTitleAndMessage(messageFromError(error))
                    } else {
                        DispatchQueue.main.async {
                            if let result = result as? [String: Any] {
                                if let responseArr = result["response"] as? NSMutableArray {
                                    self.currentPassesArray = responseArr
                                }
                            }
                            self.myTableView.reloadData()
                        }
                    }
                }
                }
                else {
                    DispatchQueue.main.async {
                        appDelegate.simpleAlertWithTitleAndMessage(("Error", "Unable To Find the Location Coordinate"))
                    }
                }
                break
                
            case .notDetermined:
                print("Not determined.")
                self.showAlertMessage(messageTitle: "Bolo Board", withMessage: "Location service is disabled!!")
                break
                
            case .restricted:
                print("Restricted.")
                self.showAlertMessage(messageTitle: "Bolo Board", withMessage: "Location service is disabled!!")
                break
                
            case .denied:
                print("Denied.")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Value: \(currentPassesArray[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPassesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if currentPassesArray.count > 0 {
            return 0.0
        }
        
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier: String = "MyCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CellIdentifier)
        }

        if let dictDisplay = self.currentPassesArray[indexPath.row] as? [String: Any] {
            if let duration = dictDisplay["duration"] as? Double {
                cell.textLabel?.text = "Duration: " + String(duration)
            }
            
            if let risetime = dictDisplay["risetime"] as? Double {
                cell.detailTextLabel?.text = "Time: " +  risetime.getTheDateFromTime(timestamp: risetime)
            }
        }
        return cell
    }
    
    
    
}


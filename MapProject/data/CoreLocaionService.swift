//
//  CoreLocaionService.swift
//  CathAssist
//
//  Created by yaojinhai on 2019/5/12.
//  Copyright © 2019年 CathAssist. All rights reserved.
//

import UIKit
import CoreLocation

protocol CoreLocaionServiceDelegate: NSObjectProtocol {
    func didEndUpLocaion(service: CoreLocaionService,coordinate: CLLocationCoordinate2D);
}

class CoreLocaionService: NSObject,CLLocationManagerDelegate {

    private var locaionService: CLLocationManager!
    weak var delegate: CoreLocaionServiceDelegate?
    override init() {
        super.init();
        locaionService = CLLocationManager();
        locaionService.delegate = self;
        locaionService.requestWhenInUseAuthorization();
        locaionService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locaionService.distanceFilter = 100;
        locaionService.startUpdatingLocation();
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error =\(error)");
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation();
        guard let lastLocaion = locations.last else{
            return;
        }
        delegate?.didEndUpLocaion(service: self, coordinate: lastLocaion.coordinate);
    }
}


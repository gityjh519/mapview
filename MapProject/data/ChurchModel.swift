//
//  ChurchModel.swift
//  CathAssist
//
//  Created by yaojinhai on 2019/5/11.
//  Copyright © 2019年 CathAssist. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ChurchModel: BaseModel,MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
    }
    var title: String? {
        return name;
    }
    var subtitle: String? {
        return address;
    }
    

    @objc var address = "";
    @objc var city = "";
    @objc var distance: Double = 0;
    @objc var district = "";
    @objc var fromId = "";
    @objc var fromType = 0;
    @objc var gpsAddress = "";
    @objc var id = 0;
    @objc var name = "";
    @objc var nation = "";
    @objc var province = "";
    @objc var shortName = "";
    @objc var updateTime = "";
    @objc var latitude: Double = 0;
    @objc var longitude: Double = 0;
    
    var extenInfo: ExtendModel!
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "extend":
            guard let dict = value as? NSDictionary else{
                return;
            }
            extenInfo = ExtendModel(dictM: dict);
            
        default:
            super.setValue(value, forKey: key);
        }
    }
    
    class ExtendModel: BaseModel {
        @objc var catechismClass = "";
        @objc var introduce = "";
        @objc var massSunday = "";
        @objc var massVigil = "";
        @objc var massWeekly = "";
        @objc var telephone = "";
    }
    
    
}

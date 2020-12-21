//
//  AppSetting.swift
//  Menu
//
//  Created by YoussefRomany on 21/12/2020.
//  Copyright © 2020 FoodicsCompany. All rights reserved.
//

import Foundation

class AppSetting: Codable{
    
    static let shared = AppSetting()
    
    var isDownloadData = false

    init(){
        getStoredData()
    }
    
    func storeData(){
        sharedPref.shared.setSharedValue("isDownloadData", value: self.isDownloadData)
        getStoredData()

    }
    
     func getStoredData(){
        self.isDownloadData = sharedPref.shared.getSharedValue(forKey: "isDownloadData") as? Bool ?? false

    }
    
    func logout(){
        sharedPref.shared.removeValue(forKey: "isDownloadData")
        getStoredData()
    }

}

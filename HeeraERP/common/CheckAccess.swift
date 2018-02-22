//
//  CheckAccess.swift
//  HeeraERP
//
//  Created by Suvan on 1/2/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit
import Photos

class CheckAccess {
    //**** check permission access for photo library
    class func checkPermission() {
        print("called CheckAccess")
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted ")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        }
    }
    
}

//
//  Barcode.swift
//  HeeraERP
//
//  Created by Suvan on 12/22/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit
import CoreImage

class Barcode {
    //**** generate barcode image from string
    class func fromString(string : String) -> UIImage? {
        let data = string.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
       // filter?.setValue(7.00, forKey: "inputQuietSpace")
        return UIImage(ciImage: (filter?.outputImage)!)
        
//        let data = string.data(using: String.Encoding.ascii)
//        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
//            filter.setDefaults()
//            //**** Margin
//            //filter.setValue(7.00, forKey: "inputQuietSpace")
//            filter.setValue(data, forKey: "inputMessage")
//            //**** Scaling
//            let transform = CGAffineTransform(scaleX: 1, y: 1)
//            //**** clearing the clarity of output image
//            if let output = filter.outputImage?.transformed(by: transform) {
//                return UIImage(ciImage: output)
//            }
//        }
//        return nil
    }
}

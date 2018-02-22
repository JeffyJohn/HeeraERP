//
//  ActivityIndicator.swift
//  HeeraERP
//
//  Created by Suvan on 1/20/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class ActivityIndicator {
    static var activity : UIActivityIndicatorView = UIActivityIndicatorView()
    static var overlay = UIView()
    //**** loading indicator
    class func startAnimating_LoadingIndicator(view: UIView){
        //**** overlay black background view
        overlay = UIView(frame: view.frame)
        overlay.center = view.center
        overlay.backgroundColor = UIColor(red: 0, green: 0, blue:0, alpha: 0.5)
        view.addSubview(overlay)
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activity)
        activity.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents() // For ignoring events
    }
    class func stopAnimating_LoadingIndicator(){
        overlay.removeFromSuperview()
        activity.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
//    var myActivityIndicator:UIActivityIndicatorView!
//    func StartActivityIndicator(obj:UIViewController) -> UIActivityIndicatorView
//    {
//        self.myActivityIndicator = UIActivityIndicatorView(frame:CGRect(x: 100, y: 100, width: 100, height: 100)) as UIActivityIndicatorView
//        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        self.myActivityIndicator.center = obj.view.center;
//        obj.view.addSubview(myActivityIndicator);
//        self.myActivityIndicator.startAnimating();
//        return self.myActivityIndicator;
//    }
//    func StopActivityIndicator(obj:UIViewController,indicator:UIActivityIndicatorView)-> Void
//    {
//        indicator.removeFromSuperview();
//    }
}

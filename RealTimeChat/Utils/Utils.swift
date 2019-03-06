//
//  Utils.swift
//  The Avenue Agent
//
//  Created by Peter Bassem on 5/11/18.
//  Copyright © 2018 Ashraf Essam. All rights reserved.
//

import Foundation
import UIKit
//import NVActivityIndicatorView
//import Kingfisher

extension UIApplication {
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
}

extension UIViewController {
    
    //MARK:- Properties
    static var progressView: NVActivityIndicatorView?
    static var noInternetConnectionViewController: NoInternetConnectionViewController?
    static var noDataAvailableViewController: NoDataViewController?
    
    //MARK:- Functions
    func showMessage(title: String, message: String) {
        let messageAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default, handler: nil)
        messageAlert.addAction(okButton)
        present(messageAlert, animated: true, completion: nil)
    }
    
    func showMessageWithCompletionHandler(title: String, message: String, onCompletion completion: @escaping () -> Void) {
        let messageAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default) { (alert) in
            completion()
        }
        messageAlert.addAction(okButton)
        present(messageAlert, animated: true, completion: nil)
    }
    
    func showMessageWithTwoButtonsWithCompletionHandler(title: String, message: String, onOkCompletion okCompletion: @escaping () -> Void, onCancelCompletion cancelCompletion: @escaping () -> Void) {
        let messageAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default) { (alert) in
            okCompletion()
        }
        let cancelButton = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), style: UIAlertAction.Style.destructive) { (alert) in
            cancelCompletion()
        }
        messageAlert.addAction(okButton)
        messageAlert.addAction(cancelButton)
        present(messageAlert, animated: true, completion: nil)
    }
    
    func setNavigationBarItems(title: String) {
        navigationItem.title = title
        navigationController?.navigationBar.barTintColor =  COLORS.mainColor
        navigationController?.navigationBar.tintColor = COLORS.navigationBarTintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: setFont(size: 22.0, isBold: false) ,NSAttributedString.Key.foregroundColor: COLORS.navigationBarTitleTextAttributes]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: COLORS.navigationBarTitleTextAttributes]
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupStatusBar() {
        UIApplication.statusBarBackgroundColor = COLORS.mainStatusBarColor
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    
//    TO ADD FONTS TO PROJECT
//    1- In app target -> Build Phases -> Copy Bundle Resources -> Add Fonts
//    2- In Info.plist add:
//    <key>UIAppFonts</key>
//    <array>
//    <string>Bariol_Bold.otf</string>
//    <string>bariol.ttf</string>
//    <string>noto.ttf</string>
//    <string>NotoKufiArabic-Bold.ttf</string>
//    </array>
    
    func setFont(size fontSize: CGFloat, isBold bold: Bool) -> UIFont {
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            return UIFont(name: bold ? "Bariol-Bold" : "Bariol-Regular", size: fontSize)!
        } else {
            return UIFont(name: bold ? "NotoKufiArabic-Bold" : "NotoKufiArabic", size: (fontSize - 2.0))!
        }
    }
    
    
    func activityIndicator(isActive active: Bool) {
        if active {
            UIViewController.progressView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 30, y: self.view.center.y - 30, width: 60, height: 60), type: .ballRotateChase, color: COLORS.activityIndicatorColor, padding: 0)
            let mask = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            mask.backgroundColor = UIColor.lightGray
            UIViewController.progressView?.mask = mask
            self.view.addSubview(UIViewController.progressView!)
            self.view.resignFirstResponder()
            UIViewController.progressView?.startAnimating()
            self.view.isUserInteractionEnabled = false
        } else {
            if UIViewController.progressView != nil {
                UIViewController.progressView?.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func showNoInternetView(isActive active: Bool) {
        if UIViewController.noInternetConnectionViewController == nil  {
          UIViewController.noInternetConnectionViewController = (UIStoryboard(name: "ViewUtils", bundle: nil).instantiateViewController(withIdentifier: "no_internet_connection_view_controller") as! NoInternetConnectionViewController)
        }
        if active {
            removeViewControllerAsChildViewController(childView: UIViewController.noInternetConnectionViewController!)
        } else  {
            addViewControllerAsChildViewController(childView: UIViewController.noInternetConnectionViewController!)
        }
    }
    
    func addViewControllerAsChildViewController(childView: UIViewController) {
        addChild(childView)
        self.view.addSubview(childView.view)
        
        childView.view.frame = UIApplication.shared.keyWindow!.frame
        UIApplication.shared.keyWindow!.addSubview(childView.view)
//        UIApplication.statusBarBackgroundColor = .red
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        childView.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childView.didMove(toParent: self)
    }
    
    func removeViewControllerAsChildViewController(childView: UIViewController) {
        childView.willMove(toParent: nil)
        childView.view.removeFromSuperview()
        childView.removeFromParent()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    func addNoDataViewControllerAsChildViewController(childView: UIViewController, type: String) {
        addChild(childView)
        self.view.addSubview(childView.view)
        
        if type == "saved" {
            childView.view.frame = CGRect(x: 0, y: 60, width: UIApplication.shared.keyWindow!.frame.width, height: UIApplication.shared.keyWindow!.frame.height)
            childView.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            childView.didMove(toParent: self)
        } else if type == "category" {
            childView.view.frame = UIApplication.shared.keyWindow!.frame
            childView.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            childView.didMove(toParent: self)
        } else if type == "search" {
            childView.view.frame = CGRect(x: 0, y: 56, width: UIApplication.shared.keyWindow!.frame.width, height: UIApplication.shared.keyWindow!.frame.height)
            childView.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            childView.didMove(toParent: self)
        }
    }
    
    func showNoDataView(isActive active:Bool, dataType: String) {
        if UIViewController.noDataAvailableViewController == nil {
            UIViewController.noDataAvailableViewController = (UIStoryboard(name: "ViewUtils", bundle: nil).instantiateViewController(withIdentifier: "no_data_view_controller") as? NoDataViewController)
        }
        if active {
            addNoDataViewControllerAsChildViewController(childView: UIViewController.noDataAvailableViewController!, type: dataType)
        } else {
            removeViewControllerAsChildViewController(childView: UIViewController.noDataAvailableViewController!)
        }
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

extension UIView {
    func setFont(size fontSize: CGFloat, isBold bold: Bool) -> UIFont {
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            return UIFont(name: bold ? "Bariol-Bold" : "Bariol-Regular", size: fontSize)!
        } else {
            return UIFont(name: bold ? "NotoKufiArabic-Bold" : "NotoKufiArabic", size: (fontSize - 2.0))!
        }
    }
}


extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(from: url as! Decoder) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}

extension Date {
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func toMillis() -> NSNumber {
        return NSNumber(value:Int64(timeIntervalSince1970 * 1000))
    }
    
    static func fromMillis(millis: NSNumber?) -> NSDate? {
        return millis.map() { number in NSDate(timeIntervalSince1970: Double(number) / 1000)}
    }
    
    static func currentTimeInMillis() -> NSNumber {
        return Date().toMillis()
    }
    
    func dateToString(_ format: String) -> String {
        DateFormats.getInstance().dateFormatter.dateFormat = format
        return DateFormats.getInstance().dateFormatter.string(from: self as Date)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
//    func offset(from date: Date) -> String {
//        if years(from: date)   > 0 { return "\(years(from: date))y"   }
//        if months(from: date)  > 0 { return "\(months(from: date))M"  }
//        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
//        if days(from: date)    > 0 { return "\(days(from: date))d"    }
//        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
//        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
//        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
//        return ""
//    }
    
    func offset(from date: Date) -> String {
        var hour: String = "\(hours(from: date))", minute: String = "\(minutes(from: date))"
        if hours(from: date) <= 10 {
            hour = "0\(hours(from: date))"
        }
        if minutes(from: date) <= 10 {
            minute = "0\(minutes(from: date))"
        }
        return "\(hour):\(minute)"
    }
}

extension String {
//    var formatted: Date? {
//        let dateFormatted = DateFormatter()
//        dateFormatted.dateFormat = "dd-MM-yyyy"
////        guard let formattedDate = dateFormatted.date(from: self as String) else { return }
//        return formattedDate
//    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        if UIDevice.modelName.contains("5") {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width/7 , bottom: 0, right: self.frame.width/7)
        } else {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width/4 , bottom: 0, right: self.frame.width/4)
        }
        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.setImage(image.withRenderingMode(renderMode), for: UIControl.State.normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: image.size.width / 2)
        self.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    }

    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        if UIDevice.modelName.contains("5") {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width/8 , bottom: 0, right: self.frame.width/8)
        } else {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width/5 , bottom: 0, right: self.frame.width/5)
        }
        self.setImage(image.withRenderingMode(renderMode), for: UIControl.State.normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: image.size.width / 2, bottom: 0, right: 16)
        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        self.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    }
}

extension UIColor {
    
    convenience init(hexString: String) {
        
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (0, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

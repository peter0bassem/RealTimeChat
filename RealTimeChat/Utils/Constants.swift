//
//  VARIABLES.swift
//  The Avenue Agent
//
//  Created by iMac on 7/19/18.
//  Copyright © 2018 Ashraf Essam. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    static let userDefaults = UserDefaults.standard
    static let rootViewController = UIApplication.shared.delegate as? AppDelegate
    
//    static let EMAIL_KEY = "email"
//    static let PASSWORD_KEY = "password"
//    static let TYPE_KEY = "Type"
//    static let DOCUMENT_ID = "user_document"
    
    class func convertArabicToEnglish(value: String) -> String {
        return value.replacingOccurrences(of: "٠", with: "0", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "١", with: "1", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "٢", with: "2", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "٣", with: "3", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "٤", with: "4", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "٥", with: "5", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "٦", with: "6", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "٧", with: "7", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "٨", with: "8", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "٩", with: "9", options: String.CompareOptions.literal, range: nil)
    }
    
    class func convertEnglishToArabic(value: String) -> String {
        return value.replacingOccurrences(of: "0", with: "٠", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "1", with: "١", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "2", with: "٢", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "3", with: "٣", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "4", with: "٤", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "5", with: "٥", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "6", with: "٦", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "7", with: "٧", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "8", with: "٨", options: String.CompareOptions.literal, range: nil)
            .replacingOccurrences(of: "9", with: "٩", options: String.CompareOptions.literal, range: nil)
    }
}

class DateFormats {
    private static var instance: DateFormats? = nil
    
    static func getInstance() -> DateFormats {
        if instance == nil {
            instance = DateFormats()
        }
        return instance!
    }
    
    private init() {
        
    }
    
    //Date Formats
    let dateFormatter = DateFormatter()
    let enSlachStringDateFormat = "dd/MM/yyyy"
    let arSlachStringDateFormat = "yyyy/MM/dd"
    let enDashStringDateFormat = "dd-MM-yyyy"
    let timeFormat = "hh:mm:ss a"
    
    let fullEnDashStringDateFormat = "dd-MM-yyyy hh:mm:ss a"
}



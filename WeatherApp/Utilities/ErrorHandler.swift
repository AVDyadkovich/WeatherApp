//
//  ErrorHandler.swift
//  WeatherApp
//
//  Created by Андрей on 05.09.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import Foundation
import UIKit


class ErrorHandler {
    
    static func createAllert(with message:String, error:String) -> UIAlertController{
        //setup alert
        let alertTitle = "Error!"
        let alertMessage = "\(message). Error: \(error)"
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }
    
    
}

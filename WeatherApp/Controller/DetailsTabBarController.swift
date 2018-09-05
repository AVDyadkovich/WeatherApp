//
//  DetailsTabBarController.swift
//  WeatherApp
//
//  Created by Андрей on 02.09.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import UIKit
import CoreData

class DetailsTabBarController: UITabBarController {
    
    var selectedCity: City!
    var forecastSevenDays:ForecastDataModel!
    var forecastThreeDays:ForecastDataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Start load forecast data from OpenWeather
        loadSevenDaysForecast(cityName: selectedCity.name ?? "Error")
        loadThreeDaysForecast(cityName: selectedCity.name ?? "Error")

    }
    
    func loadSevenDaysForecast(cityName: String){
        //forecast for seven days
        NetworkManager.sharedManager.getForecasWetherData(cityName: cityName, days: .sevedDays, completion: { (forecast) in
            
            self.forecastSevenDays = forecast
            
        }) { (error) in
            let alert = ErrorHandler.createAllert(with: "Error load forecast", error: "\(error)")
            self.present(alert, animated: true, completion: nil)
        }
  
    }
    
    func loadThreeDaysForecast(cityName: String){
        //forecast for three days
        NetworkManager.sharedManager.getForecasWetherData(cityName: cityName, days: .threeDays, completion: { (forecast) in
            
            self.forecastThreeDays = forecast
            
        }) { (error) in
            let alert = ErrorHandler.createAllert(with: "Error load city list", error: "\(error)")
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}

//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Андрей on 31.08.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import Foundation
import Alamofire

enum daysNumber:Int8 {
    case threeDays = 3
    case sevedDays = 7
}

final class NetworkManager {
    
    //Constants
    private let BASE_URL = "https://api.openweathermap.org/data/2.5/"
    private let API_KEY = "f4618d67bc30e2a39cf4406304966382"
    
    static let sharedManager = NetworkManager()
    
    private init () {
        
    }
    
    func getCurrentWetherData (cityName: String, completion: @escaping (_ curentWeather: WeatherDataModel)->(), failed: @escaping (_ error: String) -> ()){
        
        let params = ["q":cityName, "appid":self.API_KEY, "units": "metric"] // params for city name and celsius
        let fullURL = BASE_URL + "weather" // make full URL
        
        Alamofire.request(fullURL, method: .get, parameters: params).responseString { response in
            if response.result.isSuccess {
                // decode respose
                let JSONResponse = response.value?.data(using: .utf8)!
                let decoder = JSONDecoder()
                do {
                    var weather = try decoder.decode(WeatherDataModel.self, from: JSONResponse!)
                    weather.imageName = self.setImageName(condition: (weather.weather.first?.id))
                    completion(weather)
                }catch let error{
                    failed(error.localizedDescription)
                }
            }
        }
    }
    
    func getForecasWetherData (cityName: String, days:daysNumber, completion: @escaping (_ forecast: ForecastDataModel)->(), failed: @escaping (_ error: String) -> ()){
        
        let daysN = String(days.rawValue)
        
        let params = ["q":cityName, "appid":self.API_KEY, "units": "metric","cnt":daysN ] // params for city name, celsius and number of days
        let fullURL = BASE_URL + "forecast/daily" // full URL for forecast
        
        Alamofire.request(fullURL, method: .get, parameters: params).responseString { response in
            if response.result.isSuccess {
                //decode response
                let JSONResponse = response.value?.data(using: .utf8)!
                let decoder = JSONDecoder()
                do {
                    var forecast = try decoder.decode(ForecastDataModel.self, from: JSONResponse!)
                    if days == .threeDays {
                        // take data for 3 days
                        for i in 0..<3 {
                            forecast.list[i].imageName = self.setImageName(condition: forecast.list[i].weather.first?.id)
                        }
                    }else {
                        // take data for 7 days
                        for i in 0..<7 {
                            forecast.list[i].imageName = self.setImageName(condition: forecast.list[i].weather.first?.id)
                        }
                    }
                    completion(forecast)
                }catch let error{
                    failed(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    func setImageName(condition: Int64!) -> String {
        // set image name for weather image
        
        if condition == nil {
            return "NA"
        }
        
        switch (condition) {
            
        case 0...299 :
            return "day_storm"
            
        case 300...499 :
            return "light_rain"
            
        case 500...599 :
            return "showers"
            
        case 600...700 :
            return "light_snow"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "storm"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "clouds"
            
        case 900...903, 905...1000  :
            return "storm"
            
        case 903 :
            return "snow"
            
        case 904 :
            return "sunny"
            
        default :
            return "NA"
        }
        
    }
    
}

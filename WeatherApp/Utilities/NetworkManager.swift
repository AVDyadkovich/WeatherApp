//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Андрей on 31.08.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    //Constants
    private let BASE_URL = "https://api.openweathermap.org/data/2.5/"
    private let API_KEY = "f4618d67bc30e2a39cf4406304966382"
    
    
    static let sharedManager = NetworkManager()
    
    private init () {
        
    }
    
    func getCurrentWetherData (cityName: String, completion: @escaping (_ curentWeather: WeatherDataModel)->(), failed: @escaping (_ error: String) -> ()){
        
        let params = ["q":cityName, "appid":self.API_KEY, "units": "metric"]
        let fullURL = BASE_URL + "weather"
        
        Alamofire.request(fullURL, method: .get, parameters: params).responseString { response in
            if response.result.isSuccess {
                let JSONResponce = response.value?.data(using: .utf8)!
                let decoder = JSONDecoder()
                
                do {
                    let weather = try decoder.decode(WeatherDataModel.self, from: JSONResponce!)
                    
                    completion(weather)
                }catch let error{
                    failed(error.localizedDescription)
                }
            }
        }
    }

}

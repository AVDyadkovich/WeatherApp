//
//  Parser.swift
//  WeatherApp
//
//  Created by Андрей on 04.09.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import Foundation

enum dateStyle{
    case dateAndTime
    case time
    case date
}


class Parser{

    static  func parseWeatherToCityEntity(weatherData:WeatherDataModel, city: City){
        city.name = weatherData.name
        city.temp = Int16(weatherData.main.temp.rounded(.toNearestOrAwayFromZero))
        city.imageName = weatherData.imageName
        city.speed = weatherData.wind.speed
        city.humidity = weatherData.main.humidity
        city.updateTime = weatherData.dt
        city.weatherDescript = weatherData.weather.first?.description
        city.sunriseTime = weatherData.sys.sunrise
        city.sunsetTime = weatherData.sys.sunset
        city.clouds = weatherData.clouds.all
    }
    
    static  func parseForecastToEntity(weatherData:WeatherDataModel, city: City){
        city.name = weatherData.name
        city.temp = Int16(weatherData.main.temp.rounded(.toNearestOrAwayFromZero))
        city.imageName = weatherData.imageName
        city.speed = weatherData.wind.speed
        city.humidity = weatherData.main.humidity
        city.updateTime = weatherData.dt
        city.weatherDescript = weatherData.weather.first?.description
        city.sunriseTime = weatherData.sys.sunrise
        city.sunsetTime = weatherData.sys.sunset
        city.clouds = weatherData.clouds.all
    }
    
    static func convertTime(time:Double, style:dateStyle) ->(String){
        
        //convert date and time to String
        
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        
        switch style {
        case .dateAndTime:
            dateFormatter.dateFormat = "d MMM y 'at' HH:mm"
        case .time:
            dateFormatter.dateFormat = "HH:mm"    
        case .date:
            dateFormatter.dateFormat = "dd/MM"
        }

        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date)
        
        return localDate
    }
    
}

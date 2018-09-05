//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Андрей on 31.08.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import Foundation

struct WeatherDataModel:Codable {
    
    let name:String
    let main:Main
    let weather:[Weather]
    let wind:Wind
    let clouds:Clouds
    let sys:Sys
    let dt:Double
    var imageName:String!
}
struct Wind:Codable {
    let speed:Double
}

struct Main:Codable {
    let humidity:Int16
    let temp:Double
    
}

struct Weather:Codable {
    let description:String
    let id:Int64
    
}

struct Sys:Codable {
    let sunrise: Double
    let sunset: Double
}

struct Clouds:Codable {
    let all:Int16
}

//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Андрей on 31.08.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import Foundation

struct WeatherDataModel:Codable {
    
    let cod:Int
    let name:String
    let main:Main
    let weather:[Weather]
    let wind:Wind
    let clouds:Clouds
    let sys:Sys
    let dt:Int
    
}
struct Wind:Codable {
    let speed:Double
    let deg:Double
}

struct Main:Codable {
    let humidity:Int
    let temp:Double
    
}

struct Weather:Codable {
    let description:String
    let id:Int
    
}

struct Sys:Codable {
    let sunrise: Int
    let sunset: Int
}

struct Clouds:Codable {
    let all:Int
}

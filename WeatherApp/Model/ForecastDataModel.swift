//
//  ForecastDataModel.swift
//  WeatherApp
//
//  Created by Андрей on 03.09.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import Foundation

struct ForecastDataModel:Codable {
    let city:CityName
    var list:[List]
}

struct CityName:Codable{
    let name:String
}

struct List:Codable {
    let dt:Double
    let temp:Tempreture
    let weather:[Weather]
    var imageName:String!
}

struct Tempreture:Codable {
    let day:Double
    let night:Double
}

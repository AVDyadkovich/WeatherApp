//
//  DetailTableViewController.swift
//  WeatherApp
//
//  Created by Андрей on 02.09.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//


import UIKit


class DetailTableViewController: UITableViewController {
    //Outlets
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet var labelCollection: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() // remove empty cells
    }
    
    func setLabels(fromCity city:City){
        weatherDescLabel.text = city.weatherDescript
        humidityLabel.text = String(city.humidity) + "%"
        windLabel.text = String(city.speed) + " m/s"
        cloudsLabel.text = String(city.clouds) + " %"
        sunriseLabel.text = Parser.convertTime(time: city.sunriseTime, style: .time)
        sunsetLabel.text = Parser.convertTime(time: city.sunsetTime, style: .time)
        lastUpdateLabel.text = Parser.convertTime(time: city.updateTime, style: .dateAndTime)
        for label in labelCollection{
            label.sizeToFit()
        }
    }
    
}

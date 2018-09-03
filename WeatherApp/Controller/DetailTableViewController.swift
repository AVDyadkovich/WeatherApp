//
//  DetailTableViewController.swift
//  WeatherApp
//
//  Created by Андрей on 02.09.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//


import UIKit

enum dateStyle{
    case dateAndTime
    case time
}

class DetailTableViewController: UITableViewController {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLabels(fromCity city:City){
        
        weatherDescLabel.text = city.watherDescript
        humidityLabel.text = String(city.humidity)
        windLabel.text = String(city.speed) + " m/s"
        cloudsLabel.text = String(city.clouds) + " %"
        sunriseLabel.text = convertTime(time: city.sunriseTime, style: .time)
        sunsetLabel.text = convertTime(time: city.sunsetTime, style: .time)
        lastUpdateLabel.text = convertTime(time: city.updateTime, style: .dateAndTime)
        for label in labelCollection{
            label.sizeToFit()
        }
    }
    
    //MARK: - Help Methods
    
    func convertTime(time:Double, style:dateStyle) ->(String){
    
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        
        switch style {
        case .dateAndTime:
            dateFormatter.dateFormat = "d MMM y 'at' HH:mm"
        case .time:
            dateFormatter.dateFormat = "HH:mm"
        }
        //dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date)
        
        return localDate
    }
    

}

//
//  ThreeDaysForecastViewController.swift
//  
//
//  Created by Андрей on 04.09.2018.
//

import UIKit

class ThreeDaysForecastViewController: UIViewController {
    //Outlet
    @IBOutlet weak var cityNameLabel: UILabel!
    //Outlets collections
    @IBOutlet var dayTempCollection: [UILabel]!
    @IBOutlet var nightTempCollection: [UILabel]!
    @IBOutlet var weatherImageCollection: [UIImageView]!
    @IBOutlet var dateCollection: [UILabel]!
    
    var forecast: ForecastDataModel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        cityNameLabel.textColor = UIColor.white
        
        //set label porpeties for different collections
        for label in dayTempCollection {
            label.textColor = UIColor.white
            label.sizeToFit()
        }
        
        for label in nightTempCollection{
            label.textColor = UIColor.darkText
            label.sizeToFit()
        }
        
        for label in dateCollection{
            label.textColor = UIColor.white
            label.sizeToFit()
        }
        
        // load forecast data from tab bar controller
        let detailsTBC = self.tabBarController as! DetailsTabBarController
        if let forecastFromTBC = detailsTBC.forecastThreeDays {
            forecast = forecastFromTBC
        }
        // set background
        let bgImage = UIImage(named: "Background")
        self.view.backgroundColor = UIColor(patternImage: bgImage!)
        
        //set labels
        cityNameLabel.text = forecast.city.name
        for index in 0...2 {
            dateCollection[index].text = Parser.convertTime(time: forecast.list[index].dt, style: .date)
            weatherImageCollection[index].image = UIImage(named: forecast.list[index].imageName)
            dayTempCollection[index].text = String(Int(forecast.list[index].temp.day.rounded(.toNearestOrAwayFromZero))) + "°"
            nightTempCollection[index].text = String(Int(forecast.list[index].temp.night.rounded(.toNearestOrAwayFromZero))) + "°"
        }   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}

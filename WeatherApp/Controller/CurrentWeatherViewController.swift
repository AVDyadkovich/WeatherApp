//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Андрей on 01.09.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var cityName: UILabel!
    
    var detailsTBC:DetailsTabBarController!
    var containerController:DetailTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailsTBC = self.tabBarController as! DetailsTabBarController
       
        if let selectedCity = detailsTBC.selectedCity {
            cityName.text = selectedCity.name
            containerController.setLabels(fromCity: selectedCity)
            
            weatherImage.image = UIImage(named: updateWeatherIcon(condition: selectedCity.weatherID))
            temperatureLabel.text = String(selectedCity.temp) + "°"
            temperatureLabel.sizeToFit()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send data to DetaisTableViewController
        let detailsTVC = segue.destination as! DetailTableViewController
        containerController = detailsTVC
    }
    
    func updateWeatherIcon(condition: Int64) -> String {
        // set image name for weather image
        
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

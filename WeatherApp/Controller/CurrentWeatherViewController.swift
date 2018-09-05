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
            
            weatherImage.image = UIImage(named:selectedCity.imageName ?? "NA")
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
}

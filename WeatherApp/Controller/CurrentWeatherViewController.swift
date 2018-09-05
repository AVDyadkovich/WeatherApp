//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Андрей on 01.09.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//


import UIKit

class CurrentWeatherViewController: UIViewController {
    // Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var detailsTBC:DetailsTabBarController!
    var containerController:DetailTableViewController! //container with table view
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // take detail data from tab bar controller
        detailsTBC = self.tabBarController as! DetailsTabBarController
        if let selectedCity = detailsTBC.selectedCity {
            cityNameLabel.text = selectedCity.name
            cityNameLabel.textColor = UIColor.white
            containerController.setLabels(fromCity: selectedCity)
            weatherImage.image = UIImage(named:selectedCity.imageName ?? "NA")
            temperatureLabel.text = String(selectedCity.temp) + "°"
            temperatureLabel.textColor = UIColor.white
            temperatureLabel.sizeToFit()
        }
        // set background
        let bgImage = UIImage(named: "Background")
        self.view.backgroundColor = UIColor(patternImage: bgImage!)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send data to container
        let detailsTVC = segue.destination as! DetailTableViewController
        containerController = detailsTVC
    }
}

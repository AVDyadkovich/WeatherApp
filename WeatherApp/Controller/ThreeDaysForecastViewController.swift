//
//  ThreeDaysForecastViewController.swift
//  
//
//  Created by Андрей on 04.09.2018.
//

import UIKit

class ThreeDaysForecastViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var dateFirstLabel: UILabel!
    @IBOutlet weak var dateSecondLabel: UILabel!
    @IBOutlet weak var dateThirdLabel: UILabel!
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    
    @IBOutlet weak var dayTempFirstLabel: UILabel!
    @IBOutlet weak var dayTempSecondLabel: UILabel!
    @IBOutlet weak var dayTempThirdLabel: UILabel!
    
    @IBOutlet weak var nightTempFirstLabel: UILabel!
    @IBOutlet weak var nightTempSecondLabel: UILabel!
    @IBOutlet weak var nightTempThirdLabel: UILabel!
    
    @IBOutlet var dayTempCollection: [UILabel]!
    @IBOutlet var nightTempCollection: [UILabel]!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        for label in dayTempCollection {
            label.textColor = UIColor.white
            label.sizeToFit()
        }
        
        for label in nightTempCollection{
            label.textColor = UIColor.gray
            label.sizeToFit()
        }
        
        let detailsTBC = self.tabBarController as! DetailsTabBarController
        
        if let selectedCityName = detailsTBC.selectedCity.name {
            loadThreeDaysForecast(cityName:selectedCityName)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadThreeDaysForecast(cityName: String){
        
        NetworkManager.sharedManager.getForecasWetherData(cityName: cityName, days: .threeDays, completion: { (forecast) in
            let listOne = forecast.list[0]
            let listTwo = forecast.list[1]
            let listThree = forecast.list[2]
            
            self.cityNameLabel.text = cityName
            //set dates
            self.dateFirstLabel.text = Parser.convertTime(time: listOne.dt, style: .date)
            self.dateSecondLabel.text = Parser.convertTime(time: listTwo.dt, style: .date)
            self.dateThirdLabel.text = Parser.convertTime(time: listThree.dt, style: .date)
            //set images
            self.firstImageView.image = UIImage(named: listOne.imageName)
            self.secondImageView.image = UIImage(named: listTwo.imageName)
            self.thirdImageView.image = UIImage(named: listThree.imageName)
            //set day tempreture
            self.dayTempFirstLabel.text = String(listOne.temp.day) + "°"
            self.dayTempSecondLabel.text = String(listTwo.temp.day) + "°"
            self.dayTempThirdLabel.text = String(listThree.temp.day) + "°"
            //set night tempreture
            self.nightTempFirstLabel.text = String(listOne.temp.night) + "°"
            self.nightTempSecondLabel.text = String(listTwo.temp.night) + "°"
            self.nightTempThirdLabel.text = String(listThree.temp.night) + "°"
            
            
        }) { (error) in
            print("Error update data: \(error)")
        }
        
        
        
    }
        

}

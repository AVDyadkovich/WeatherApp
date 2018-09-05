//
//  SevenDaysForecasTableViewController.swift
//  WeatherApp
//
//  Created by Андрей on 05.09.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import UIKit

class SevenDaysForecasTableViewController: UITableViewController {
    
    var forecast: ForecastDataModel!
    let titleHeight: CGFloat = 70
    
    override func viewWillAppear(_ animated: Bool) {
        // take data from tab bar controller
        let detailsTBC = self.tabBarController as! DetailsTabBarController
        if let forecastFromTBC = detailsTBC.forecastSevenDays {
            forecast = forecastFromTBC
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // set background
        let bgImage = UIImage(named: "Background")
        let bgView = UIImageView(image:bgImage)
        bgView.contentMode = .scaleAspectFill
        tableView.backgroundView = bgView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return titleHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // set city name for section header
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: titleHeight)
        let headerView = UIView(frame: frame)
        let title = UILabel(frame: frame)
        title.text = forecast.city.name
        title.textColor = UIColor.white
        title.font = title.font.withSize(36)
        title.textAlignment = .center
        headerView.addSubview(title)
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = createCellForecast(forecast: forecast, indexPath: indexPath) // create cells
        return cell
    }

    //MARK: - Help Methods

    func createCellForecast(forecast:ForecastDataModel, indexPath:IndexPath) -> ForecastTableViewCell{
        
        let index = indexPath.row
        let list = forecast.list[index]
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell
        let bgImage = UIImage(named: "cellBackground")

        //setup cell
        cell.dateLabel?.textColor = UIColor.white
        cell.dayTemperatureLabel?.textColor = UIColor.white
        cell.nightTemperatureLabel?.textColor = UIColor.darkText
        cell.backgroundColor = UIColor.clear
        cell.backgroundView = UIImageView(image: bgImage)
        cell.backgroundView?.contentMode = .scaleAspectFill
        cell.dateLabel.text = Parser.convertTime(time: list.dt, style: .date)
        cell.weatherImage.image = UIImage(named: list.imageName)
        cell.dayTemperatureLabel.text = String(Int(list.temp.day.rounded(.toNearestOrAwayFromZero))) + "°" //convert temperture to int value
        cell.nightTemperatureLabel.text = String(Int(list.temp.night.rounded(.toNearestOrAwayFromZero))) + "°" //convert temperature to int value
        cell.dateLabel.sizeToFit()
        cell.nightTemperatureLabel.sizeToFit()
        cell.dayTemperatureLabel.sizeToFit()
        
        return cell
    }

}

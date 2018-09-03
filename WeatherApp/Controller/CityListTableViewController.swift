//
//  CityListTableViewController.swift
//  WeatherApp
//
//  Created by Андрей on 31.08.2018.
//  Copyright © 2018 Andrey Dyadkovich. All rights reserved.
//

import UIKit
import CoreData

class CityListTableViewController: UITableViewController {
    
    var citiesArray = [City]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
       //pull and refresh
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl?.addTarget(self, action: #selector(CityListTableViewController.refresh), for: UIControlEvents.valueChanged)
       
        self.tableView.backgroundColor = UIColor.blue
        loadAllCities() //load actual data for all cities in list
        
        //add default 2 cities
        switch citiesArray.count {
        case 0:
            createCityData(name: "Vinnytsya")
        case 1:
            createCityData(name: "Kiev")      
        default:
            break
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return citiesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        var cell : UITableViewCell
        let index = indexPath.row
        
        cell = createCityCell(cityName: citiesArray[index].name ?? "Error. No name.", temp: citiesArray[index].temp)
        return cell
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.row > 1 {
            return true
        }else {
            return false
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            removeCity(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarVC = segue.destination as! DetailsTabBarController
        
        let tableCell = sender as! UITableViewCell
        tabBarVC.selectedCity = loadCity(name: (tableCell.textLabel?.text) ?? "Error. No City.")
        
    }

    //MARK: - Actions
    @IBAction func addNewCity(_ sender: Any) {
        let cityInputActionSheet = UIAlertController(title: "City name", message: "Enter city name", preferredStyle: .alert)
        cityInputActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        cityInputActionSheet.addTextField { textField in
            textField.keyboardType = .asciiCapable
        }
        cityInputActionSheet.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            if let cityName = cityInputActionSheet.textFields?.first?.text {
                
                self.createCityData(name: cityName)
                
            }
        }))
        self.present(cityInputActionSheet, animated: true)
    }
    
    //MARK: - CRUD methods
    
    func saveCity(){
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
    }
    
    func loadAllCities(){
        let request: NSFetchRequest<City> = City.fetchRequest()
        
        do {
            citiesArray = try context.fetch(request)
        } catch {
            print("Error load data: \(error)")
        }
            updateWeather()
    }
    
    func loadCity(name:String) -> City? {
        let request: NSFetchRequest<City> = City.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "name = %@", name)
        var city:City
        do {
            city = (try context.fetch(request).first)!
            return city
        } catch {
            print("Error load data: \(error)")
            return nil
        }
    }
    
    //MARK: - Help Methods
    
    func createCityCell(cityName:String, temp: Double) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCellID") ?? UITableViewCell(style: .value1, reuseIdentifier: "CityCellID")
        
        //color setup for cell
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.blue
        
        //text setup for cell
        cell.textLabel?.text = cityName
        cell.detailTextLabel?.text = String(temp) + "°"
        
        return cell
    }
    
    func updateWeather(){
        for city in citiesArray {
            NetworkManager.sharedManager.getCurrentWetherData(cityName: city.name ?? "Error! No city", completion: { (weatherData) in
                self.parseWeatherToCityEntity(weatherData: weatherData, city: city)
                self.tableView.reloadData()
            }) { (error) in
                print("Error update data: \(error)")
            }
        }
    }
    
    func removeCity(at index:Int){
        context.delete(citiesArray[index])
        citiesArray.remove(at: index)
        self.saveCity()
    }
    
    @objc func refresh(){
        updateWeather()
        let when = DispatchTime.now() + 1 // desired seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.refreshControl?.endRefreshing()
        }
        
    }
    
    func createCityData(name:String) {
        NetworkManager.sharedManager.getCurrentWetherData(cityName: name, completion: { (weatherData) in
            let newCity = City(context: self.context)
            self.parseWeatherToCityEntity(weatherData: weatherData, city: newCity)
            self.citiesArray.append(newCity)
            self.tableView.reloadData()
            self.saveCity()
        }) { (error) in
            print("Error adding city: \(error)")
        }
        
    }
    
    func parseWeatherToCityEntity(weatherData:WeatherDataModel, city: City){
        city.name = weatherData.name
        city.temp = weatherData.main.temp
        if let weatherID = weatherData.weather.first?.id {
            city.weatherID = weatherID
        }
        city.speed = weatherData.wind.speed
        city.humidity = weatherData.main.humidity
        city.updateTime = weatherData.dt
        city.watherDescript = weatherData.weather.first?.description
        city.sunriseTime = weatherData.sys.sunrise
        city.sunsetTime = weatherData.sys.sunset
        city.clouds = weatherData.clouds.all
    }
}

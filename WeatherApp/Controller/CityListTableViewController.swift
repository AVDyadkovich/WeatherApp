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
        refreshControl?.tintColor = UIColor.white.withAlphaComponent(0.8)
        refreshControl?.addTarget(self, action: #selector(CityListTableViewController.refresh), for: UIControlEvents.valueChanged)
        //set background
        let bgImage = UIImage(named: "Background")
        let bgView = UIImageView(image:bgImage)
        bgView.contentMode = .scaleAspectFill
        tableView.backgroundView = bgView
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView() //remove empty cells
        
        loadAllCities() //load actual data for all cities in list
        
        //add default 2 cities
        switch citiesArray.count {
        case 0:
            createCityData(name: "Vinnytsya")
            createCityData(name: "Kiev")
        case 1:
            createCityData(name: "Kiev")      
        default:
            break
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        var cell : UITableViewCell
        let index = indexPath.row
        cell = createCityCell(city: citiesArray[index]) // create cells
        return cell
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.row > 1 { //not allow to remove 2 default cities
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
        //send data to details tab bar
        let tabBarVC = segue.destination as! DetailsTabBarController
        let tableCell = sender as! UITableViewCell
        tabBarVC.selectedCity = loadCity(name: (tableCell.textLabel?.text) ?? "Error. No City.")
        
    }

    //MARK: - Actions
    @IBAction func addNewCity(_ sender: Any) {
        //add own city
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
            let alert = ErrorHandler.createAllert(with: "Error saving city", error: "\(error)")
            present(alert, animated: true, completion: nil)
        }
    }
    
    func loadAllCities(){
        let request: NSFetchRequest<City> = City.fetchRequest()
        do {
            citiesArray = try context.fetch(request)
        } catch {
            let alert = ErrorHandler.createAllert(with: "Error load city list", error: "\(error)")
            present(alert, animated: true, completion: nil)
        }
            updateWeather() // update weather data
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
            let alert = ErrorHandler.createAllert(with: "Error load city", error: "\(error)")
            present(alert, animated: true, completion: nil)
            return nil
        }
    }
    
    //MARK: - Help Methods
    
    func createCityCell(city: City) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCellID") ?? UITableViewCell(style: .value1, reuseIdentifier: "CityCellID")
        let bgImage = UIImage(named: "cellBackground")
        
        //design setup for cell
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        cell.backgroundView = UIImageView(image: bgImage)
        cell.backgroundView?.contentMode = .scaleAspectFill
        
        //text setup for cell
        cell.textLabel?.text = city.name ?? "Error"
        cell.detailTextLabel?.text = String(city.temp) + "°" 

        return cell
    }
    
    func updateWeather(){
        for city in citiesArray {
            // update weather from OpenWeather
            NetworkManager.sharedManager.getCurrentWetherData(cityName: city.name!, completion: { (weatherData) in
                Parser.parseWeatherToCityEntity(weatherData: weatherData, city: city)
                self.tableView.reloadData()
            }) { (error) in
                let alert = ErrorHandler.createAllert(with: "Error update data", error: "\(error)")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func removeCity(at index:Int){
        context.delete(citiesArray[index])
        citiesArray.remove(at: index)
        self.saveCity()
    }
    
    @objc func refresh(){
        updateWeather() // update data
        let when = DispatchTime.now() + 1 // desired seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.refreshControl?.endRefreshing()
        }
        
    }
    
    func createCityData(name:String) {
        NetworkManager.sharedManager.getCurrentWetherData(cityName: name, completion: { (weatherData) in
            let newCity = City(context: self.context)
            Parser.parseWeatherToCityEntity(weatherData: weatherData, city: newCity)
            self.citiesArray.append(newCity)
            self.tableView.reloadData()
            self.saveCity()
        }) { (error) in
            let alert = ErrorHandler.createAllert(with: "Wrong city", error: "\(error)")
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

//
//  ForecastViewController.swift
//  OpenWeather
//
//  Created by Dario Banno on 29/05/2017.
//  Copyright © 2017 AppTown. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel! {
        didSet {
            cityLabel.text = ""
        }
    }
    @IBOutlet weak var conditionsLabel: UILabel! {
        didSet {
            conditionsLabel.text = ""
        }
    }
    @IBOutlet weak var temperatureLabel: UILabel! {
        didSet {
            temperatureLabel.text = ""
        }
    }

    @IBOutlet weak var iconLabel: UILabel! {
        didSet {
            iconLabel.text = ""
            iconLabel.font = UIFont(name: "WeatherIcons-Regular", size: 40)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCurrentWeather()
    }
    
    
    // MARK: Network calls
    
    func loadCurrentWeather() {

        NetworkManager.shared.weatherService.fetch(name: "London, GB") { [weak self] (station: Station?, error: HTTPClientError?) in
            guard let station = station,
                let weather = station.weather,
                error == nil
            else {
                Logger.print("Error retrieving current weather.")
                // TODO: Manage error - Alert with Retry button
                return
            }
            
            let weatherViewModel = WeatherViewModel(weather: weather)
            
            self?.cityLabel.text = station.name
            self?.conditionsLabel.text = weather.condition
            self?.temperatureLabel.text = weatherViewModel.temperature
            
            // TODO: update icon for night time (compare with sunrise/sunset time)
            self?.iconLabel.text = WeatherIconsFontMapper.iconString(id: "\(weather.code)", nightTime: false)
            
        }

    }

}

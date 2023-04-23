//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ebuzer Şimşek on 20.04.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    let locationManager = CLLocationManager()
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    
    @IBOutlet weak var maxTempImage: UIImageView!
    @IBOutlet weak var minTempImage: UIImageView!
    @IBOutlet weak var windSpeedImage: UIImageView!
    @IBOutlet weak var humidityImage: UIImageView!
    let apiKey = "5c521e2e95f69fee088879b23745b9ce"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

        
        
//        Icons
        maxTempImage.image = UIImage(systemName: "thermometer.sun.circle.fill")
        minTempImage.image = UIImage(systemName: "thermometer.sun.circle.fill")
        windSpeedImage.image = UIImage(systemName: "wind.circle.fill")
        humidityImage.image = UIImage(systemName: "humidity.fill")
        
        
        
       
        self.view.backgroundColor = UIColor(red: 18/255, green: 23/255, blue: 89/255, alpha: 1)
        
        
        DispatchQueue.main.async {
            let currentTime = Date().timeIntervalSince1970
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM HH:mm"
            let dateString = formatter.string(from: Date(timeIntervalSince1970: currentTime))
            self.TimeLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            self.TimeLabel.textColor = UIColor.white
            self.TimeLabel.text = dateString
        }

          
        
        
        
        //JSON - API CODES
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        if let url = URL(string: urlString) {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                do {
//                    Extracting Values
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        if let main = json["main"] as? [String: Any],
                           let temp = main["temp"] as? Double {
                            DispatchQueue.main.async {
                            self.temperatureLabel.font = UIFont.boldSystemFont(ofSize: 83)
                            self.temperatureLabel.text = "\(Int(temp.rounded()))°"
                            }
                           }
                        
                        if let main = json["main"] as? [String: Any],
                           let tempMax = main["temp_max"] as? Double {
                            DispatchQueue.main.async {
                            self.maxTemp.font = UIFont.boldSystemFont(ofSize: 21)
                            self.maxTemp.text = "\(Int(tempMax.rounded()))°"
                            }
                           }
                        
                        if let main = json["main"] as? [String: Any],
                           let tempMin = main["temp_min"] as? Double {
                            DispatchQueue.main.async {
                            self.minTemp.font = UIFont.boldSystemFont(ofSize: 21)
                            self.minTemp.text = "\(Int(tempMin.rounded()))°"
                            }
                           }
                       
                        if let main = json["main"] as? [String: Any],
                           let temp = main["humidity"] as? Double {
                            DispatchQueue.main.async {
                            self.humidity.font = UIFont.boldSystemFont(ofSize: 21)
                            self.humidity.text = "\(Int(temp.rounded())) g/m3"
                            }
                           }
                        
                        if let main = json["wind"] as? [String: Any],
                           let temp = main["speed"] as? Double {
                            DispatchQueue.main.async {
                            self.windSpeed.font = UIFont.boldSystemFont(ofSize: 21)
                            self.windSpeed.text = "\(Int(temp.rounded())) m/s"
                            }
                           }
                        
                        
                           
                        if let name = json["name"] as? String {
                            DispatchQueue.main.async {
                                self.locationLabel.text = name
                                self.locationLabel.font = UIFont.boldSystemFont(ofSize: 26.0)
                            }
                        
                        }
                        
                        
                        
                        
                        if let weather = json["weather"] as? [[String:Any]] {
                            DispatchQueue.main.async {
                                if let mainWeather = weather.first?["main"] as? String {
                                    self.conditionLabel.text = mainWeather
                                    if mainWeather == "Clouds"{
                                        self.imageView.image = UIImage(systemName:"sun.min")!.withTintColor(UIColor.white)
                                    }
                                    else if mainWeather == "Rain"{
                                        self.imageView.image = UIImage(systemName:"sun.min")!.withTintColor(UIColor.white)
                                    }
                                    else if mainWeather == "Clear"{
                                        self.imageView.image = UIImage(systemName: "sun.min")?.withTintColor(UIColor.white)
                                    }
                                    else if mainWeather == "Mist"{
                                        self.imageView.image = UIImage(systemName: "cloud.fog")?.withTintColor(UIColor.white)
                                    }
                                }
                            }
                        }
                        
                    }
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            task.resume()
        } else {
            print("Invalid URL")
        }
        
    }
      
    }

        

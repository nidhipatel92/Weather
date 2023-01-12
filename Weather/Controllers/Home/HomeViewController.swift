//
//  ViewController.swift
//  Weather
//
//  Created by Nidhi patel on 09/01/23.
//

import UIKit

class HomeViewController : UIViewController {
    
    let lblCityName = UILabel()
    let weatherImageView = UIImageView()
    let lblTemperature = UILabel()
    let lblDate = UILabel()
    let tblViewForeCast = UITableView()
    let lblError = UILabel()
    let foreCastTitle = UILabel()
    var clViewForeCast = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var strDateTime = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setupWeatherData()
    }

    //setup weather data if current time different then call API
    func setupWeatherData() {
        if let getWeatherData = userDefaults.value(forKey: APIKeys.weatherData) as? [String : Any]{
            if let dict = getWeatherData[DictKeys.location] as? [String : Any] , let time = dict[DictKeys.localTime] as? String {
                weatherDict = getWeatherData
                DispatchQueue.main.async {
                    self.setupView()
                }
                if time != self.getCurrentDateTime(){
                    self.weatherAPI()
                }
            }else{
                //when error get after this method call for refresh data
                self.weatherAPI()
            }
        }else{
            self.weatherAPI()
        }
    }
    
    func weatherAPI(){
        APIRouter.shared.getWeatherDataFromCity(key:key, cityName:cityName) {
            if let dict = weatherDict[DictKeys.error] as? [String : Any], let message = dict[DictKeys.message] as? String{
                DispatchQueue.main.async {
                    self.setupErrorMessage(message: message)
                }
            }else{
                DispatchQueue.main.async {
                    self.setupView()
                }
            }
        }
    }
    
    func setupView(){
        self.setupCityName()
        self.setupWeatherIcon()
        self.setupTemperature()
        self.setupDate()
        self.setupForeCastCurrentList()
        self.setupForeCastTitle()
        self.setupForeCastList()
    }
    
    //MARK: - Setup name of city Name
    func setupCityName() {
        self.view.addSubview(lblCityName)
        let safeAreaGuide = self.view.safeAreaLayoutGuide
        lblCityName.translatesAutoresizingMaskIntoConstraints = false
        lblCityName.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        lblCityName.topAnchor.constraint(equalTo:safeAreaGuide.topAnchor, constant: 20).isActive = true
        lblCityName.font = UIFont.systemFont(ofSize:20)
        if let dict = weatherDict[DictKeys.location] as? [String : Any] , let country = dict[DictKeys.country] as? String {
            lblCityName.text = "\(cityName) , \(country)"
        }
    }
    
    //MARK: - Setup error message
    func setupErrorMessage(message: String) {
        self.view.addSubview(lblError)
        lblError.translatesAutoresizingMaskIntoConstraints = false
        lblError.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        lblError.centerYAnchor.constraint(equalTo:self.view.centerYAnchor).isActive = true
        lblError.textAlignment = .center
        lblError.font = UIFont.systemFont(ofSize:20)
    
        lblError.text = "\(message)"        
    }
    
    //MARK: - Setup icon of weather
    func setupWeatherIcon() {
        
        self.view.addSubview(weatherImageView)
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        weatherImageView.topAnchor.constraint(equalTo:self.lblCityName.topAnchor, constant:20).isActive = true
        weatherImageView.widthAnchor.constraint(equalToConstant:40).isActive = true
        weatherImageView.heightAnchor.constraint(equalToConstant:40).isActive = true
        if let dict = weatherDict[DictKeys.current] as? [String : Any] , let conditionDict = dict[DictKeys.condition] as? [String : Any] {
            if let url = conditionDict[DictKeys.icon] as? String {
              self.getImageFromUrl(url:"https:\(url)")
            }
        }
        
    }
    
    func getImageFromUrl(url : String) {
        URLSession.shared.dataTask(with:URL(string:url)!, completionHandler:{ data , response ,error in
            if let imgdata = data {
                DispatchQueue.main.async {
                    self.weatherImageView.image = UIImage(data:imgdata)!
                }
            }
        }).resume()
    }
    
    //MARK: - Setup Today's temperature 
    func setupTemperature() {
        self.view.addSubview(lblTemperature)
        lblTemperature.translatesAutoresizingMaskIntoConstraints = false
        lblTemperature.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        lblTemperature.topAnchor.constraint(equalTo:self.weatherImageView.topAnchor , constant:40).isActive = true
        lblTemperature.font = UIFont.systemFont(ofSize:40)
        if let dict = weatherDict[DictKeys.current] as? [String : Any] , let temp = dict[DictKeys.temp_c] as? Double {
            lblTemperature.text = "\(temp)°"
        }
    }
    
    //MARK: - Setup Time and Date
    func setupDate() {
        self.view.addSubview(lblDate)
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        lblDate.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        lblDate.topAnchor.constraint(equalTo:self.lblTemperature.topAnchor , constant:50).isActive = true
        lblDate.font = UIFont.systemFont(ofSize:20)
        if let dict = weatherDict[DictKeys.location] as? [String : Any] , let time = dict[DictKeys.localTime] as? String {
            let arrDateTime = "\(time )".components(separatedBy: " ")
              
            lblDate.text = "\(arrDateTime[0]) \(self.getTime12HourFormate(strTime:"\(arrDateTime[1])"))"
            self.strDateTime = time
//            self.strDateTime = "\(self.getTime12HourFormate(strTime:"\(arrDateTime[1])"))"
        }
    }
    
    //MARK: - Setup Title Forecast
    func setupForeCastTitle() {
        self.view.addSubview(foreCastTitle)
        foreCastTitle.translatesAutoresizingMaskIntoConstraints = false
        foreCastTitle.leadingAnchor.constraint(equalTo:self.view.leadingAnchor , constant:20).isActive = true
        foreCastTitle.topAnchor.constraint(equalTo:self.clViewForeCast.bottomAnchor , constant:20).isActive = true
        foreCastTitle.font = UIFont.boldSystemFont(ofSize:20)
        foreCastTitle.text = Titles.forecast
    }

}

//MARK: - Get Current Date & Time
extension HomeViewController{
    func getCurrentDateTime() -> String{
        let mytime = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let strDateTime = format.string(from: mytime)
        return strDateTime
    }
    
    func getCurrentDate() -> String{
        let mytime = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let strDate = format.string(from: mytime)
        return strDate
    }
    
    func getTime12HourFormate(strTime: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let date = dateFormatter.date(from: strTime)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
}

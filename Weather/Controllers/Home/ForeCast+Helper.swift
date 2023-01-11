//
//  ForeCast+Helper.swift
//  Weather
//
//  Created by Nidhi patel on 10/01/23.
//

import Foundation
import UIKit

//MARK: - Setup for ForeCast Cell
class ForeCastCell : UITableViewCell {
    
    let weatherImageView = UIImageView()
    let lblMaxTemp = UILabel()
    let lblMinTemp = UILabel()
    let lblDate = UILabel()
    var index : Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        self.setupWeatherIcon()
        self.setupTemperature()
        self.setupForecastDate()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    //MARK: - Setup Weather Icon
    func setupWeatherIcon() {
        contentView.addSubview(weatherImageView)
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.leadingAnchor.constraint(equalTo:self.leadingAnchor , constant:20).isActive = true
        weatherImageView.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        weatherImageView.widthAnchor.constraint(equalToConstant:40).isActive = true
        weatherImageView.heightAnchor.constraint(equalToConstant:40).isActive = true
    }
    
    //MARK: - Setup Min and Max Temperatures
    func setupTemperature() {
        contentView.addSubview(self.lblMaxTemp)
        self.lblMaxTemp.translatesAutoresizingMaskIntoConstraints = false
        self.lblMaxTemp.topAnchor.constraint(equalTo:self.topAnchor , constant:15).isActive = true
        self.lblMaxTemp.leadingAnchor.constraint(equalTo:self.weatherImageView.trailingAnchor , constant:30).isActive = true
        self.lblMaxTemp.font = UIFont.systemFont(ofSize:20)

        contentView.addSubview(self.lblMinTemp)
        self.lblMinTemp.translatesAutoresizingMaskIntoConstraints = false
        self.lblMinTemp.topAnchor.constraint(equalTo:self.lblMaxTemp.bottomAnchor , constant:8).isActive = true
        self.lblMinTemp.leadingAnchor.constraint(equalTo:self.lblMaxTemp.leadingAnchor).isActive = true
        self.lblMinTemp.font = UIFont.systemFont(ofSize:20)
    }
    
    //MARK: - Setup Forecast Date
    func setupForecastDate() {
        contentView.addSubview(self.lblDate)
        self.lblDate.translatesAutoresizingMaskIntoConstraints = false
        self.lblDate.centerYAnchor.constraint(equalTo:self.weatherImageView.centerYAnchor).isActive = true
        self.lblDate.leadingAnchor.constraint(equalTo:self.lblMaxTemp.trailingAnchor , constant:30).isActive = true
        self.lblDate.font = UIFont.systemFont(ofSize:20)
    }
    
}

//MARK: - Extension of Home screen to show forecast list
extension HomeViewController {
    
    func setupForeCastList() {
        self.view.addSubview(self.tblViewForeCast)
        tblViewForeCast.translatesAutoresizingMaskIntoConstraints = false
        tblViewForeCast.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant:20).isActive = true
        tblViewForeCast.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant:-20).isActive = true
        tblViewForeCast.topAnchor.constraint(equalTo:self.foreCastTitle.bottomAnchor).isActive = true
        tblViewForeCast.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
        self.tblViewForeCast.register(ForeCastCell.self, forCellReuseIdentifier:Identifiers.ForeCastCell)
        tblViewForeCast.delegate = self
        tblViewForeCast.dataSource = self
    }
    
}

//MARK: - Extension For tableview delegate and datasource methods
extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let foreCast = weatherDict[DictKeys.forecast] as? [String : Any] {
            if let foreCastDay = foreCast[DictKeys.foreCastDay] as? [[String : Any]] {
                return foreCastDay.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:Identifiers.ForeCastCell , for:indexPath) as! ForeCastCell
        cell.index = indexPath.row
        cell.selectionStyle = .none
        //display data for forecast
        if let foreCast = weatherDict[DictKeys.forecast] as? [String : Any] {
            if let foreCastDay = foreCast[DictKeys.foreCastDay] as? [[String : Any]] {
                let objForecast = foreCastDay[indexPath.row]
                let strDate = "\(objForecast[DictKeys.date] ?? "")"
                cell.lblDate.text = strDate == getCurrentDate() ? "Today" : strDate
                
                if let day = objForecast[DictKeys.day] as? [String : Any] , let maxTemp = day[DictKeys.maxtemp_c] as? Double , let minTemp = day[DictKeys.mintemp_c] as? Double, let condition = day[DictKeys.condition] as? [String : Any]{
                    cell.lblMaxTemp.text = "Max : \(maxTemp)°"
                    cell.lblMinTemp.text = "Min : \(minTemp)°"
                    
                    if let url = condition[DictKeys.icon] as? String {
                        URLSession.shared.dataTask(with:URL(string:"https:\(url)")!, completionHandler:{ data , response ,error in
                            if let imgdata = data {
                                DispatchQueue.main.async {
                                    cell.weatherImageView.image = UIImage(data:imgdata)!
                                }
                            }
                        }).resume()
                    }
                }
            }
        }
        return cell
    }
}

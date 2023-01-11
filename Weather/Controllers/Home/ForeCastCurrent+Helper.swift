//
//  ForeCastCurrent+Helper.swift
//  Weather
//
//  Created by Nidhi patel on 10/01/23.
//

import UIKit

class ForeCastCurrentCell: UICollectionViewCell {
    let weatherImageView = UIImageView()
    let lblAvgTemp = UILabel()
    let lblTime = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupForecastTime()
        self.setupWeatherIcon()
        self.setupTemperature()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    //MARK: - Setup Forecast Time
    func setupForecastTime() {
        contentView.addSubview(self.lblTime)
        self.lblTime.translatesAutoresizingMaskIntoConstraints = false
        self.lblTime.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
        self.lblTime.topAnchor.constraint(equalTo:self.topAnchor, constant: 0).isActive = true
        self.lblTime.font = UIFont.systemFont(ofSize:20)
        self.lblTime.textAlignment = .center
    }
    
    //MARK: - Setup Weather Icon
    func setupWeatherIcon() {
        contentView.addSubview(weatherImageView)
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        self.weatherImageView.topAnchor.constraint(equalTo:self.lblTime.topAnchor , constant:30).isActive = true
        self.weatherImageView.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
        self.weatherImageView.contentMode = .scaleAspectFit
        self.weatherImageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.weatherImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    //MARK: - Setup Avg Temperatures
    func setupTemperature() {
        contentView.addSubview(self.lblAvgTemp)
        self.lblAvgTemp.translatesAutoresizingMaskIntoConstraints = false
        self.lblAvgTemp.topAnchor.constraint(equalTo:self.weatherImageView.bottomAnchor , constant:10).isActive = true
        self.lblAvgTemp.bottomAnchor.constraint(equalTo:self.bottomAnchor , constant:0).isActive = true
        self.lblAvgTemp.centerXAnchor.constraint(equalTo:self.weatherImageView.centerXAnchor).isActive = true
        self.lblAvgTemp.font = UIFont.systemFont(ofSize:20)
        self.lblAvgTemp.textAlignment = .center
    }
    
}

//MARK: - Extension of Home screen to show forecast list
extension HomeViewController{
    
    func setupForeCastCurrentList() {
        self.view.addSubview(self.clViewForeCast)
//        self.clViewForeCast = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
//        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
//        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        if let layout: UICollectionViewFlowLayout = self.clViewForeCast.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = CGSize(width: 100, height: 100)
        }
        clViewForeCast.translatesAutoresizingMaskIntoConstraints = false
        clViewForeCast.topAnchor.constraint(equalTo:self.lblDate.bottomAnchor, constant: 20).isActive = true
        clViewForeCast.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant:20).isActive = true
        clViewForeCast.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant:0).isActive = true
        clViewForeCast.heightAnchor.constraint(equalToConstant: 125).isActive = true
        self.clViewForeCast.register(ForeCastCurrentCell.self, forCellWithReuseIdentifier:Identifiers.ForeCastCurrentCell)
        clViewForeCast.delegate = self
        clViewForeCast.dataSource = self
        
        //filter current time according
        if let foreCast = weatherDict[DictKeys.forecast] as? [String : Any] {
            if let foreCastDay = foreCast[DictKeys.foreCastDay] as? [[String : Any]] {
                let currentForeCast = foreCastDay[0]
                if let foreCastHours = currentForeCast[DictKeys.hour] as? [[String : Any]] {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:MM"
                    let date = Calendar.current.date(
                        byAdding: .hour,
                        value: -1,
                        to: Date())!
                    let str = dateFormatter.string(from:date)
                    let previousHour = foreCastHours.filter{
                        let strTime = ($0[DictKeys.time] as? String)!
                       
                        return (strTime > str)
                    }
                    hoursDict = previousHour
                }
            }
        }
    }
    
}

//MARK: - Extension For collectionview delegate and datasource methods
extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return hoursDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.ForeCastCurrentCell, for: indexPath) as! ForeCastCurrentCell
                
        let arrDateTime = "\(hoursDict[indexPath.row][DictKeys.time] ?? "")".components(separatedBy: " ")
                
        cell.lblTime.text = self.getTime12HourFormate(strTime:"\(arrDateTime[1])")
        
        let condition = hoursDict[indexPath.row][DictKeys.condition] as? [String : Any]
        
        if let url = condition![DictKeys.icon] as? String {
            URLSession.shared.dataTask(with:URL(string:"https:\(url)")!, completionHandler:{ data , response ,error in
                if let imgdata = data {
                    DispatchQueue.main.async {
                        cell.weatherImageView.image = UIImage(data:imgdata)!
                    }
                }
            }).resume()
        }
        
        cell.lblAvgTemp.text = "\(hoursDict[indexPath.row][DictKeys.temp_c] ?? "")°"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
//        let width = (screenSize.width-leftAndRightPaddings)/numberOfItemsPerRow
        return CGSize(width: 100, height: 100)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
//    {
//        return UIEdgeInsets(top: 20, left: 8, bottom: 5, right: 8)
//    }
}

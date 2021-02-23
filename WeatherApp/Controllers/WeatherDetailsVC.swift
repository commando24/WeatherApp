//
//  WeatherDetailsVC.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 23/02/21.
//

import UIKit



class WeatherDetailsVC: UIViewController {

    enum RowInfo {
        case weather(info: WeatherDisplayInfoStruct),
             info(info: DisplayInfoStruct)
    }
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var cityWeatherModel: CityWeatherModel!
    var cityInfoModel: CityInfoModel!
    
    var rows = [RowInfo]()
    
    var isAddedToFavourite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI setup.
        self.initalUISetUp()
        //Generate row information.
        self.rows = self.genearetRowsInformationFromWeatherInfo(self.cityWeatherModel, andCityModel: self.cityInfoModel)
    }
    
}

//MARK: UI Related.
extension WeatherDetailsVC {
    
    func initalUISetUp() {
        self.initialTableViewSetUp(self.tableView)
        //Setup navigation items
        self.setUpNavigationItems(self.navigationItem, title: self.cityInfoModel.name)
    }
    
    func initialTableViewSetUp(_ tableView: UITableView) {
        //Set height to automatic.
        tableView.rowHeight = UITableView.automaticDimension
        //Register cells.
        self.registerCellOnTableView(tableView)
        //Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        //Add Footer.
        tableView.tableFooterView = self.createTableFooterViewWithIsSelected(self.isAddedToFavourite)
    }
    
    func registerCellOnTableView(_ tableView: UITableView) {
        //Weather info.
        let weatherInfoTableCellNib = UINib(nibName: WeatherInfoTableCell.reuseIdentifier, bundle: nil)
        tableView.register(weatherInfoTableCellNib, forCellReuseIdentifier: WeatherInfoTableCell.reuseIdentifier)
        //info cell.
        let infoTableCellNib = UINib(nibName: InfoTableCell.reuseIdentifier, bundle: nil)
        tableView.register(infoTableCellNib,
                           forCellReuseIdentifier: InfoTableCell.reuseIdentifier)
    }
    
    func setUpNavigationItems(_ navigationItem: UINavigationItem, title: String) {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismiss(_:)))
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.title = title
        
    }
    
    @objc func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createTableFooterViewWithIsSelected(_ isSelected: Bool) -> UIView  {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80.0))
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Favourite", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Remove from Favourite", for: .selected)
        button.setTitleColor(UIColor.white, for: .selected)
        footerView.addSubview(button)
        //Add Constaints.
        button.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 10.0).isActive = true
        button.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -10.0).isActive = true
        button.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20.0).isActive = true
        button.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
        //Set selected.
        button.isSelected = isSelected
        //Add Action.
        button.addTarget(self, action: #selector(addOrRemoveToFavouriteButtonTapped(_:)), for: .touchUpInside)
        return footerView
    }
 
    
    /// Action which will be called after user clicks on "Add/Remove to favourite button."
    /// - Parameter sender: sender.
    @objc func addOrRemoveToFavouriteButtonTapped(_ sender: UIButton) {
        self.isAddedToFavourite = !self.isAddedToFavourite
        if isAddedToFavourite {
            CityStore.shared.addCityInFavourites(self.cityInfoModel)
        }else {
            CityStore.shared.removeCityFromFavourites(self.cityInfoModel)
        }
        sender.isSelected = self.isAddedToFavourite
        //Post Notification.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationIdentifiersKeys.favouritesUpdated),
                                        object: nil,
                                        userInfo: nil)
    }
    
}


extension WeatherDetailsVC {

    func genearetRowsInformationFromWeatherInfo(_ weatherInfo: CityWeatherModel, andCityModel cityModel: CityInfoModel) -> [RowInfo] {
        var rows = [RowInfo]()
        //First add weather info.
        rows.append(contentsOf: weatherInfo.getWeatherDisplayInfos.compactMap { RowInfo.weather(info: $0) })
        //TODO : Add other information as well.
        //Min Temp
        if let minTemperatureString = weatherInfo.main.getMinTemperatureString {
            rows.append(RowInfo.info(info: DisplayInfoStruct(title: "Minimum Temperature", description: minTemperatureString, icon: nil)))
        }
        //Maximum temperature.
        if let maxTemperatureString = weatherInfo.main.getMaxTemperatureString {
            rows.append(RowInfo.info(info: DisplayInfoStruct(title: "Maximum Temperature", description: maxTemperatureString, icon: nil)))
        }
        //Humidity
        rows.append(RowInfo.info(info: DisplayInfoStruct(title: "Humidity", description: "\(weatherInfo.main.humidity) %", icon: nil)))
        //Pressure
        rows.append(RowInfo.info(info: DisplayInfoStruct(title: "Pressure", description: "\(weatherInfo.main.pressure) hPa", icon: nil)))
        //Wind Speed
        rows.append(.info(info: DisplayInfoStruct(title: "Wind Speed",
                                                  description: weatherInfo.wind.getSpeedInKmAndHrString,
                                                  icon: nil)))
        //Wind degree.
        rows.append(.info(info: DisplayInfoStruct(title: "Wind Direction",
                                                  description: weatherInfo.wind.getDegreeString,
                                                  icon: nil)))
        
        return  rows
    }
    
}

extension WeatherDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.rows[indexPath.row] {
        case .weather(info: let info):
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableCell.reuseIdentifier, for: indexPath) as! WeatherInfoTableCell
            cell.updateWithInfo(info)
            return cell
        case .info(info: let info):
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableCell.reuseIdentifier, for: indexPath) as! InfoTableCell
            cell.updateWithInfo(info)
            return cell
        }
    }
    



}



//MARK:
extension WeatherDetailsVC {
    
    static func openDetailsFromController(_ presentingController: UIViewController,
                                          withCityWeatherModel cityWeatherModel: CityWeatherModel,
                                          andCityInfoModel cityInfoModel: CityInfoModel, isAddedToFavourite: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "WeatherDetailsVC") as! WeatherDetailsVC
        detailsVC.cityWeatherModel = cityWeatherModel
        detailsVC.cityInfoModel = cityInfoModel
        detailsVC.isAddedToFavourite = isAddedToFavourite
        let navController = UINavigationController(rootViewController: detailsVC)
        presentingController.present(navController, animated: true, completion: nil)
    }
    
}

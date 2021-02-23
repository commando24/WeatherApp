//
//  ViewController.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 21/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    enum Mode {
        case search,
             favourites
    }
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var searchResult = [CityInfoModel]()
    
    var  currentMode : Mode = .favourites {
        didSet {
            if oldValue != currentMode {
                self.tableView.reloadData()
            }
        }
    }
    
    var alert : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Inital UI setup.
        self.initialUISetup()
        //Register for notifications.
        self.registerForNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

//MARK: UI Related.
extension ViewController {
    
    fileprivate func initialUISetup() {
        self.initialTableViewSetUp(self.tableView)
        self.addSearchController()
    }
    
    func initialTableViewSetUp(_ tableView: UITableView) {
        tableView.tableFooterView = UIView()
        // register table cell on table view.
        self.registerCellOnTableView(tableView)
        //Set height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
    }
    
    func registerCellOnTableView(_ tableView: UITableView) {
        let favouriteCityTableCellNib = UINib(nibName: FavouriteCityTableCell.reuseIdentifier, bundle: nil)
        tableView.register(favouriteCityTableCellNib, forCellReuseIdentifier: FavouriteCityTableCell.reuseIdentifier)
    }
    
    func addSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    
}

//MARK: API Request.
extension ViewController {
    
    fileprivate func getCityWeatherForCity(_ city: CityInfoModel) {
        self.alert = self.displayAlertWithTitle("Please Wait", message: "We are fetching weather information.")
        WeatherAPIHelper.shared.getWeatherInformationForCityID("\(city.id)") { [weak self] (model, error) in
            if let model = model {
                self?.alert?.dismiss(animated: true, completion: {
                    self?.alert = nil
                    self?.displayWeatherInfo(model, forCity: city)
                })
            }
        }
    }
    
    fileprivate func displayWeatherInfo(_ info: CityWeatherModel, forCity city: CityInfoModel) {
        let _ = WeatherDetailsVC.openDetailsFromController(self, withCityWeatherModel: info,
                                                           andCityInfoModel: city,
                                                           isAddedToFavourite: CityStore.shared.favourites.contains(city))
    }
    
}


//MARK: Tableview delegate and data source.
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentMode {
        case .favourites:
            return CityStore.shared.favourites.count
        case .search:
            return searchResult.count
        }
    }
    
    func getCityInfoForMode(_ mode: Mode, atIndex index: Int) -> CityInfoModel {
        switch mode {
        case .favourites:
            return CityStore.shared.favourites[index]
        case .search:
            return self.searchResult[index]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCityTableCell.reuseIdentifier, for: indexPath) as? FavouriteCityTableCell else {
            return UITableViewCell()
        }
        let info = getCityInfoForMode(self.currentMode, atIndex: indexPath.row)
        cell.customizeWithCity(info)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = getCityInfoForMode(self.currentMode, atIndex: indexPath.row)
         self.getCityWeatherForCity(info)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard currentMode == .favourites else {
            return nil
        }
        let favouriteAction = UIContextualAction(style: .destructive, title: "Unfavorite") { (action, view, completionHandler) in
            CityStore.shared.removeCityFromFavourites(self.getCityInfoForMode(self.currentMode, atIndex: indexPath.row))
            //reload table.
            self.tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [favouriteAction])
    }
    
}

//MARK: Search Result Updating Related.
extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //Update Search Mode.
        self.updateModeTo(searchController.isActive ? .search : .favourites)
        guard let searchText = searchController.searchBar.text else {
            return
        }
        self.searchForCitiesWithText(searchText)
    }
    
    func searchForCitiesWithText(_ searchText: String) {
        self.searchResult = CityStore.shared.filterCitiesFromText(searchText)
        self.tableView.reloadData()
    }
    
    func updateModeTo(_ newMode: Mode) {
        self.currentMode = newMode
    }
    
}

//MARK: Alerts message related.
extension ViewController {
    
    func displayAlertWithTitle(_ title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        return alert
    }
    
}

//MARK: Notification related.
extension ViewController {
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateList(_:)),
                                               name: NSNotification.Name(rawValue: NotificationIdentifiersKeys.favouritesUpdated),
                                               object:nil)
    }
    
    @objc func updateList(_ notification: Notification) {
        self.tableView.reloadData()
    }
    
    /// func used to remove notification observer
    func removeObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: NotificationIdentifiersKeys.favouritesUpdated),
                                                  object: nil)
    }
    
}


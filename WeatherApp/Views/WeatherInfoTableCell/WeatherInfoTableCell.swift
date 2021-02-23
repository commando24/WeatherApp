//
//  WeatherInfoTableCell.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 23/02/21.
//

import UIKit
import Kingfisher

struct WeatherDisplayInfoStruct {
    let iconUrl: URL
    let weatherCondition: String
    let detailedWeatherCondition: String
    let temperatureString: String
    let dateAndTimeString: String
}

class WeatherInfoTableCell: UITableViewCell {

    static let reuseIdentifier = "WeatherInfoTableCell"
    
    @IBOutlet fileprivate weak var customImageView: UIImageView!
    @IBOutlet fileprivate weak var weatherLabel: UILabel!
    @IBOutlet fileprivate weak var temperatureLabel: UILabel!
    @IBOutlet fileprivate weak var weatherDetailLabel: UILabel!
    @IBOutlet fileprivate weak var dateAndTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateWithInfo(_ info: WeatherDisplayInfoStruct) {
        self.weatherLabel.text = info.weatherCondition
        self.weatherDetailLabel.text = info.detailedWeatherCondition
        self.temperatureLabel.text = info.temperatureString
        self.dateAndTimeLabel.text = info.dateAndTimeString
        self.customImageView.kf.setImage(with: info.iconUrl)
    }
    
    
}

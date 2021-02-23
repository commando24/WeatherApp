//
//  FavouriteCityTableCell.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 23/02/21.
//

import UIKit

class FavouriteCityTableCell: UITableViewCell {

    static let reuseIdentifier = "FavouriteCityTableCell"
    
    @IBOutlet fileprivate weak var titleLabel : UILabel!
    @IBOutlet fileprivate weak var descriptionLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func customizeWithCity(_ city: CityInfoModel) {
        self.titleLabel.text = city.name
        self.descriptionLabel.text = city.countryCode
    }
    
}

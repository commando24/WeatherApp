//
//  InfoTableCell.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 23/02/21.
//

import UIKit

struct DisplayInfoStruct {
    var title: String
    var description: String
    var icon: UIImage?
}

class InfoTableCell: UITableViewCell {

    static let reuseIdentifier = "InfoTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateWithInfo(_ info: DisplayInfoStruct) {
        self.textLabel?.text = info.title
        self.detailTextLabel?.text = info.description
        self.imageView?.image = info.icon
    }
    
}

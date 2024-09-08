//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 05.09.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    func configure(with model: CellModel) {
        dateLabel.text = model.date
        photoImageView.image = UIImage(named: model.image)
        
        if model.indexRow % 2 != 0 {
            likeButton.imageView?.image = UIImage(named: "Active") ?? UIImage()
        } else{
            likeButton.imageView?.image = UIImage(named: "No Active") ?? UIImage()
        }
        
        
    }
}

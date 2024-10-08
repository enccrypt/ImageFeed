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
    
    func configure(with model: ImagesListCellModel) {
        dateLabel.text = model.date
        photoImageView.image = UIImage(named: model.image)

        if model.indexIsEven {
            likeButton.imageView?.image = UIImage(named: "No Active")
        } else{
            likeButton.imageView?.image = UIImage(named: "Active")
        }
    }
}

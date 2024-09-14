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

        let likeImage = model.indexIsEven ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)

    }
}

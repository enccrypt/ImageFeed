//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 05.09.2024.
//

import UIKit
import Kingfisher

class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    func configure(with photo: Photo) {
        dateLabel.text = photo.createdAt.map { DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .none) } ?? "No Date"
            
        // Установить заглушку
        let placeholderImage = UIImage(named: "placeholder")
            
        // Настроить индикатор загрузки
        photoImageView.kf.indicatorType = .activity
            
        // Загрузка изображения
        if let url = URL(string: photo.thumbImageURL) {
            photoImageView.kf.setImage(
                with: url,
                placeholder: placeholderImage,
                options: nil,
                completionHandler: { [weak self] result in
                    guard let self = self else { return }
                        switch result {
                        case .success:
                            self.setNeedsLayout() // Перезагрузить высоту ячейки
                        case .failure:
                            print("Image loading failed")
                        }
                    }
                )
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            photoImageView.kf.cancelDownloadTask()
            photoImageView.image = nil
            dateLabel.text = nil
        }
}

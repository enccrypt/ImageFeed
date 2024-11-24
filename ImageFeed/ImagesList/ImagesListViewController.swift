//
//  ViewController.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 02.09.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPhotosUpdated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        
        imagesListService.fetchPhotosNextPage()
    }
    
    @objc private func onPhotosUpdated() {
        let newPhotos = imagesListService.photos
        let oldCount = photos.count
        photos = newPhotos
        
        if oldCount < photos.count {
            let newIndexPaths = (oldCount..<photos.count).map { IndexPath(row: $0, section: 0) }
            tableView.performBatchUpdates {
                tableView.insertRows(at: newIndexPaths, with: .automatic)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else { return }
            
            let photo = photos[indexPath.row]
            if let url = URL(string: photo.largeImageURL) {
                viewController.imageURL = url
            } else {
                print("Invalid URL string: \(photo.largeImageURL)")
            }
        }
    }

}

extension ImagesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let photo = photos[indexPath.row]
        imageListCell.configure(with: photo)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let width = tableView.bounds.width - 32
        return width * photo.aspectRatio + 16
    }
}

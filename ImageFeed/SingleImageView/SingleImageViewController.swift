//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 13.09.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}

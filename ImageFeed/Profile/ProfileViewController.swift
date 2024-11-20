//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 09.09.2024.
//


import UIKit
import Kingfisher

// расширенте для преобразования HEX в UIColor
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

final class ProfileViewController: UIViewController{
    
    private var profileImageServiceObserver: NSObjectProtocol?      // 1
    
    override func viewDidLoad() {
        super.viewDidLoad() // Вызов родительского метода
        view.backgroundColor = UIColor(hex: "1A1B22")
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        profileImage?.withTintColor(.gray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .boldSystemFont(ofSize: 23.0)
        nameLabel.textColor = UIColor(hex: "#FFFFFF")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        let mailLabel = UILabel()
        mailLabel.text = "@ekaterina_nov"
        mailLabel.font = .systemFont(ofSize: 13.0)
        mailLabel.textColor = UIColor(hex: "#AEAFB4")
        mailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mailLabel)
        
        mailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        mailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        
        let helloLabel = UILabel()
        helloLabel.text = "Hello, world!"
        helloLabel.font = .systemFont(ofSize: 13.0)
        helloLabel.textColor = UIColor(hex: "#FFFFFF")
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(helloLabel)
        
        helloLabel.topAnchor.constraint(equalTo: mailLabel.bottomAnchor, constant: 8).isActive = true
        helloLabel.leadingAnchor.constraint(equalTo: mailLabel.leadingAnchor).isActive = true
        
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "logout"), for: .normal)
        
        
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        backButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        
        // Получаем профиль из сервиса, если он уже загружен, или делаем асинхронный запрос
        if let profile = ProfileService.shared.profile {
            nameLabel.text = profile.name
            mailLabel.text = profile.loginName
            helloLabel.text = profile.bio
        } 
        
        profileImageServiceObserver = NotificationCenter.default    // 2
                .addObserver(
                    forName: ProfileImageService.didChangeNotification, // 3
                    object: nil,                                        // 4
                    queue: .main                                        // 5
                ) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar()                                 // 6
                }
        
        updateAvatar()
    }
                                                          // 10
    private func updateAvatar() {                                   // 8
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        //ищем imageView с аватаркой, чтобы обновить изображение
        if let imageView = view.subviews.compactMap( {$0 as? UIImageView }).first {
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "avatar"),
                options: [
                    .transition(.fade(0.2)), //плавная анимация на появление
                    .cacheOriginalImage // кэширование фоточки
                ]
            )
        }
    }
}

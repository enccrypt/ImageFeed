//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 09.09.2024.
//


import UIKit

final class ProfileViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad() // Вызов родительского метода
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        profileImage?.withTintColor(.gray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .boldSystemFont(ofSize: 23.0)
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        let mailLabel = UILabel()
        mailLabel.text = "@ekaterina_nov"
        mailLabel.font = .systemFont(ofSize: 13.0)
        mailLabel.textColor = UIColor.gray
        mailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mailLabel)
        
        mailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        mailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        
        let helloLabel = UILabel()
        helloLabel.text = "Hello, world!"
        helloLabel.font = .systemFont(ofSize: 13.0)
        helloLabel.textColor = UIColor.white
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(helloLabel)
        
        helloLabel.topAnchor.constraint(equalTo: mailLabel.bottomAnchor, constant: 8).isActive = true
        helloLabel.leadingAnchor.constraint(equalTo: mailLabel.leadingAnchor).isActive = true
        
        let favoriteLabel = UILabel()
        favoriteLabel.text = "Избранное"
        favoriteLabel.font = .boldSystemFont(ofSize: 23.0)
        favoriteLabel.textColor = UIColor.white
        favoriteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoriteLabel)
        
        favoriteLabel.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 24).isActive = true
        favoriteLabel.leadingAnchor.constraint(equalTo: helloLabel.leadingAnchor).isActive = true
        
        let savedImage = UIImage(named: "savedImage")
        let savedImageView = UIImageView(image: savedImage)
        savedImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(savedImageView)
        
        savedImageView.heightAnchor.constraint(equalToConstant: 115).isActive = true
        savedImageView.widthAnchor.constraint(equalToConstant: 115).isActive = true
        savedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 376).isActive = true
        savedImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 130).isActive = true
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "logout"), for: .normal)
        //backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)  //нужна ли обрабокта нажатия кнопки logout?

        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        backButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
    }
}

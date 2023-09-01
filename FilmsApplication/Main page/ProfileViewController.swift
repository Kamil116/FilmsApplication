//
//  ProfileViewController.swift
//  FilmsProject
//
//  Created by Тимур Жексимбаев on 19.07.2023.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {
        
    // MARK: profile picture
    private let profilePic: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.circle")
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    // MARK: email label
    private let emailLabel: UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 20, weight: .bold)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    // MARK: change email
    private let changeEmailButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(UIImage(systemName: "pencil.tip.crop.circle.badge.plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        button.tintColor = .black
        return button
    }()
    
    // MARK: delete user
    private let deleteUserButton: UIButton = {
        let redButton = UIButton(type: .system)
        redButton.translatesAutoresizingMaskIntoConstraints = false
        redButton.setTitle("Delete account", for: .normal)
        redButton.setTitleColor(.white, for: .normal)
        redButton.backgroundColor = UIColor.red
        redButton.setTitleColor(UIColor.white, for: .normal)
        redButton.layer.cornerRadius = 8
        return redButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        
        view.addSubview(profilePic)
        
        view.addSubview(emailLabel)
        emailLabel.text = getUserEmail()

        view.addSubview(changeEmailButton)
        changeEmailButton.addTarget(self, action: #selector(changeEmail), for: .touchUpInside)

        view.addSubview(deleteUserButton)
        deleteUserButton.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)
        
        setupLayout()
    }
    
    // MARK: gettig user email from database
    func getUserEmail() -> String {
        var userEmail = ""
        let user = Auth.auth().currentUser
        if let user = user {
            
            let uid = user.uid
            userEmail = user.email ?? ""
            
        }
        
        return userEmail
    }
    
        
    // MARK: setting constraints 
    func setupLayout() {
        NSLayoutConstraint.activate([
            
            profilePic.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePic.widthAnchor.constraint(equalToConstant: 300),
            profilePic.heightAnchor.constraint(equalToConstant: 300),

            emailLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 20),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            changeEmailButton.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 20),
            changeEmailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),

            deleteUserButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            deleteUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteUserButton.heightAnchor.constraint(equalToConstant: 50),
            deleteUserButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 1.5),
            
            
        ])
    }
}


// MARK: save new email
extension ProfileViewController {
    
    func showWarningALert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveChanges() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.commitChanges { error in
            if error != nil {
                self.showWarningALert(message: "Some error occured")
            } else {
                self.showWarningALert(message: "Success")
            }
        }
        
    }
    
    @objc func changeEmail() {
        changeEmailAlert()
    }
    
    func changeEmailAlert() {
        let ac = UIAlertController(title: "Change Email", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [unowned ac] _ in
            guard let answer = ac.textFields?[0].text else {
                self.showWarningALert(message: "You didn't enter a new email")
                return
            }
            
            self.saveEmail(newEmail: answer)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    


    func saveEmail(newEmail: String) {
        Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
            if error == nil {
                self.showWarningALert(message: "Success")
            } else {
                if newEmail.count == 0 {
                    self.showWarningALert(message: "New email is empty")
                }
            }
        }
    }

}

// MARK: delete user
extension ProfileViewController {
    
    @objc func deleteUser() {
        deleteUserAlert()
    }
    
    
    func deleteUserAlert() {
        let ac = UIAlertController(title: "Do you want to delete account?", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "YES", style: .default) { [unowned ac] _ in

            let user = Auth.auth().currentUser

            user?.delete { error in
              if let error = error {
                  self.showWarningALert(message: "Some error happened while deleting your account")
              } else {
                  self.showWarningALert(message: "Your account is deleted")
              }
            }
            
            self.saveChanges()
            
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: .cancel)
        
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
}





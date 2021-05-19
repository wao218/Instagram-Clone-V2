//
//  ViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/18/21.
//

import UIKit

class ViewController: UIViewController {

  let plusPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Email"
    textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
    textField.borderStyle = .roundedRect
    textField.font = UIFont.systemFont(ofSize: 14)
    return textField
  }()
  
  let usernameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Username"
    textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
    textField.borderStyle = .roundedRect
    textField.font = UIFont.systemFont(ofSize: 14)
    return textField
  }()
  
  let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Password"
    textField.isSecureTextEntry = true
    textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
    textField.borderStyle = .roundedRect
    textField.font = UIFont.systemFont(ofSize: 14)
    return textField
  }()
  
  let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(plusPhotoButton)

    plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: 140, height: 140))
    
    setupInputFields()

  }

  
  fileprivate func setupInputFields() {
    
    let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.spacing = 10
    
    view.addSubview(stackView)
    
    stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 20, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 200))
    
  }


}



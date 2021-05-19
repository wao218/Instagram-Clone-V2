//
//  ViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/18/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {

  // MARK: - UI ELEMENTS
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
    
    textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    
    return textField
  }()
  
  let usernameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Username"
    textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
    textField.borderStyle = .roundedRect
    textField.font = UIFont.systemFont(ofSize: 14)
    
    textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    
    return textField
  }()
  
  let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Password"
    textField.isSecureTextEntry = true
    textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
    textField.borderStyle = .roundedRect
    textField.font = UIFont.systemFont(ofSize: 14)
    
    textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    
    return textField
  }()
  
  let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    
    button.isEnabled = false
    
    button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    
    return button
  }()
  
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(plusPhotoButton)

    plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: 140, height: 140))
    
    setupInputFields()

  }

  // MARK: - HELPER METHODS
  fileprivate func setupInputFields() {
    
    let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.spacing = 10
    
    view.addSubview(stackView)
    
    stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 20, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 200))
    
  }
  
  
  // MARK: - ACTION METHODS
  @objc private func handleSignUp() {
    
    guard let email = emailTextField.text, !email.isEmpty else { return }
    guard let username = usernameTextField.text, !username.isEmpty else { return }
    guard let password = passwordTextField.text, !password.isEmpty else { return }
    
    Firebase.Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
      guard authResult != nil, error == nil else {
        print("Failed to create user: ", error ?? "")
        return
      }
      
      print("Successfully created user: ", authResult?.user.uid ?? "")
      
    }
  }
  
  @objc private func handleTextInputChange() {
    
    let isFormValid = !(emailTextField.text?.isEmpty ?? true) && !(usernameTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
    
    if isFormValid {
      signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
      signUpButton.isEnabled = true
    } else {
      signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
      signUpButton.isEnabled = false
    }
    
  }


}



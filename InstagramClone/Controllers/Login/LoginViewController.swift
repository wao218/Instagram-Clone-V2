//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/1/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
  // MARK - UI ELEMENTS
  let logoContainer: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
    
    let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
    logoImageView.contentMode = .scaleAspectFill
    
    view.addSubview(logoImageView)
    logoImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 50))
    
    return view
  }()
  
  let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    
    let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    
    attributedTitle.append(NSAttributedString(string: "Sign Up.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
    
    button.setAttributedTitle(attributedTitle, for: .normal)
    
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
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
  
  let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    
    button.isEnabled = false
    
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    
    return button
  }()
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    
    view.backgroundColor = .white
    
    view.addSubview(signUpButton)
    view.addSubview(logoContainer)
    
    signUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
    
    logoContainer.anchor(top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 150))
    
    setupInputFields()
  }
  
  // MARK: - HELPER METHODS
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private func setupInputFields() {
    let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    
    view.addSubview(stackView)
    stackView.anchor(top: logoContainer.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 40, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 140))
  }
  
  
  // MARK: - ACTION METHODS
  @objc private func handleShowSignUp() {
    let registerVC = RegisterViewController()
    navigationController?.pushViewController(registerVC, animated: true)
  }
  
  @objc private func handleLogin() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    Firebase.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
      guard error == nil else {
        print("Failed to sign in with email: ", error ?? "")
        return
      }
      
      print("Successfully logged back in with user: ", authResult?.user.uid ?? "")
      
      guard let mainTabBarController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? MainTabBarViewController else { return }
      
      mainTabBarController.setupViewControllers()
      
      self?.dismiss(animated: true, completion: nil)
    }
  }
  
  @objc private func handleTextInputChange() {
    
    let isFormValid = !(emailTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
    
    if isFormValid {
      loginButton.backgroundColor = .mainBlue()
      loginButton.isEnabled = true
    } else {
      loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
      loginButton.isEnabled = false
    }
    
  }

}

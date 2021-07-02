//
//  ViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/18/21.
//

import UIKit
import Firebase
import FirebaseMessaging

class RegisterViewController: UIViewController {

  // MARK: - UI ELEMENTS
  let plusPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
    
    button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
    
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
  
  let loginButton: UIButton = {
    let button = UIButton(type: .system)
    
    let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    
    attributedTitle.append(NSAttributedString(string: "Sign In.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
    
    button.setAttributedTitle(attributedTitle, for: .normal)
    
    button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
    return button
  }()
  
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    view.addSubview(plusPhotoButton)

    plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: 140, height: 140))
    
    setupInputFields()
    
    view.addSubview(loginButton)
    loginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))

  }

  // MARK: - HELPER METHODS
  private func setupInputFields() {
    
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
    
    Firebase.Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
      guard authResult != nil, error == nil else {
        print("Failed to create user: ", error ?? "")
        return
      }
      
      print("Successfully created user: ", authResult?.user.uid ?? "")
      
      guard let uid = authResult?.user.uid else { return }
      guard let image = self?.plusPhotoButton.imageView?.image else { return }
      
      guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
      
      let filename = NSUUID().uuidString
      
      Firebase.Storage.storage().reference().child("profile_images/\(filename)").putData(uploadData, metadata: nil) { (metadata, error) in
        
        guard error == nil else {
          print("Failed to upload profile image: ", error ?? "")
          return
        }
        
        
        Firebase.Storage.storage().reference().child("profile_images/\(filename)").downloadURL { (url, error) in
          guard error == nil else { return }
          guard let url = url else {
            print("Failed to get profile image download url: ", error ?? "")
            return
          }
          
          let urlString = url.absoluteString
          print("Successfully uploaded profile image: ", urlString)
          
          guard let fcmToken = Messaging.messaging().fcmToken else { return }
          
          let dictionaryValues = [
            "username": username,
            "profileImageUrl": urlString,
            "fcmToken": fcmToken
          ]
          let values = [uid: dictionaryValues]

          Firebase.Database.database().reference().child("users").updateChildValues(values) { (error, ref) in
            guard error == nil else {
              print("Failed to save user info into db: ", error ?? "")
              return
            }

            print("Successfully saved user info into db")
            
            guard let mainTabBarController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? MainTabBarViewController else { return }
            
            mainTabBarController.setupViewControllers()
            
            self?.dismiss(animated: true, completion: nil)
          }
        }
      }
    }
  }
  
  @objc private func handleShowLogin() {
    navigationController?.popViewController(animated: true)
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
  
  @objc private func handlePlusPhoto() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    
    present(imagePickerController, animated: true, completion: nil)
  }


}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
    plusPhotoButton.layer.masksToBounds = true
    plusPhotoButton.layer.borderColor = UIColor.black.cgColor
    plusPhotoButton.layer.borderWidth = 2
    
    picker.dismiss(animated: true, completion: nil)
  }
}



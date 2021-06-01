//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/1/21.
//

import UIKit

class LoginViewController: UIViewController {
  let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Don't have an account? Sign Up.", for: .normal)
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    
    view.backgroundColor = .white
    
    view.addSubview(signUpButton)
    signUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
  }
  
  
  @objc private func handleShowSignUp() {
    let registerVC = RegisterViewController()
    navigationController?.pushViewController(registerVC, animated: true)
  }
}

//
//  ViewController.swift
//  ScmpApp
//
//  Created by Fragilehm on 11/11/18.
//  Copyright © 2018 Fragilehm. All rights reserved.
//

import UIKit
struct Token: Decodable {
    var token: String
}
class ViewController: UIViewController {
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your email"
        textField.borderStyle = .roundedRect
        textField.text = "peter@klaven.com"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.text = "cityslicka"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.placeholder = "Enter your password"
        textField.isSecureTextEntry = true
        return textField
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(loginDidPress), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func setupController() {
        self.view.backgroundColor = UIColor.white
        self.title = "Login"
        addLogoImageView()
        addEmailTextField()
        addPasswordTextField()
        addLoginButton()
        addActivityIndicator()
    }

    private func addActivityIndicator() {
        self.view.addSubview(activityIndicator)
        self.activityIndicator.frame = self.view.frame
        self.activityIndicator.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        //self.activityIndicator.startAnimating()
    }
    private func addLogoImageView() {
        self.view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.logoImageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100),
            self.logoImageView.heightAnchor.constraint(equalTo: self.logoImageView.widthAnchor, multiplier: 0.8)
        ])
    }
    private func addEmailTextField() {
        self.view.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            self.emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emailTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor),
            self.emailTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
        ])
    }
    private func addPasswordTextField() {
        self.view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 24),
            self.passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor)
        ])
    }
    private func addLoginButton() {
        self.view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 24),
            self.loginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    @objc func loginDidPress(_ sender: UIButton) {
        //print("did press")
        checkCredentials()
    }
    private func checkCredentials() {
        if let email = self.emailTextField.text, let password = passwordTextField.text {
            if isValidEmail(string: email) && password != "" {
                //showMainViewController(with: "")
                self.activityIndicator.startAnimating()
                postRequest(email: email, password: password)
            } else {
                showAlertMessage(with: "Please, enter valid credentials")
            }
        }
        
    }
    private func postRequest(email: String, password: String) {
        guard let url = URL(string: "https://reqres.in/api/login?delay=0") else { return }
        let parameters = [
            "email": email,
            "password": password
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        print(httpBody)
        request.httpBody = httpBody
        //print(request)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    
                    let token = try JSONDecoder().decode(Token.self, from: data)
                    self.showMainViewController(with: token.token)
                } catch {
                    self.showAlertMessage(with: "Something went wrong")
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    private func isValidEmail(string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    private func showMainViewController(with token: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let mainViewController = MainViewController()
            mainViewController.token = token
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
        
    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    func showAlertMessage(with message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}


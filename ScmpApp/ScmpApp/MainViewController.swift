//
//  MainViewController.swift
//  ScmpApp
//
//  Created by Fragilehm on 11/11/18.
//  Copyright © 2018 Fragilehm. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var token: String?
    lazy var tokenLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
        // Do any additional setup after loading the view.
    }

    private func setupController() {
        self.view.backgroundColor = .white
        self.title = "Token"
        addTokenLabel()
        setToken()
    }
    private func addTokenLabel() {
        self.view.addSubview(tokenLabel)
        NSLayoutConstraint.activate([
            self.tokenLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tokenLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    private func setToken() {
        //if let token = self.token {
            self.tokenLabel.text = token
        //}
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

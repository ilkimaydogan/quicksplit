//
//  ViewController.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 19.02.2025.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signUpButton.layer.cornerRadius = 12
        loginButton.layer.cornerRadius = 12

    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
    }
    
}


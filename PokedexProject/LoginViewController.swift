//
//  LoginViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/9/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var tfEmail: UITextField!
    
    @IBOutlet private weak var tfPassword: UITextField!
    
    @IBOutlet private weak var lblErrorMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserModel()
        user.email = "x@y.com"
        user.password = "jjj"
        CoreDataSaveOps.shared.saveUser(userObject: user)
    }
    
    @IBAction private func btnActionLogin(_ sender: Any) {
        
        guard let email = tfEmail.text else { return }
        guard let password = tfPassword.text else { return }
        
        if !isValidEmail(emailStr: email) {
            lblErrorMsg.text = "Email format invalid. Please retype."
            return
        }
        
        let users = CoreDataFetchOps.shared.getUserby(email: email)
        if users.count != 0 {
            if users[0].password == password {
                
                User.loggedInUserEmail = email
                performSegue(withIdentifier: K.Segue.loggedIn, sender: self)
            } else {
                lblErrorMsg.text = "Invalid email / password, Please try again."
            }
        }
    }
    
    func isValidEmail(emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}

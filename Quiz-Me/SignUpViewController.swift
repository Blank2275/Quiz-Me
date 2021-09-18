//
//  SignUpViewController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 8/31/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signUp(_ sender: Any){
        let usernameText: String = username.text ?? ""
        let passwordText:String = password.text ?? ""
        let confirmText:String = confirmPassword.text ?? ""
        if passwordText == confirmText {
            Auth.auth().createUser(withEmail: usernameText, password: passwordText, completion: {error, authError in
                if error != nil {print(error)}
                if authError != nil {print(authError)}
                
                postData(path: "new-user", data: nil, text: usernameText){_ in
                    
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = storyboard.instantiateViewController(identifier: "Home View")
                self.dismiss(animated: true, completion: nil)
                
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

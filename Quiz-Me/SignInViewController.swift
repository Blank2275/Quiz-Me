//
//  SignInViewController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 8/31/21.
//

import UIKit
import Firebase

protocol SignInDelegate: AnyObject{
    
}

class SignInViewController: UIViewController, SignInDelegate {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    weak var delegate: SignInDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        print("test")
        // Do any additional setup after loading the view.
    }
    @IBAction func signIn(_ sender: Any) {
        let email = emailInput.text ?? ""
        let password = passwordInput.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {return}
            getUserData()
            if Auth.auth().currentUser?.uid != nil{
                self?.navigationController?.popViewController(animated: true)
            }
            
        })
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

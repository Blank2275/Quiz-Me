//
//  AccountViewController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 10/30/21.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLabel.text = "\(email )"
        self.nameLabel.text = "\(username )"
        self.nameInput.text = username
        // Do any additional setup after loading the view.
    }
    @IBAction func nameSubmit(_ sender: Any) {
        let newName = self.nameInput.text ?? "unknown"
        username = newName
        let userData = [
            "username": username,
            "email":email
        ]

        guard let stringData = try? JSONSerialization.data(withJSONObject: userData, options: []) else {
            return
        }
        postData(path: "change-username", data: stringData, text: nil){data in
        }
        self.nameLabel.text = newName
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

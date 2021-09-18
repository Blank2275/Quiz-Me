//
//  ViewController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 8/30/21.
//

import UIKit
import Firebase
import Starscream

var data: [[[String]]] = []
var selectedQuiz = 0
var currentQuestion = 0
var answersCorrect: [Bool] = []

let testing = true
let testingURL = "http://localhost:8070/"
let productionURL = "https://quiz-me-backend-connor.herokuapp.com/"
let currentURL = testing ? testingURL : productionURL

func getData(path: String, completionHandler: @escaping(_ data: Data) -> ()) -> Data?{
    guard let url = URL(string: "\(currentURL)\(path)") else {return nil}
    var parsedArray:[[[String]]]! = []
    var data:Data?
    let task = URLSession.shared.dataTask(with: url){d, response, error in
        if let error = error{
            print(error)
        }
        guard let data_ = d else {return}
        guard let dataString = String(data: data_, encoding: .utf8) else {return}
        data = data_
        completionHandler(data_)
    }
    task.resume()
    return data
}

class ViewController: UIViewController{
    let server = currentURL
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var signInbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()

        Auth.auth().addStateDidChangeListener(){auth, user in
            if user == nil{
                self.logOutButton.isEnabled = false
                self.signInbutton.isEnabled = true
            } else{
                self.logOutButton.isEnabled = true
                self.signInbutton.isEnabled = false
            }
        }
        var parsedArray:[[[String]]]! = []
         getData(path: ""){data_ in
            parsedArray = try? JSONSerialization.jsonObject(with: data_, options: []) as? [[[String]]]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            data = parsedArray ?? []
        })
        /*
        let db = Firestore.firestore()
        let collection = db.collection("quizzes")
        collection.getDocuments(){(querySnapshot, err) in
            if let err = err{
                print(err)
            } else{
                for document in querySnapshot!.documents {
                    var data_ = document.data()["data"] as! [[String:Any]]
                    //data_ = data[0] as! [Any]
                    var formattedData: [[String]] = []
                    formattedData.append([document.documentID, "test"])
                    for var question in data_{
                        var generated:[String] = []
                        generated.append(question["question"] as! String)
                        generated.append(question["answer1"] as! String)
                        generated.append(question["answer2"] as! String)
                        generated.append(question["answer3"] as! String)
                        generated.append(question["answer4"] as! String)
                        generated.append(question["answer"] as! String)
                        formattedData.append(generated)
                    }
                    data.append(formattedData)
                }
            }
            
        }
        */
        // Do any additional setup after loading the view.
    }
    @IBAction func logOut(_ sender: Any) {
        if Auth.auth() != nil {
            try! Auth.auth().signOut()
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "BrowseViewController" || identifier == "CreateScreen"{
            if Auth.auth().currentUser?.uid == nil{
                return false
            }
        }
        return true
    }

}


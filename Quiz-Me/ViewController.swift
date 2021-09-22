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
var likesDislikes:[String: String] = [:]

let testing = true
let testingURL = "http://localhost:8070/"
let productionURL = "https://quiz-me-backend-connor.herokuapp.com/"
let currentURL = testing ? testingURL : productionURL

func getData(path: String, completionHandler: @escaping(_ d: Data?) -> ()) -> Data?{
    guard let url = URL(string: "\(currentURL)\(path)") else {return nil}
    var parsedArray:[[[String]]]! = []
    var data:Data?
    let task = URLSession.shared.dataTask(with: url){d, response, error in
        if let error = error{
            print(error)
        }
        guard let data_ = d else {return}
        guard let dataString = String(data: data_, encoding: .utf8) else {return}
        data = d
        completionHandler(d)
    }
    task.resume()
    return data
}

func postData(path:String, data: Data?, text:String?, completionHandler: @escaping(_ data: Data) -> ()){
    guard let serviceUrl = URL(string: "\(currentURL)\(path)") else {return}
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
    
    var httpBody = data
    if text != nil{
        httpBody = text?.data(using: .utf8)
    }
    
    request.httpBody = httpBody
    request.timeoutInterval = 20
    let session = URLSession.shared
    session.dataTask(with: request){(data, response, error) in
        if let response = response{
            //print(response)
        }
        if let data = data{
            do{
                completionHandler(data)
            } catch{
                print(error)
            }
        }
    }.resume()
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
            parsedArray = try? JSONSerialization.jsonObject(with: data_ ?? Data.init(), options: []) as? [[[String]]]
        }
        let email = Auth.auth().currentUser?.email
        postData(path: "get-likes-dislikes", data: nil, text: email){data_ in
            let likesDislikesUnformatted = try! JSONSerialization.jsonObject(with: data_, options: []) as! [String : [String]]
            for like in likesDislikesUnformatted["likedPosts"]!{
                likesDislikes[like] = "true"
            }
            for dislike in likesDislikesUnformatted["dislikedPosts"]!{
                likesDislikes[dislike] = "false"
            }
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
                let alertController = UIAlertController(title: "Quiz Me", message: "Please sign in to use this feature", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
                
                return false
            }
        }
        return true
    }

}


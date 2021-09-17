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

class ViewController: UIViewController{
    let server = "http://localhost:8070"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        guard let url = URL(string: server) else {return}
        var parsedArray:[[[String]]]?
        let task = URLSession.shared.dataTask(with: url){d, response, error in
            if let error = error{
                print(error)
                return
            }
            guard let data_ = d else {return}
            guard let dataString = String(data: data_, encoding: .utf8) else {return}
                
            do{
                parsedArray = try? JSONSerialization.jsonObject(with: data_, options: []) as? [[[String]]]
                
            } catch let error as NSError{
                print(error)
            }
        }
        task.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            data = parsedArray!
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


}


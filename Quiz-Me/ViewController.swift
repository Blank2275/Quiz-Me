//
//  ViewController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 8/30/21.
//

import UIKit
import Firebase

var data: [[[String]]] = []
var selectedQuiz = 0
var currentQuestion = 0
var answersCorrect: [Bool] = []

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
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
        // Do any additional setup after loading the view.
    }


}


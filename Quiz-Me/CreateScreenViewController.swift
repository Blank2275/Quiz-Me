//
//  CreateScreenViewController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 9/17/21.
//

import UIKit

class CreateScreenViewController: UIViewController {
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var questionNameInput: UITextField!
    @IBOutlet weak var question1Input: UITextField!
    @IBOutlet weak var question2Input: UITextField!
    @IBOutlet weak var question3Input: UITextField!
    @IBOutlet weak var question4Input: UITextField!
    @IBOutlet weak var correctQuestionInput: UISegmentedControl!
    var currentQuestionEditing = 1
    var correctQuestion = 1
    var quiz:[[String]] = [
            ["Untitled Quiz", "test"],
            ["empty", "empty", "empty", "empty", "empty", "1"]
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayNewQuestion()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    func displayNewQuestion(){
        let questionData = self.quiz[self.currentQuestionEditing]
        self.questionNameInput.text = questionData[0]
        self.question1Input.text = questionData[1]
        self.question2Input.text = questionData[2]
        self.question3Input.text = questionData[3]
        self.question4Input.text = questionData[4]
        self.correctQuestionInput.selectedSegmentIndex = (Int(questionData[5]) ?? 1) - 1
    }
    @IBAction func titleChanged(_ sender: Any) {
        let newTitle = titleInput.text
        self.quiz[0][0] = newTitle ?? "Untitled Quiz"
    }
    @IBAction func questionTitleChanged(_ sender: Any) {
        let newQuestionName = questionNameInput.text
        self.quiz[currentQuestionEditing][0] = newQuestionName ?? "empty"
    }
    @IBAction func question1Edited(_ sender: Any) {
        let newQuestion1 = question1Input.text ?? "empty"
        self.quiz[currentQuestionEditing][1] = newQuestion1
    }
    @IBAction func question2Edited(_ sender: Any) {
        let newQuestion2 = question2Input.text ?? "empty"
        self.quiz[currentQuestionEditing][2] = newQuestion2
    }
    @IBAction func question3Edited(_ sender: Any) {
        let newQuestion3 = question3Input.text ?? "empty"
        self.quiz[currentQuestionEditing][3] = newQuestion3
    }
    @IBAction func question4Edited(_ sender: Any) {
        let newQuestion4 = question4Input.text ?? "empty"
        self.quiz[currentQuestionEditing][4] = newQuestion4
    }
    @IBAction func correctQuestionChanged(_ sender: Any) {
        //correctQuestionInput.selectedSegmentIndex
        self.correctQuestion = correctQuestionInput.selectedSegmentIndex + 1
        self.quiz[currentQuestionEditing][5] = String(self.correctQuestion)
        
    }
    @IBAction func finishQuiz(_ sender: Any) {
        guard let serviceUrl = URL(string: "\(currentURL)submit-quiz") else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: self.quiz, options: []) else{
            return
        }
        print(httpBody)
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            if let response = response{
                print(response)
            }
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch{
                    print(error)
                }
            }
        }.resume()
        
    }
    @IBAction func nextQuestion(_ sender: Any) {
        self.currentQuestionEditing += 1
        if self.currentQuestionEditing >= self.quiz.count {
            self.quiz.append(["empty", "empty", "empty", "empty", "empty", "1"])
        }
        self.displayNewQuestion()
    }
    @IBAction func previousQuestion(_ sender: Any) {
        if(self.currentQuestionEditing > 1){
            self.currentQuestionEditing -= 1
            self.displayNewQuestion()
            print("previous")
        }
    }
    
    
}

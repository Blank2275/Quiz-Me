//
//  CreateScreenViewController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 9/17/21.
//

import UIKit
import Firebase

class CreateScreenViewController:UIViewController{
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
        
        //scroll up on editing code from https://fluffy.es/move-view-when-keyboard-is-shown/
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
        let input1Focused = self.question1Input.isEditing
        let input2Focused = self.question2Input.isEditing
        let input3Focused = self.question3Input.isEditing
        let input4Focused = self.question4Input.isEditing
        if(input1Focused || input2Focused || input3Focused || input4Focused){
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
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
        let email = Auth.auth().currentUser?.email
        self.quiz.append([email ?? "unknown"])
        guard let stringQuiz = try? JSONSerialization.data(withJSONObject: self.quiz, options: []) else{
            return
        }
        self.navigationController?.popViewController(animated: true)
        postData(path: "submit-quiz", data: stringQuiz, text: nil){_ in}
        
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

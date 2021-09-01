//
//  QuizQuestionController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 8/30/21.
//

import UIKit

class QuizQuestionController: UIViewController {
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestion = 0
        self.loadQuestion()

    }
    func loadQuestion(){
        self.question.text = data[selectedQuiz][0][0]
        self.titleLabel.text = data[selectedQuiz][currentQuestion + 1][0]
        var question = data[selectedQuiz][currentQuestion + 1]
        self.answer1.setTitle(question[1], for: .normal)
        self.answer2.setTitle(question[2], for: .normal)
        self.answer3.setTitle(question[3], for: .normal)
        self.answer4.setTitle(question[4], for: .normal)
    }
    @IBAction func answer1Pressed(_ sender: Any) {
        self.handleAnswer(num: 0)
    }
    @IBAction func answer2Pressed(_ sender: Any) {
        self.handleAnswer(num: 1)
    }
    @IBAction func answer3Pressed(_ sender: Any) {
        self.handleAnswer(num: 2)
    }
    @IBAction func answer4Pressed(_ sender: Any) {
        self.handleAnswer(num: 3)
    }
    func handleAnswer(num: Int){
        var question = data[selectedQuiz][currentQuestion + 1]
        answersCorrect.append(question[num + 1] == question[Int(question[5]) ?? 0])
        print(question[num + 1])
        if(currentQuestion < data[selectedQuiz].count - 2){
            currentQuestion += 1
            self.loadQuestion()
        } else{

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "ResultsViewController")
            show(controller, sender: self)
            
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

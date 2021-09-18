//
//  ResultsViewController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 8/30/21.
//

import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var passFail: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var total = 0
        for question in answersCorrect{
            total += question ? 1 : 0
        }
        print(answersCorrect)
        var percent:Float = Float(total / (data[selectedQuiz].count - 2))
        var pass = percent >= 0.75 ? true : false;
        if pass {
            self.view.backgroundColor = UIColor.green
            self.passFail.text = "Pass"
        } else{
            self.view.backgroundColor = UIColor.red
            self.passFail.text = "Fail :("
        }
        self.score.text = "Score: \(total) / \(data[selectedQuiz].count - 2)"
        
        // Do any additional setup after loading the view.
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

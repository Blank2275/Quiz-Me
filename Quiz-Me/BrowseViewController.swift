//
//  BrowseViewController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 8/30/21.
//

import UIKit
import Firebase

func fetchQuizData(completionHandler: @escaping(_ data_: [[[String]]]) -> ()){
    data = []
    var parsedArray:[[[String]]]? = nil
        getData(path: ""){d in
            print(d ?? Data.init())
            parsedArray = try! JSONSerialization.jsonObject(with: d ?? Data.init(), options: []) as! [[[String]]]
            if(parsedArray == nil){
                print("tried again");
                fetchQuizData(){d in
                }
                completionHandler(parsedArray ?? [])
            }
            completionHandler(parsedArray ?? [])
       }
}

class BrowseViewController: UITableViewController, CellDelegate {
    var defaultColor = UIColor.red;
    var disabledColor = UIColor.gray;
    let email = Auth.auth().currentUser?.email
    func like(_ cell: BrowseCell) {
        cell.dislikeButton.backgroundColor = UIColor.red
        cell.likeButton.backgroundColor = UIColor.gray
        
        let index = self.tableView.indexPath(for: cell)![1]
        let nameOfLikedPost = data[index][0][0]
        if likesDislikes[nameOfLikedPost] != "true" {
            var unDislike = "false"
            if likesDislikes[nameOfLikedPost] == "false"{
                unDislike = "true"
                data[index][data[index].count - 1][1] = String((Int(data[index][data[index].count - 1][1]) ?? 1) - 1)
            }
            data[index][data[index].count - 1][0] = String((Int(data[index][data[index].count - 1][0]) ?? 1) + 1)
            if likesDislikes[nameOfLikedPost] == nil || likesDislikes[nameOfLikedPost] == "false"{
                likesDislikes[nameOfLikedPost] = "true"
                guard let data_ = try? JSONSerialization.data(withJSONObject: [unDislike, nameOfLikedPost, email], options: []) else{
                    return
                }
                postData(path: "like", data: data_, text: nil){_ in
                    
                }
            }
            
            cell.likeCounter.text = data[index][data[index].count - 1][0]
            cell.dislikeCounter.text = data[index][data[index].count - 1][1]
        }
    }
    
    func dislike(_ cell: BrowseCell) {
        cell.dislikeButton.backgroundColor = UIColor.gray
        cell.likeButton.backgroundColor = UIColor.red
        
        let index = self.tableView.indexPath(for: cell)![1]
        let nameOfDislikedPost = data[index][0][0]
        if likesDislikes[nameOfDislikedPost] != "false" {
            var unLike = "false"
            if likesDislikes[nameOfDislikedPost] == "true"{
                unLike = "true"
                data[index][data[index].count - 1][0] = String((Int(data[index][data[index].count - 1][0]) ?? 1) - 1)
            }
            data[index][data[index].count - 1][1] = String((Int(data[index][data[index].count - 1][1]) ?? 1) + 1)

            if likesDislikes[nameOfDislikedPost] == nil || likesDislikes[nameOfDislikedPost] == "true"{
                likesDislikes[nameOfDislikedPost] = "false"
                guard let data_ = try? JSONSerialization.data(withJSONObject: [unLike, nameOfDislikedPost, email], options: []) else{
                    return
                }
                postData(path: "dislike", data: data_, text: nil){_ in
                }
            }
            cell.likeCounter.text = data[index][data[index].count - 1][0]
            cell.dislikeCounter.text = data[index][data[index].count - 1][1]
        }
    }
    
    let server = "\(currentURL)"
    let navController = UINavigationController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        if Auth.auth().currentUser?.uid == nil{
            dismiss(animated: true, completion:nil)
        }
        fetchQuizData(){d in
            data = d
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private func registerTableViewCells(){
        let tableViewCell = UINib(nibName: "BrowseCell", bundle: nil)
        self.tableView.register(tableViewCell, forCellReuseIdentifier:"BrowseCell")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseCell", for: indexPath) as? BrowseCell{
            cell.quizName?.text = data[indexPath.row][0][0]
            cell.delegate = self
            var likeEnable = true
            var dislikeEnable = true
            if likesDislikes[data[indexPath.row][0][0]] != nil {
                if likesDislikes[data[indexPath.row][0][0]] == "true"{
                    likeEnable = false
                } else{
                    dislikeEnable = false
                }
            }
            cell.likeButton.backgroundColor = likeEnable ? self.defaultColor : self.disabledColor
            cell.dislikeButton.backgroundColor = dislikeEnable ? self.defaultColor : self.disabledColor
            cell.likeCounter.text = data[indexPath.row][data[indexPath.row].count - 1][0]
            cell.dislikeCounter.text = data[indexPath.row][data[indexPath.row].count - 1][1]
            return cell as! BrowseCell
        }
        // Configure the cell...
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuiz = indexPath.row
        currentQuestion = 0
        answersCorrect = []
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "QuizView")

        show(secondVC, sender: self)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

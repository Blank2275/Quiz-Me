//
//  BrowseViewController.swift
//  Quiz-Me
//
//  Created by Connor Reed on 8/30/21.
//

import UIKit
import Firebase

class BrowseViewController: UITableViewController {
    let server = "\(currentURL)"
    let navController = UINavigationController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        if Auth.auth().currentUser?.uid == nil{
            print("dismiss")
            dismiss(animated: true, completion:nil)
        }
        var parsedArray:[[[String]]]! = []
         getData(path: ""){data_ in
            parsedArray = try? JSONSerialization.jsonObject(with: data_, options: []) as? [[[String]]]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            data = parsedArray ?? []
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            return cell as! BrowseCell
        }
        print(BrowseCell())
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

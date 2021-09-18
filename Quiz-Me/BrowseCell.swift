//
//  BrowseCell.swift
//  Quiz-Me
//
//  Created by Connor Reed on 9/18/21.
//

import UIKit
protocol CellDelegate: class{
    func like (_ cell: BrowseCell)
    func dislike (_ cell: BrowseCell)
}
class BrowseCell: UITableViewCell {

    @IBOutlet weak var quizName: UILabel!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var upvoteCounter: UILabel!
    @IBOutlet weak var dislikeCounter: UILabel!
    
    @IBOutlet weak var likeCounter: UILabel!
    weak var delegate: CellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func like(_ sender: Any) {
        self.delegate?.like(self)
    }
    @IBAction func dislike(_ sender: Any) {
        self.delegate?.dislike(self)
    }
    
}

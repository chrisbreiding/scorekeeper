import UIKit

class BoardCell : UICollectionViewCell, UITextFieldDelegate {
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet private weak var scoresView: UITableView!
    @IBOutlet var scoresTotalView: UITextView!

    var board: BoardModel?
    var onUpdateName: (String -> Void)?
    var onAddScore: (Void -> Void)?
    var onRemove: (BoardModel -> Void)?
    var scoresTotal: Int {
        get {
            guard let scores = board?.scores else { return 0 }
            return scores.reduce(0, combine: { total, score in total + score.score })
        }
    }
    
    func setBoardProps(board: BoardModel, onUpdateName: (String -> Void), onRemove: (BoardModel -> Void)) {
        self.board = board
        self.onUpdateName = onUpdateName
        self.onRemove = onRemove

        nameField.text = board.name
        scoresView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        scoresTotalView.text = String(scoresTotal)
    }

    override func canBecomeFocused() -> Bool {
        return false
    }

    func textFieldDidEndEditing(textField: UITextField) {
        let name = (textField.text ?? "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        onUpdateName!(name)
    }
    
    @IBAction func handleAddScore() {
        onAddScore!()
    }
    
    @IBAction func handleRemoval() {
        onRemove!(self.board!)
    }
    
    func setScoresViewDataSourceDelegate<D: protocol<UITableViewDataSource, UITableViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        scoresView.delegate = dataSourceDelegate
        scoresView.dataSource = dataSourceDelegate
        scoresView.tag = row
        scoresView.reloadData()
    }
    
    func setAddScoreHandler(onAddScore: (Void -> Void)) {
        self.onAddScore = onAddScore
    }
}

class AddBoardCell : UICollectionViewCell {
    override func canBecomeFocused() -> Bool {
        return false
    }
}

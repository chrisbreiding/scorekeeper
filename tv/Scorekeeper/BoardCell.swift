import UIKit

class BoardCell : UICollectionViewCell, UITextFieldDelegate {
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet private weak var scoresView: UITableView!
    @IBOutlet var scoresTotalView: UITextView!

    var board: BoardModel?
    var onUpdateName: (String -> ())?
    var onAddScore: (() -> ())?
    var onRemove: (() -> ())?
    var scoresTotal: Int {
        guard let scores = board?.scores else { return 0 }
        return scores.reduce(0, combine: { total, score in total + score.value })
    }
    override var preferredFocusedView: UIView? {
        guard let theBoard = board else { return nameField }
        return theBoard.scores.count > 0 ? self.scoresView.cellForRowAtIndexPath(NSIndexPath(forRow: theBoard.scores.count - 1, inSection: 0)) : nameField
    }

    func setBoardProps(board: BoardModel, onUpdateName: String -> (), onRemove: () -> ()) {
        self.board = board
        self.onUpdateName = onUpdateName
        self.onRemove = onRemove

        nameField.text = board.name
        scoresView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
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
        onRemove!()
    }
    
    func setScoresViewDataSourceDelegate(dataSourceDelegate: protocol<UITableViewDataSource, UITableViewDelegate>, forRow row: Int) {
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

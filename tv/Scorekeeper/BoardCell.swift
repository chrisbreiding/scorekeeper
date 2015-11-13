import UIKit

class BoardCell : UICollectionViewCell, UITextFieldDelegate {
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet private weak var scoresView: UITableView!
    @IBOutlet var scoresTotalView: UITextView!

    var board: BoardModel?
    var onUpdateName: (String -> ())?
    var onAddScore: (() -> ())?
    var onRemove:( () -> ())?
    var scoresTotal: Int {
        guard let scores = board?.scores else { return 0 }
        return scores.reduce(0, combine: { total, score in total + score.value })
    }
    
    func setBoardProps(board: BoardModel, onUpdateName: String -> (), onRemove: () -> ()) {
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
        onRemove!()
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

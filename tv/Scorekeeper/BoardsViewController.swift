import Foundation
import UIKit

let localStorage = NSUserDefaults.standardUserDefaults()
let DATA_KEY = "dataKey"

class BoardsViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var boards: [BoardModel] = []
    
    override func viewDidLoad() {
        if let dataString = localStorage.stringForKey(DATA_KEY) {
            boards = deserializeData(dataString)
            self.collectionView?.reloadData()
        }
        super.viewDidLoad()
    }
    
    func deserializeData(dataString: String) -> [BoardModel] {
        if let data = dataString.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data: data)
            let boards = json["boards"].arrayValue
            return BoardModel.deserialize(boards)
        }
        return []
    }
    
    func serializeData(boards: [BoardModel]) -> String {
        let json: JSON = ["boards": BoardModel.serialize(boards)]
        if let jsonString = json.rawString() {
            return jsonString
        }
        return ""
    }
    
    func saveData() {
        let dataString = serializeData(boards)
        localStorage.setObject(dataString, forKey: DATA_KEY)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boards.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row < boards.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BoardCell", forIndexPath: indexPath) as! BoardCell
            let board = boards[indexPath.row]
            cell.setBoardProps(board, onUpdateName: handleUpdateName(indexPath.row), onRemove: handleBoardRemoval)
            return cell
        } else {
            return collectionView.dequeueReusableCellWithReuseIdentifier("AddBoardCell", forIndexPath: indexPath) as! AddBoardCell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let boardCell = cell as? BoardCell else { return }
        boardCell.setScoresViewDataSourceDelegate(self, forRow: indexPath.row)
        boardCell.setAddScoreHandler(addScoreTo(boards[indexPath.row]))
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = indexPath.row < boards.count ? 500 : 100
        return CGSize(width: width, height: 950)
    }
    
    @IBAction func onAddBoard() {
        boards.append(BoardModel(id: newBoardId(), name: ""))
        saveData()
        self.collectionView?.reloadData()
    }
    
    func handleUpdateName(index: Int) -> (String -> Void) {
        func updateName(name: String) {
            boards[index].name = name
            saveData()
        }
        return updateName
    }
    
    func addScoreTo(board: BoardModel) -> (Void -> Void) {
        func addScore() {
            board.scores.append(ScoreModel(id: newScoreId(board.scores), score: 0))
            saveData()
            self.collectionView?.reloadData()
        }
        return addScore
    }
    
    func newBoardId() -> Int {
        let maxId = boards.map({ board in board.id }).maxElement()
        return (maxId != nil) ? maxId! + 1 : 0
    }
    
    func newScoreId(scores: [ScoreModel]) -> Int {
        let maxId = scores.map({ score in score.id }).maxElement()
        return (maxId != nil) ? maxId! + 1 : 0
    }

    func handleBoardRemoval(board: BoardModel) {
        if let index = boards.indexOf({ thisBoard in thisBoard.id == board.id }) {
            boards.removeAtIndex(index)
            saveData()
            self.collectionView?.reloadData()
        }
    }
}

extension BoardsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards[tableView.tag].scores.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < boards[tableView.tag].scores.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell", forIndexPath: indexPath) as! ScoreCell
            let updateScore = handleUpdateScoreFor(tableView.tag, scoreIndex: indexPath.row)
            let removeScore = handleRemoveScoreFor(tableView.tag, scoreIndex: indexPath.row)
            cell.setScoreProps(boards[tableView.tag].scores[indexPath.row], onUpdateScore: updateScore, onRemove: removeScore)
            return cell
        } else {
            return tableView.dequeueReusableCellWithIdentifier("AddScoreCell", forIndexPath: indexPath) as! AddScoreCell
        }
    }

    func handleUpdateScoreFor(boardIndex: Int, scoreIndex: Int) -> (ScoreModel -> Void) {
        func updateScore(score: ScoreModel) {
            boards[boardIndex].scores[scoreIndex] = score
            saveData()
            self.collectionView?.reloadData()
        }
        return updateScore
    }

    func handleRemoveScoreFor(boardIndex: Int, scoreIndex: Int) -> (Void -> Void) {
        func removeScore() {
            boards[boardIndex].scores.removeAtIndex(scoreIndex)
            saveData()
            self.collectionView?.reloadData()
        }
        return removeScore
    }
}

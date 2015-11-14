import Foundation
import UIKit

let localStorage = NSUserDefaults.standardUserDefaults()
let DATA_KEY = "dataKey"

class BoardsViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var boards: [BoardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        boards = Data.load()
        reloadCollectionData()
    }

    func saveAndReload() {
        Data.save(boards)
        reloadCollectionData()
    }
    
    func reloadCollectionData() {
        self.collectionView?.reloadData()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boards.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row < boards.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BoardCell", forIndexPath: indexPath) as! BoardCell
            let board = boards[indexPath.row]
            cell.setBoardProps(board, onUpdateName: partial(updateName, with: indexPath.row), onRemove: partial(removeBoard, with: indexPath.row))
            return cell
        } else {
            return collectionView.dequeueReusableCellWithReuseIdentifier("AddBoardCell", forIndexPath: indexPath) as! AddBoardCell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let boardCell = cell as? BoardCell else { return }
        boardCell.setScoresViewDataSourceDelegate(self, forRow: indexPath.row)
        boardCell.setAddScoreHandler(partial(addScore, with: boards[indexPath.row]))
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = indexPath.row < boards.count ? 500 : 114
        return CGSize(width: width, height: 950)
    }

    @IBAction func onAddBoard() {
        boards.append(BoardModel(id: newBoardId()))
        saveAndReload()
    }
    
    func updateName(index: Int, name: String) {
        boards[index].name = name
        saveAndReload()
    }
    
    func addScore(board: BoardModel) {
        board.add(ScoreModel(id: newScoreId(board.scores)))
        saveAndReload()
    }
    
    func newBoardId() -> Int {
        let maxId = boards.map({ board in board.id }).maxElement()
        return (maxId != nil) ? maxId! + 1 : 0
    }
    
    func newScoreId(scores: [ScoreModel]) -> Int {
        let maxId = scores.map({ score in score.id }).maxElement()
        return (maxId != nil) ? maxId! + 1 : 0
    }

    func removeBoard(index: Int) {
        boards.removeAtIndex(index)
        saveAndReload()
    }
}

extension BoardsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards[tableView.tag].scores.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < boards[tableView.tag].scores.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell", forIndexPath: indexPath) as! ScoreCell
            let onUpdateScore = partial(updateScore, with: tableView.tag, and: indexPath.row)
            let onRemoveScore = partial(removeScore, with: tableView.tag, and: indexPath.row)
            cell.setScoreProps(boards[tableView.tag].scores[indexPath.row], onUpdateScore: onUpdateScore, onRemove: onRemoveScore)
            return cell
        } else {
            return tableView.dequeueReusableCellWithIdentifier("AddScoreCell", forIndexPath: indexPath) as! AddScoreCell
        }
    }

    func updateScore(boardIndex: Int, scoreIndex: Int, score: ScoreModel) {
        boards[boardIndex].scores[scoreIndex] = score
        saveAndReload()
    }

    func removeScore(boardIndex: Int, scoreIndex: Int) {
        boards[boardIndex].removeScoreAt(scoreIndex)
        saveAndReload()
    }
}

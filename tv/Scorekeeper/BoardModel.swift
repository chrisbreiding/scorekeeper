import Foundation

class BoardModel {
    var id: Int
    var name: String
    var scores: [ScoreModel]
    
    init(id: Int, name: String = "", scores: [ScoreModel] = []) {
        self.id = id
        self.name = name
        self.scores = scores
    }
    
    func add(score: ScoreModel) {
        scores.append(score)
    }
    
    func removeScoreAt(index: Int) {
        scores.removeAtIndex(index)
    }
    
    class func deserialize(boards: [JSON]) -> [BoardModel] {
        return boards.map { board in
            BoardModel(id: board["id"].intValue, name: board["name"].stringValue, scores: ScoreModel.deserialize(board["scores"].arrayValue))
        }
    }
    
    class func serialize(boards: [BoardModel]) -> [AnyObject] {
        return boards.map { board in
            ["id": board.id, "name": board.name, "scores": ScoreModel.serialize(board.scores)]
        }
    }
}

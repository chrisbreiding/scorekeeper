import Foundation

class ScoreModel : Equatable {
    var id: Int
    var value: Int
    
    init(id: Int, score: Int = 0) {
        self.id = id
        self.value = score
    }
    
    class func deserialize(scores: [JSON]) -> [ScoreModel] {
        return scores.map { score in
            ScoreModel(id: score["id"].intValue, score: score["score"].intValue)
        }
    }
    
    class func serialize(scores: [ScoreModel]) -> [AnyObject] {
        return scores.map { score in
            ["id": score.id, "score": score.value]
        }
    }
}

func ==(score1: ScoreModel, score2: ScoreModel) -> Bool {
    return score1.id == score2.id
}

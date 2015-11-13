import Foundation

class ScoreModel : Equatable {
    var id: Int
    var score: Int
    
    init(id: Int, score: Int) {
        self.id = id
        self.score = score
    }
    
    static func deserialize(scores: [JSON]) -> [ScoreModel] {
        return scores.map { score in
            ScoreModel(id: score["id"].intValue, score: score["score"].intValue)
        }
    }
    
    static func serialize(scores: [ScoreModel]) -> [AnyObject] {
        return scores.map { score in
            ["id": score.id, "score": score.score]
        }
    }
}

func ==(score1: ScoreModel, score2: ScoreModel) -> Bool {
    return score1.id == score2.id
}

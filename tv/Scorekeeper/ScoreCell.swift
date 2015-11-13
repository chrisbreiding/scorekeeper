import Foundation
import UIKit

class ScoreCell : UITableViewCell, UITextFieldDelegate {
    @IBOutlet var scoreField: UITextField!
    var score: ScoreModel?
    var onUpdateScore: (ScoreModel -> Void)?
    var onRemove: (Void -> Void)?

    func setScoreProps(score: ScoreModel, onUpdateScore: (ScoreModel -> Void), onRemove: (Void -> Void)) {
        self.score = score
        self.onUpdateScore = onUpdateScore
        self.onRemove = onRemove
        scoreField.text = score.score > 0 ? String(score.score) : ""
    }

    func textFieldDidEndEditing(textField: UITextField) {
        let scoreText = (textField.text ?? "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        score!.score = Int(scoreText) ?? 0
        onUpdateScore!(score!)
    }

    @IBAction func handleRemoval() {
        onRemove!()
    }

    override func canBecomeFocused() -> Bool {
        return false
    }
}

class AddScoreCell : UITableViewCell {
    override func canBecomeFocused() -> Bool {
        return false
    }
}

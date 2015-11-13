import Foundation
import UIKit

class ScoreCell : UITableViewCell, UITextFieldDelegate {
    @IBOutlet var scoreField: UITextField!
    var score: ScoreModel?
    var onUpdateScore: (ScoreModel -> ())?
    var onRemove: (() -> ())?

    func setScoreProps(score: ScoreModel, onUpdateScore: (ScoreModel -> ()), onRemove: (() -> ())) {
        self.score = score
        self.onUpdateScore = onUpdateScore
        self.onRemove = onRemove
        scoreField.text = score.value > 0 ? String(score.value) : ""
    }

    func textFieldDidEndEditing(textField: UITextField) {
        let scoreText = (textField.text ?? "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        score!.value = Int(scoreText) ?? 0
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

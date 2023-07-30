import { observer } from 'mobx-react'
import React, { Component, createRef } from 'react'

import { ScoreModel } from '../boards/boards-store'
import { Score } from './score'

interface ScoreListProps {
  scores: ScoreModel[]
  onAdd: () => ScoreModel
  onNextBoard: () => void
  onPreviousBoard: () => void
  onRemoveScore: (score: ScoreModel) => void
  onSave: () => void
}

class _ScoreList extends Component<ScoreListProps> {
  scoreRefs: WeakMap<ScoreModel, React.RefObject<typeof Score>> = new WeakMap()
  getRefTimerId?: number

  edit = () => {
    const lastScore = this.props.scores[this.props.scores.length - 1]

    if (lastScore && lastScore.isValid) {
      this.editScore(lastScore)
    } else {
      this.editNewScore()
    }
  }

  previousScore = (score: ScoreModel) => {
    const index = this._getScoreIndex(score)

    if (index > 0) {
      this.editScore(this.props.scores[index - 1])
    }
  }

  nextOrNewScore = (score: ScoreModel) => {
    const index = this._getScoreIndex(score)

    if (index < 0) return

    const currentScore = this.props.scores[index]
    const nextScore = this.props.scores[index + 1]

    if (nextScore) {
      this.editScore(nextScore)
    } else if (!currentScore.isValid) {
      this.editNewScore()
    }
  }

  async editScore (score: ScoreModel) {
    const ref = await this._getRefForScore(score)

    if (ref) {
      // @ts-ignore
      ref.edit()
    }
  }

  _getRefForScore (score: ScoreModel): Promise<typeof Score | void> {
    clearTimeout(this.getRefTimerId)

    let attempts = 10

    return new Promise((resolve) => {
      const getRef = () => {
        attempts--

        if (attempts === 0) {
          return resolve()
        }

        const ref = this.scoreRefs.get(score)?.current

        if (ref) {
          resolve(ref)
        } else {
          this.getRefTimerId = setTimeout(getRef, 50)
        }
      }

      getRef()
    })
  }

  editNewScore () {
    const newScore = this.props.onAdd()

    this.editScore(newScore)
  }

  _getScoreIndex (score: ScoreModel) {
    return this.props.scores.findIndex((_score) => {
      return _score.id === score.id
    })
  }

  _createRef (score: ScoreModel) {
    const ref = createRef<typeof Score & null>()

    this.scoreRefs.set(score, ref)

    return ref
  }

  render () {
    return (
      <div className='scores' onClick={this.edit}>
        {this.props.scores.map((score) => (
          <Score
            key={score.id}
            score={score}
            ref={this._createRef(score)}
            onPrevious={this.previousScore}
            onNext={this.nextOrNewScore}
            onPreviousBoard={this.props.onPreviousBoard}
            onNextBoard={this.props.onNextBoard}
            onSave={this.props.onSave}
            onRemove={this.props.onRemoveScore}
          />
        ))}
      </div>
    )
  }
}

export const ScoreList = observer(_ScoreList)

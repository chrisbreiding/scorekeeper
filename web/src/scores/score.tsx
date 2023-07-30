import { observer } from 'mobx-react'
import React, { Component, createRef } from 'react'

import { ScoreModel } from '../boards/boards-store'
import { makeObservable, observable } from 'mobx'

interface ScoreProps {
  onNext: (score: ScoreModel) => void
  onNextBoard: () => void
  onPrevious: (score: ScoreModel) => void
  onPreviousBoard: () => void
  onRemove: (score: ScoreModel) => void
  onSave: () => void
  score: ScoreModel
}

class _Score extends Component<ScoreProps> {
  inputRef: React.RefObject<HTMLInputElement>
  editing = false

  constructor (props: ScoreProps) {
    super(props)

    this.inputRef = createRef<HTMLInputElement>()

    makeObservable(this, {
      editing: observable,
    })
  }

  stopPropagation = (e: React.MouseEvent) => {
    e.stopPropagation()
  }

  update = (e: React.ChangeEvent<HTMLInputElement>) => {
    this.props.score.update(e.target.value)

    this.props.onSave()
  }

  remove = (e: React.MouseEvent) => {
    e.stopPropagation()

    this.props.onRemove(this.props.score)
  }

  edit = (e?: React.FocusEvent) => {
    e && e.stopPropagation()

    this.editing = true
    this.inputRef?.current?.focus()
  }

  stopEditing = () => {
    this.editing = false
  }

  keyDown = (e: React.KeyboardEvent) => {
    if (e.key !== 'Tab') return

    e.preventDefault()

    if (e.shiftKey) {
      this.props.onPreviousBoard()
    } else {
      this.props.onNextBoard()
    }
  }

  keyUp = (e: React.KeyboardEvent) => {
    switch (e.key) {
      case 'ArrowUp':
        return this.previousScore()
      case 'Enter':
      case 'ArrowDown':
        return this.nextScore()
      default:
    }
  }

  previousScore = () => {
    this.props.onPrevious(this.props.score)
  }

  nextScore = () => {
    this.props.onNext(this.props.score)
  }

  render () {
    return (
      <div className={`score${this.editing ? ' editing' : ''}`} onClick={this.stopPropagation}>
        <input
          ref={this.inputRef}
          value={this.props.score.rawValue}
          onChange={this.update}
          onKeyDown={this.keyDown}
          onKeyUp={this.keyUp}
          onFocus={this.edit}
          onBlur={this.stopEditing}
        />
        <button onClick={this.remove}>×</button>
      </div>
    )
  }
}

export const Score = observer(_Score)

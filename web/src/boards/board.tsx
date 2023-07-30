import React, { Component, createRef } from 'react'

import { BoardModel, BoardUpdate } from './boards-store'
import { ScoreList } from '../scores/score-list'
import { observer } from 'mobx-react'

interface BoardProps {
  board: BoardModel
  onNextBoard: (board: BoardModel) => void
  onPreviousBoard: (board: BoardModel) => void
  onUpdate: (props: BoardUpdate) => void
  onRemove: (board: BoardModel) => void
  onSave: () => void
  rank: number
}

class _Board extends Component<BoardProps> {
  nameRef: React.RefObject<HTMLInputElement>
  scoreListRef: React.RefObject<typeof ScoreList>

  constructor (props: BoardProps) {
    super(props)

    this.nameRef = createRef()
    this.scoreListRef = createRef()
  }

  updateName = (e: React.ChangeEvent<HTMLInputElement>) => {
    this.props.onUpdate({ id: this.props.board.id, name: e.target.value })
  }

  remove = () => {
    this.props.onRemove(this.props.board)
  }

  clearScores = () => {
    this.props.onUpdate({ id: this.props.board.id, scores: [] })
  }

  addScore = () => {
    return this.props.board.addScore()
  }

  previousBoard = () => {
    this.props.onPreviousBoard(this.props.board)
  }

  nextBoard = () => {
    this.props.onNextBoard(this.props.board)
  }

  edit () {
    // @ts-ignore
    this.scoreListRef?.current?.edit()
  }

  componentDidMount () {
    if (!this.props.board.name.trim()) {
      return this.nameRef?.current?.focus()
    }
  }

  render () {
    return (
      <div className='board'>
        <input
          ref={this.nameRef}
          className='board-name'
          placeholder='name...'
          defaultValue={this.props.board.name}
          onChange={this.updateName}
        />
        <div className='rank'>
          <span>{this.props.rank}</span>
        </div>
        <button
          className='close'
          onClick={this.remove}
        >
          <span>×</span>
        </button>
        <ScoreList
          // @ts-ignore
          ref={this.scoreListRef}
          scores={this.props.board.scores}
          onAdd={this.addScore}
          onRemoveScore={this.props.board.removeScore}
          onSave={this.props.onSave}
          onPreviousBoard={this.previousBoard}
          onNextBoard={this.nextBoard}
        />
        <div className='total'>
          <span>{this.props.board.totalScore}</span>
          <button onClick={this.clearScores}>
            <span>⊝</span>
          </button>
        </div>
      </div>
    )
  }
}

export const Board = observer(_Board)

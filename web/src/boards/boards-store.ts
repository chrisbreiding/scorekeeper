import debounce from 'lodash.debounce'
import { makeAutoObservable } from 'mobx'
import { save } from '../shared/store'

const newId = (array: { id: number }[]) => {
  const ids = array.map((item) => item.id)

  if (!ids.length) { return 0 }

  return Math.max(...(ids || [])) + 1
}

export interface ScoreProps {
  id: number
  rawValue: number | '-' | ''
}

export class ScoreModel {
  id: number
  rawValue: number | '-' | ''

  constructor (props: ScoreProps) {
    this.id = props.id
    this.rawValue = props.rawValue

    makeAutoObservable(this)
  }

  get value () {
    return typeof this.rawValue === 'number' ? this.rawValue : 0
  }

  get isValid () {
    return typeof this.rawValue === 'number'
  }

  update (newValue: any) {
    if (newValue === '-') {
      this.rawValue = newValue
    } else if (newValue) {
      const number = parseInt(newValue, 10)

      if (isNaN(number)) return

      this.rawValue = number
    } else {
      this.rawValue = ''
    }
  }
}

export interface BoardProps {
  id: number
  name: string
  scores: ScoreModel[]
}

export type BoardUpdate = Partial<BoardProps> & { id: number }

interface BoardCallbacks {
  onSave: () => void
}

export class BoardModel {
  id: number
  name: string
  scores: ScoreModel[]
  save: () => void

  constructor (props: BoardProps & BoardCallbacks) {
    this.id = props.id
    this.name = props.name
    this.scores = props.scores
    this.save = props.onSave

    makeAutoObservable(this)
  }

  get totalScore () {
    return this.scores.reduce((total, score) => {
      return total + score.value
    }, 0)
  }

  get hasValidScores () {
    return this.scores.length && this.scores.some((score) => score.isValid)
  }

  update = (props: BoardUpdate) => {
    Object.assign(this, props)
  }

  addScore = () => {
    const newScore = new ScoreModel({
      id: newId(this.scores),
      rawValue: '',
    })

    this.scores.push(newScore)
    this.save()

    return newScore
  }

  removeScore = (score: ScoreModel) => {
    const index = this.scores.findIndex((_score) => _score.id === score.id)

    if (index < 0) return

    this.scores = [
      ...this.scores.slice(0, index),
      ...this.scores.slice(index + 1),
    ]

    this.save()
  }
}

class BoardsStore {
  boards: BoardModel[] = []

  constructor () {
    makeAutoObservable(this)
  }

  get rankings () {
    return this.boards
    .map((board) => board.totalScore)
    .sort((a, b) => b - a)
  }

  rankingForBoard (board: BoardModel) {
    return this.rankings.findIndex((ranking) => ranking === board.totalScore) + 1
  }

  save = debounce(() => {
    save('boards', this.boards)
  }, 300)

  setBoards = (boards: BoardProps[]) => {
    this.boards = boards.map((props) => new BoardModel({
      ...props,
      scores: props.scores.map((scoreProps) => new ScoreModel(scoreProps)),
      onSave: this.save,
    }))
  }

  addBoard = () => {
    this.boards.push(new BoardModel({
      id: newId(this.boards),
      name: '',
      scores: [] as ScoreModel[],
      onSave: this.save,
    }))

    this.save()
  }

  updateBoard = (props: BoardUpdate) => {
    const index = this.boards.findIndex((board) => board.id === props.id)

    if (index < 0) return

    this.boards[index].update(props)

    this.save()
  }

  removeBoard = (board: BoardModel) => {
    const index = this.boards.findIndex((_board) => _board.id === board.id)

    if (index < 0) return

    this.boards = [
      ...this.boards.slice(0, index),
      ...this.boards.slice(index + 1),
    ]

    this.save()
  }
}

export const boardsStore = new BoardsStore()

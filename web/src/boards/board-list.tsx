import { observer } from 'mobx-react'
import React, { useEffect, useRef } from 'react'

import { Board } from './board'
import { BoardModel, BoardUpdate, boardsStore } from './boards-store'

interface BoardListProps {
  boards: BoardModel[]
  onAddBoard: () => void
  onUpdateBoard: (props: BoardUpdate) => void
  onRemoveBoard: (board: BoardModel) => void
  onSave: () => void
}

export const BoardList = observer(({ boards, onAddBoard, onUpdateBoard, onRemoveBoard, onSave }: BoardListProps) => {
  const ref = useRef([] as (typeof Board)[])

  useEffect(() => {
    ref.current = ref.current.slice(0, boards.length)
  }, [boards])

  const previousBoard = (board: BoardModel) => {
    return moveToBoard(board, (index) => {
      return index - 1 < 0 ? boards.length - 1 : index - 1
    })
  }

  const nextBoard = (board: BoardModel) => {
    return moveToBoard(board, (index) => {
      return index + 1 > (boards.length - 1) ? 0 : index + 1
    })
  }

  const moveToBoard = (board: BoardModel, moveToIndex: (index: number) => number) => {
    const index = boards.findIndex((_board) => _board.id === board.id)

    if (index > -1) {
      edit(boards[moveToIndex(index)])
    }
  }

  const edit = (board: BoardModel) => {
    const index = boards.findIndex((_board) => _board.id === board.id)

    // @ts-ignore
    return ref.current[index].edit()
  }

  return (
    <div className='board-list'>
      <div className='boards'>
        {boards.map((board, index) => (
          <Board
            key={board.id}
            // @ts-ignore
            ref={(board) => ref.current[index] = board}
            board={board}
            onNextBoard={nextBoard}
            onPreviousBoard={previousBoard}
            onRemove={onRemoveBoard}
            onSave={onSave}
            onUpdate={onUpdateBoard}
            rank={boardsStore.rankingForBoard(board)}
          />
        ))}
      </div>
      <button className='plus' onClick={onAddBoard}>+</button>
    </div>
  )
})

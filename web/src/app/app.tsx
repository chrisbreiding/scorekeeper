import React, { useEffect } from 'react'
import { fetch } from '../shared/store'

import { BoardList } from '../boards/board-list'
import { boardsStore } from '../boards/boards-store'
import { observer } from 'mobx-react'

export const App = observer(() => {
  useEffect(() => {
    const boards = fetch('boards')

    if (boards) {
      boardsStore.setBoards(boards)
    }
  }, [true])

  return (
    <BoardList
      boards={boardsStore.boards}
      onAddBoard={boardsStore.addBoard}
      onRemoveBoard={boardsStore.removeBoard}
      onUpdateBoard={boardsStore.updateBoard}
      onSave={boardsStore.save}
    />
  )
})

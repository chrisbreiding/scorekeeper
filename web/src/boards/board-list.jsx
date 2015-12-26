import React, { createClass } from 'react';
import ListMixin from '../shared/list-mixin';
import Board from './board';

export default createClass({
  mixins: [ListMixin],

  componentWillMount () {
    this.listName = 'boards';
  },

  render () {
    return (
      <div className="board-list">
        <div className="boards">
          {
            this.props.boards.map((board) => (
              <Board
                key={board.id}
                ref={`board${board.id}`}
                name={board.name}
                scores={board.scores}
                onUpdate={this.update}
                onRemove={this.remove}
                onPreviousBoard={this.previousBoard}
                onNextBoard={this.nextBoard}
              />
            ))
          }
        </div>
        <button className="plus" onClick={this.newBoard}>+</button>
      </div>
    );
  },

  newBoard () {
    this.props.boards.push({
      id: this.newId(),
      name: '',
      scores: []
    });
    this.save();
  },

  previousBoard (board) {
    this.moveToBoard(board, (index) => {
      return index - 1 < 0 ? this.props.boards.length - 1 : index - 1;
    });
  },

  nextBoard (board) {
    this.moveToBoard(board, (index) => {
      return index + 1 > this.props.boards.length - 1 ? 0 : index + 1;
    });
  },

  moveToBoard (board, moveToIndex) {
    const index = this.indexOf(board);
    if (index > -1) {
      this.edit(this.props.boards[moveToIndex(index)]) ;
    }
  },

  edit (board) {
    this.refs[`board${board.id}`].edit();
  },
});

import React, { Component } from 'react';
import ScoreList from '../scores/score-list';

export default class Board extends Component {
  render () {
    const total = this.props.scores.reduce((total, score) => {
      return total + (isNaN(+score.score) ? 0 : +score.score);
    }, 0);

    return (
      <div className="board">
        <input
          ref="name"
          className="name"
          placeholder="name..."
          tabIndex="1"
          defaultValue={this.props.name}
          onKeyUp={this.updateName}
        />
        <button className="close" onClick={this.remove}>
          <span>×</span>
        </button>
        <ScoreList
          ref="scoreList"
          scores={this.props.scores}
          onUpdate={this.updateScores}
          onPreviousBoard={this.previousBoard}
          onNextBoard={this.nextBoard}
        />
        <div className="total">
          <span>{total}</span>
          <button onClick={this.clearScores}>
            <span>⊝</span>
          </button>
        </div>
      </div>
    );
  }

  componentDidMount () {
    if (!this.props.name.trim()) {
      this.refs.name.getDOMNode().focus();
    }
  }

  updateName (e) {
    this.props.name = e.target.value;
    this.save();
  }

  updateScores (scores) {
    this.props.scores = scores;
    this.save();
  }

  clearScores () {
    this.props.scores = [];
    this.save();
  }

  remove () {
    this.props.onRemove({ id: this.props.key });
  }

  previousBoard () {
    this.props.onPreviousBoard({ id: this.props.key });
  }

  nextBoard () {
    this.props.onNextBoard({ id: this.props.key });
  }

  edit () {
    this.refs.scoreList.edit();
  }

  save () {
    this.props.onUpdate({
      id: this.props.key,
      name: this.props.name,
      scores: this.props.scores
    });
  }
}

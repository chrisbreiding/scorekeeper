import _ from 'lodash';
import React, { Component } from 'react';
import store from '../shared/store';
import BoardList from '../boards/board-list';

const LS_KEY = 'scorekeeper';

export default class App extends Component {
  constructor () {
    this._save = _.debounce(300, this._save);
  }

  getInitialState () {
    return { boards: [] };
  }

  render () {
    return (
      <BoardList
        boards={this.state.boards}
        onUpdate={this._update}
      />
    );
  }
  componentDidMount () {
    store.fetch(LS_KEY).then((data) => {
      this.setState({boards: data.boards || [] });
    });
  }

  _update (boards) {
    this._save(boards);
    return new Promise((resolve) => {
      this.setState({ boards: boards }, resolve);
    });
  }

  _save (boards) {
    store.save(LS_KEY, { boards: boards });
  }
}

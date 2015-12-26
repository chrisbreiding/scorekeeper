import React from 'react';
import { render } from 'react-dom';
import attachFastClick from 'fastclick';
import App from './app/app';

attachFastClick(document.body);

render(<App />, document.getElementById('app'));

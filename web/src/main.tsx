import attachFastClick from 'fastclick'
import React from 'react'
import { createRoot } from 'react-dom/client'

import { App } from './app/app'

attachFastClick(document.body)

createRoot(document.getElementById('app')!).render(<App />)

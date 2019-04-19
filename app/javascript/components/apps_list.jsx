import React, { PureComponent } from 'react'
import App from './app'

export default class AppsList extends PureComponent {
  render() {
    const { apps, deleteApp, os } = this.props

    if (apps.length === 0) {
      return (
        <div className="alert alert-light text-center">No one apps here</div>
      )
    }

    return (
      <div className="mt-4">
        {apps.map(el => (
          <App key={el.id} app={el} deleteApp={deleteApp} os={os} />
        ))}
      </div>
    )
  }
}

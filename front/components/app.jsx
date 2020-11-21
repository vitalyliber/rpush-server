import React, { Fragment, PureComponent } from 'react'
import moment from 'moment'

export default class App extends PureComponent {
  state = {
    showDangerousActions: false,
  }

  toggleDangerousActions = event => {
    event.preventDefault()

    this.setState(prevState => ({
      showDangerousActions: !prevState.showDangerousActions,
    }))
  }

  render() {
    const {
      app: { name, id, updated_at, environment },
      deleteApp,
      os,
    } = this.props
    const { showDangerousActions } = this.state

    return (
      <div key={id} className="card mt-4">
        <div className="card-body">
          <h5 className="card-title">
            {name}
            {os === 'ios' ? (
              <Fragment>
                <span className="badge badge-primary ml-2">iOS</span>
                {environment === 'development' ? (
                  <span className="badge badge-pill badge-secondary ml-2">
                    {environment}
                  </span>
                ) : (
                  <span className="badge badge-pill badge-warning ml-2">
                    {environment}
                  </span>
                )}
              </Fragment>
            ) : (
              <span className="badge badge-success ml-2">Android</span>
            )}
          </h5>
          <h6 className="card-subtitle mb-2 text-muted">
            {moment(updated_at).format('LLL')}
          </h6>
          {showDangerousActions ? (
            <Fragment>
              <div className="alert alert-danger" role="alert">
                Do you really want to remove this app?
              </div>
              <a
                onClick={this.toggleDangerousActions}
                href="#"
                className="btn btn-light"
              >
                Decline
              </a>
              <a
                onClick={event => deleteApp(event, id)}
                href="#"
                className="btn btn-primary ml-2"
              >
                Remove
              </a>
            </Fragment>
          ) : (
            <a
              onClick={this.toggleDangerousActions}
              href="#"
              className="btn btn-danger"
            >
              Remove
            </a>
          )}
        </div>
      </div>
    )
  }
}

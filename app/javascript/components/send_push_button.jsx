import React, { Component, Fragment } from 'react'
import axios from 'axios'

export default class SendPushButton extends Component {
  state = {
    isSending: false,
    error: null,
    successful: null,
    external_key: '',
  }

  sendPushesToAllEnvs = async event => {
    event.preventDefault()
    const { external_key } = this.state
    if (!external_key) {
      return this.setState({ error: 'Put external key' })
    }
    await this.sendPushFetch('development')
    await this.sendPushFetch('production')
  }

  sendPushFetch = environment => {
    const { getHeaders } = this.props
    const { external_key } = this.state
    this.setState({ isSending: true, error: null })

    return axios({
      method: 'post',
      url: '/push_notifications',
      data: {
        message: {
          title: 'Test Push',
          message: 'Test push notification was successfully received',
        },
        mobile_user: {
          external_key: external_key,
          environment: environment,
        },
      },
      credentials: 'same-origin',
      headers: getHeaders(),
    })
      .then(({ data, status }) => {
        console.log(data, status)
        this.setState({
          isSending: false,
          successful: 'The push was successfully sent',
        })
      })
      .catch(error => {
        if (error.response) {
          console.log(error.response)
          this.setState({
            isSending: false,
            error: 'Something went wrong. See console input',
          })
          return
        } else if (error.request) {
          console.log(error.request)
        } else {
          console.log('Error', error.message)
        }
        this.setState({ isSending: false, error: 'Network error' })
        console.log(error.config)
      })
  }

  render() {
    const { access_token } = this.props
    const { isLoading, error, external_key, successful } = this.state

    return (
      <Fragment>
        <h4 className="mb-3">Test push</h4>
        {access_token && (
          <Fragment>
            <form className="form-inline">
              <div className="form-group mr-1">
                <input
                  value={external_key}
                  onChange={e => {
                    this.setState({
                      external_key: e.target.value,
                    })
                  }}
                  type="text"
                  className="form-control form-control-sm"
                  id="externalKey"
                  placeholder="External Key"
                />
              </div>
              <button
                onClick={this.sendPushesToAllEnvs}
                type="button"
                className="btn btn-outline-info btn-sm"
              >
                Send the test push
              </button>
            </form>
          </Fragment>
        )}
        {isLoading && <p className="text-secondary mt-2">Loading...</p>}
        {error && <p className="text-danger mt-2">{error}</p>}
        {successful && <p className="text-success mt-2">{successful}</p>}
      </Fragment>
    )
  }
}

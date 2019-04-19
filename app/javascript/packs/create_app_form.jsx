// Run this example by adding <%= javascript_pack_tag 'create_app_form' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React, { Fragment, PureComponent } from 'react'
import axios from 'axios'
import ReactDOM from 'react-dom'

import { Formik, Form, Field, ErrorMessage } from 'formik'
import AppsList from '../components/apps_list'
import csrf_token from '../utils/csrf_token'
import SendPushButton from '../components/send_push_button'

class CreateAppForm extends PureComponent {
  state = {
    os: 'android',
    apps: [],
    access_token: localStorage.getItem('access_token'),
  }

  getHeaders = () => {
    const { access_token } = this.state
    return {
      'X-CSRF-Token': csrf_token,
      Authorization: `Bearer ${access_token}`,
    }
  }

  componentDidMount() {
    this.getApps()
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevState.os !== this.state.os) {
      this.getApps()
    }
  }

  deleteApp = (event, id) => {
    event.preventDefault()
    const { os } = this.state

    axios({
      method: 'delete',
      url: `/apps/${id}`,
      params: { os },
      credentials: 'same-origin',
      headers: this.getHeaders(),
    })
      .then(({ data, status }) => {
        console.log(data, status)
        this.getApps()
      })
      .catch(error => {
        if (error.response) {
          console.log(error.response)
          return
        } else if (error.request) {
          console.log(error.request)
        } else {
          console.log('Error', error.message)
        }
        console.log(error.config)
      })
  }

  getApps = () => {
    const { os } = this.state
    this.setState({ apps: [] })

    axios({
      method: 'get',
      url: '/apps',
      params: { os },
      credentials: 'same-origin',
      headers: this.getHeaders(),
    })
      .then(({ data, status }) => {
        console.log(data, status)
        this.setState({ apps: data.apps })
      })
      .catch(error => {
        if (error.response) {
          console.log(error.response)
          return
        } else if (error.request) {
          console.log(error.request)
        } else {
          console.log('Error', error.message)
        }
        console.log(error.config)
      })
  }

  render() {
    const { os, access_token } = this.state

    return (
      <div>
        <div className="form-group row mt-4">
          <div className="col-sm-8">
            <p className="text-primary">PUSHER.</p>
          </div>
          <div className="col-sm-4">
            <input
              value={access_token}
              onChange={e => {
                this.setState({ access_token: e.target.value })
                localStorage.setItem('access_token', e.target.value)
              }}
              type="password"
              className="form-control"
              id="accessToken"
              placeholder="Server Token"
            />
          </div>
        </div>

        <SendPushButton
          access_token={access_token}
          getHeaders={this.getHeaders}
        />
        <br />
        <br />
        <h4 className="mb-3">APNS/Firebase credentials</h4>
        <ul className="nav nav-tabs">
          <li className="nav-item">
            <a
              onClick={event => {
                event.preventDefault()
                this.setState({ os: 'android' })
              }}
              className={`nav-link ${os === 'android' ? 'active' : null}`}
              href="#"
            >
              Android
            </a>
          </li>
          <li className="nav-item">
            <a
              onClick={event => {
                event.preventDefault()
                this.setState({ os: 'ios' })
              }}
              className={`nav-link ${os === 'ios' ? 'active' : null}`}
              href="#"
            >
              iOS
            </a>
          </li>
        </ul>

        <br />

        <Formik
          initialValues={{
            certificate: '',
            environment: '',
            password: '',
            auth_key: '',
          }}
          validate={values => {
            let errors = {}
            if (os === 'ios') {
              if (!values.certificate) {
                errors.certificate = 'Required'
              }
              if (!values.environment) {
                errors.environment = 'Required'
              }
              if (!values.environment) {
                errors.environment = 'Required'
              }
            }
            if (os === 'android') {
              if (!values.auth_key) {
                errors.auth_key = 'Required'
              }
            }
            return errors
          }}
          onSubmit={(values, { setSubmitting, resetForm, setErrors }) => {
            axios({
              method: 'post',
              url: '/apps',
              data: {
                app: {
                  ...values,
                  os,
                },
              },
              credentials: 'same-origin',
              headers: this.getHeaders(),
            })
              .then(({ data, status }) => {
                console.log(data, status)
                setSubmitting(false)
                resetForm()
                this.getApps()
              })
              .catch(error => {
                if (error.response) {
                  console.log(error.response)
                  setErrors(error.response.data.errors)
                  setSubmitting(false)
                  if (error.response.data.errors.name) {
                    alert(`Credentials ${error.response.data.errors.name}`)
                  }
                  return
                } else if (error.request) {
                  console.log(error.request)
                } else {
                  console.log('Error', error.message)
                }
                console.log(error.config)
                setSubmitting(false)
              })
          }}
        >
          {({ isSubmitting }) => (
            <Form>
              {os === 'ios' && (
                <Fragment>
                  <div className="form-group">
                    <Field
                      className="form-control"
                      type="text"
                      name="certificate"
                      placeholder="Certificate"
                      component="textarea"
                      rows="6"
                    />
                    <small id="emailHelp" className="form-text text-muted">
                      Certificate with extension
                      <a
                        target="_blank"
                        href="https://github.com/rpush/rpush/wiki/Generating-Certificates"
                        className="text-info ml-1"
                      >
                        .pem
                      </a>
                    </small>
                    <ErrorMessage
                      className="text-danger"
                      name="certificate"
                      component="div"
                    />
                  </div>
                  <div className="form-group">
                    <Field
                      className="form-control"
                      type="text"
                      name="environment"
                      placeholder="Environment"
                      component="select"
                    >
                      <option value="" />
                      <option value="development">Development</option>
                      <option value="production">Production</option>
                    </Field>
                    <ErrorMessage
                      className="text-danger"
                      name="environment"
                      component="div"
                    />
                  </div>
                  <div className="form-group">
                    <Field
                      className="form-control"
                      type="text"
                      name="password"
                      placeholder="Password"
                    />
                    <ErrorMessage
                      className="text-danger"
                      name="password"
                      component="div"
                    />
                  </div>
                </Fragment>
              )}
              {os === 'android' && (
                <div className="form-group">
                  <Field
                    className="form-control"
                    type="text"
                    name="auth_key"
                    placeholder="Auth key"
                  />
                  <small id="emailHelp" className="form-text text-muted">
                    Firebase server
                    <a
                      target="_blank"
                      href="https://firebase.google.com"
                      className="text-info ml-1"
                    >
                      key
                    </a>
                  </small>
                  <ErrorMessage
                    className="text-danger"
                    name="auth_key"
                    component="div"
                  />
                </div>
              )}
              <button
                className="btn btn-primary"
                type="submit"
                disabled={isSubmitting}
              >
                Submit
              </button>
            </Form>
          )}
        </Formik>
        <AppsList
          os={os}
          getApps={this.getApps}
          deleteApp={this.deleteApp}
          apps={this.state.apps}
        />
      </div>
    )
  }
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <CreateAppForm name="React" />,
    document.getElementById('create_app_form')
  )
})

import Head from 'next/head'

import React, { Fragment, PureComponent } from 'react'
import axios from 'axios'

import { Formik, Form, Field, ErrorMessage } from 'formik'
import { Collapse, Button } from 'reactstrap'
import AppsList from '../components/apps_list'
import CustomPushForm from '../components/CustomPushForm'

class CreateAppForm extends PureComponent {
  state = {
    os: 'android',
    apps: [],
    access_token: process.browser ? localStorage.getItem('access_token') : '',
    isOpen: false,
  }

  toggle = () => this.setState(({ isOpen }) => ({ isOpen: !isOpen }))

  getHeaders = () => {
    const { access_token } = this.state
    return {
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
      .catch((error) => {
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
      .catch((error) => {
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
    const { os, access_token, isOpen } = this.state

    return (
      <div className="container">
        <Head>
          <title>RPush Server</title>
          <link rel="icon" href="/favicon.ico" />
        </Head>
        <div className="form-group row mt-4">
          <div className="col-sm-8">
            <p className="text-primary">RPush-server.</p>
          </div>
          <div className="col-sm-4">
            <input
              value={access_token}
              onChange={(e) => {
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
        {!!access_token && <CustomPushForm getHeaders={this.getHeaders} />}
        {!!access_token && (
          <>
            <Button
              outline
              block
              className="mb-3"
              color="primary"
              onClick={this.toggle}
            >
              Show settings
            </Button>
            <br />
            <Collapse isOpen={isOpen}>
              <h4 className="mb-3">APNS/Firebase credentials</h4>
              <ul className="nav nav-tabs">
                <li className="nav-item">
                  <a
                    onClick={(event) => {
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
                    onClick={(event) => {
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
                validate={(values) => {
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
                    .catch((error) => {
                      if (error.response) {
                        console.log(error.response)
                        setErrors(error.response.data.errors)
                        setSubmitting(false)
                        if (error.response.data.errors.name) {
                          alert(
                            `Credentials ${error.response.data.errors.name}`
                          )
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
                          <small
                            id="emailHelp"
                            className="form-text text-muted"
                          >
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
            </Collapse>
          </>
        )}
      </div>
    )
  }
}

export default CreateAppForm
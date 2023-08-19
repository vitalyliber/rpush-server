import React, { useContext } from 'react'
import CredentialsForm from '../components/CredentialsForm'
import CredentialsList from '../components/CredentialsList'
import { Context } from '../components/ContextProvider'
import Header from '../components/Header'
import useCredentials from '../hooks/useCredentials'

export default function Credentials() {
  const { os, setOs } = useContext(Context)
  const { data } = useCredentials({ os })

  return (
    <div className="container">
      <Header />
      <h4 className="mb-3">Cloud messaging credentials</h4>
      <ul className="nav nav-tabs">
        <li className="nav-item">
          <a
            onClick={(event) => {
              event.preventDefault()
              setOs('android')
            }}
            className={`nav-link ${os === 'android' ? 'active' : null}`}
            href="#"
          >
            Firebase
          </a>
        </li>
        <li className="nav-item">
          <a
            onClick={(event) => {
              event.preventDefault()
              setOs('ios')
            }}
            className={`nav-link ${os === 'ios' ? 'active' : null}`}
            href="#"
          >
            Apnsp8
          </a>
        </li>
      </ul>
      <br />
      {data?.apps?.length === 0 && <CredentialsForm />}
      <CredentialsList />
    </div>
  )
}

import React, { useContext } from 'react'
import Link from 'next/link'
import CredentialsForm from '../components/CredentialsForm'
import CredentialsList from '../components/CredentialsList'
import { Context } from '../components/ContextProvider'
import Header from "../components/Header";

export default function Credentials() {
  const { os, setOs } = useContext(Context)

  return (
    <div className="container">
      <Header />
      <h4 className="mb-3">APNS/Firebase credentials</h4>
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
            Android
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
            iOS
          </a>
        </li>
      </ul>
      <br />
      <CredentialsForm />
      <CredentialsList />
    </div>
  )
}

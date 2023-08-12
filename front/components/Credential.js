import React, { Fragment, useState, useContext } from 'react'
import moment from 'moment'
import useCredentials from '../hooks/useCredentials'
import { deleteCredential } from '../api/credentials'
import { Context } from './ContextProvider'

const Credential = ({ app: { name, id, updated_at, environment } }) => {
  const { os } = useContext(Context)
  const { mutate } = useCredentials({ os })
  const [showDangerousActions, setShowDangerousActions] = useState()

  const toggleDangerousActions = (event) => {
    event.preventDefault()

    setShowDangerousActions((prevState) => !prevState)
  }

  return (
    <div key={id} className="card mt-4">
      <div className="card-body">
        <h5 className="card-title">
          {os === 'ios' ? 'Apnsp8 credentials' : 'Firebase credentials'}
          {os === 'ios' && (
            <Fragment>
              <span className="invisible" data-env={environment}>
                {environment}
              </span>
            </Fragment>
          )}
        </h5>
        <h6 className="card-subtitle mt-2 mb-4 text-muted">
          {moment(updated_at).format('LLL')}
        </h6>
        {showDangerousActions ? (
          <Fragment>
            <div className="alert alert-danger" role="alert">
              Do you really want to remove this app?
            </div>
            <a
              onClick={toggleDangerousActions}
              href="#"
              className="btn btn-light"
            >
              Decline
            </a>
            <a
              onClick={async (event) => {
                event.preventDefault()
                try {
                  await deleteCredential({ id, os })
                } catch (e) {
                  alert(e.message)
                } finally {
                  mutate()
                }
              }}
              href="#"
              className="btn btn-primary ml-2"
            >
              Remove
            </a>
          </Fragment>
        ) : (
          <a
            onClick={toggleDangerousActions}
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

export default Credential

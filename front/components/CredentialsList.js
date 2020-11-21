import React, { useContext } from 'react'
import Credential from './Credential'
import useCredentials from '../hooks/useCredentials'
import { Context } from './ContextProvider'

const CredentialsList = () => {
  const { os } = useContext(Context)
  const { data } = useCredentials({ os })

  if (!data) {
    return <div className="alert alert-light text-center">Loading...</div>
  }

  if (data.length === 0) {
    return <div className="alert alert-light text-center">No one apps here</div>
  }

  return (
    <div className="mt-4">
      {data.map((el) => (
        <Credential
          key={el.id}
          app={el}
        />
      ))}
    </div>
  )
}

export default CredentialsList

import React, { useContext } from 'react'
import useSWR from 'swr'
import { getCredentials } from '../api/credentials'
import { Context } from '../components/ContextProvider'

const useCredentials = () => {
  const { os, access_token } = useContext(Context)
  return useSWR(
    access_token?.length > 0 ? `apps_${os}${access_token}` : null,
    () => getCredentials({ os, access_token })
  )
}

export default useCredentials

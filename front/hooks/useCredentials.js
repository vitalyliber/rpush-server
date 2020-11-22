import React, { useContext } from 'react'
import useSWR from 'swr'
import { getApps } from '../api/apps'
import { Context } from '../components/ContextProvider'

const useCredentials = () => {
  const { os, access_token } = useContext(Context)
  return useSWR(
    access_token?.length > 0 ? `apps_${os}${access_token}` : null,
    () => getApps({ os, access_token })
  )
}

export default useCredentials

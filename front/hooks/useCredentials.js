import React, { useContext } from 'react'
import useSWR from 'swr'
import { getApps } from '../api/apps'
import { Context } from '../components/ContextProvider'

const useCredentials = () => {
  const { os } = useContext(Context)
  const access_token = process.browser
    ? localStorage.getItem('access_token')
    : ''
  return useSWR(`apps_${os}${access_token}`, () => getApps({ os }))
}

export default useCredentials

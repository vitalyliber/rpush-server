import { createContext, useState, useEffect } from 'react'

export const Context = createContext({})

function ContextProvider({ children }) {
  const [os, setOs] = useState('android')
  const [access_token, setAccessToken] = useState('')
  useEffect(() => {
    if (process.browser) {
      const token = localStorage.getItem('access_token')
      if (token?.length > 0) {
        setAccessToken(localStorage.getItem('access_token'))
      }
    }
  }, [])
  useEffect(() => {
    if (process.browser) {
      localStorage.setItem('access_token', access_token)
    }
  }, [access_token])
  return (
    <Context.Provider value={{ os, access_token, setAccessToken, setOs }}>
      {children}
    </Context.Provider>
  )
}

export default ContextProvider

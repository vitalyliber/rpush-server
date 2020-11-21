import { useContext } from 'react'
import Head from 'next/head'
import { Context } from './ContextProvider'

export default function () {
  const { access_token, setAccessToken } = useContext(Context)
  return (
    <>
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
              setAccessToken(e.target.value)
              localStorage.setItem('access_token', e.target.value)
            }}
            type="password"
            className="form-control"
            id="accessToken"
            placeholder="Server Token"
          />
        </div>
      </div>
    </>
  )
}

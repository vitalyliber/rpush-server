import { useContext } from 'react'
import Head from 'next/head'
import Link from 'next/link'
import { Context } from './ContextProvider'

export default function Header() {
  const { access_token, setAccessToken } = useContext(Context)
  return (
    <>
      <Head>
        <title>RPush Server</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <div className="form-group row mt-4">
        <div className="col-sm-8">
          <Link href="/">
            <a>
              <p className="text-primary">RPush-server.</p>
            </a>
          </Link>
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

import Link from 'next/link'

import React from 'react'
import dynamic from 'next/dynamic'

import { Button } from 'reactstrap'
import Header from '../components/Header'
// Avoid the client rendering warning. See details by the link below.
// https://stackoverflow.com/questions/66374123/warning-text-content-did-not-match-server-im-out-client-im-in-div
const CustomPushForm = dynamic(() => import('../components/CustomPushForm'), {
  ssr: false,
})

function Home() {
  return (
    <div className="container">
      <Header />
      <CustomPushForm />
      <Link href="/credentials">
        <Button outline block className="mb-3" color="primary">
          CREDENTIALS PAGE
        </Button>
      </Link>
    </div>
  )
}

export default Home

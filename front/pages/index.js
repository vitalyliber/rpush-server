import Head from 'next/head'
import Link from 'next/link'

import React, { useContext } from 'react'

import { Button } from 'reactstrap'
import CustomPushForm from '../components/CustomPushForm'
import { Context } from '../components/ContextProvider'
import Header from '../components/Header'

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

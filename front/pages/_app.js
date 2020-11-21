import '../styles/globals.scss'
import ContextProvider from '../components/ContextProvider'

function MyApp({ Component, pageProps }) {
  return (
    <ContextProvider>
      <Component {...pageProps} />
    </ContextProvider>
  )
}

export default MyApp

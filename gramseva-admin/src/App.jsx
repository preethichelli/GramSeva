import { useState } from 'react'
import Sidebar from './components/Sidebar'
import Header from './components/Header'
import Overview from './components/Overview'
import Workers from './components/Workers'
import Societies from './components/Societies'
import Bookings from './components/Bookings'
import Services from './components/Services'

export default function App() {
  const [page, setPage] = useState('overview')
  // Bumped whenever a worker/society is verified elsewhere, so the
  // sidebar's pending-count badges stay in sync without polling.
  const [refreshToken, setRefreshToken] = useState(0)
  const notifyChanged = () => setRefreshToken((n) => n + 1)

  return (
    <div className="app-shell">
      <Sidebar page={page} onNavigate={setPage} refreshToken={refreshToken} />
      <div className="main-column">
        <Header page={page} />
        {page === 'overview' && <Overview onNavigate={setPage} />}
        {page === 'workers' && <Workers notifyChanged={notifyChanged} />}
        {page === 'societies' && <Societies notifyChanged={notifyChanged} />}
        {page === 'bookings' && <Bookings />}
        {page === 'services' && <Services />}
      </div>
    </div>
  )
}

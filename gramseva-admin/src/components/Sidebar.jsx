import { useEffect, useState } from 'react'
import { api } from '../api'
import {
  IconHome,
  IconUsers,
  IconBuilding,
  IconCalendar,
  IconGrid,
  IconLeaf,
} from './Icons'

const NAV_ITEMS = [
  { key: 'overview', label: 'Overview', icon: IconHome },
  { key: 'workers', label: 'Workers', icon: IconUsers, badgeKey: 'workers' },
  { key: 'societies', label: 'Societies', icon: IconBuilding, badgeKey: 'societies' },
  { key: 'bookings', label: 'Bookings', icon: IconCalendar },
  { key: 'services', label: 'Services', icon: IconGrid },
]

export default function Sidebar({ page, onNavigate, refreshToken }) {
  const [counts, setCounts] = useState({ workers: 0, societies: 0 })

  useEffect(() => {
    let cancelled = false

    async function loadCounts() {
      try {
        const [workers, societies] = await Promise.all([
          api.getWorkers(false),
          api.getSocieties(false),
        ])
        if (cancelled) return
        setCounts({
          workers: workers.filter((w) => !w.verified).length,
          societies: societies.filter((s) => !s.verified).length,
        })
      } catch (_) {
        // Sidebar badges are a nice-to-have — stay silent if the API is down;
        // the page content itself will surface the real error.
      }
    }

    loadCounts()
    return () => {
      cancelled = true
    }
  }, [refreshToken])

  return (
    <aside className="sidebar">
      <div className="sidebar-brand">
        <div className="sidebar-brand-mark">
          <IconLeaf size={22} />
        </div>
        <div>
          <div className="sidebar-brand-name">GramSeva</div>
          <div className="sidebar-brand-tagline">Cooperatives for a Stronger Tomorrow</div>
        </div>
      </div>

      <nav className="sidebar-nav">
        {NAV_ITEMS.map(({ key, label, icon: Icon, badgeKey }) => {
          const count = badgeKey ? counts[badgeKey] : 0
          return (
            <button
              key={key}
              className={`sidebar-link ${page === key ? 'active' : ''}`}
              onClick={() => onNavigate(key)}
            >
              <Icon size={19} className="icon" />
              <span className="sidebar-link-label">{label}</span>
              {count > 0 && <span className="sidebar-badge">{count}</span>}
            </button>
          )
        })}
      </nav>

      <div className="sidebar-footer">
        <div className="sidebar-footer-icon">
          <IconLeaf size={30} />
        </div>
        <div className="sidebar-footer-text">
          Stronger Cooperatives
          <br />
          Verified Workers
          <br />
          Fairer Gig Work
        </div>
        <div className="sidebar-footer-bar" />
      </div>
    </aside>
  )
}

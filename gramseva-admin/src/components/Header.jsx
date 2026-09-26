import { IconLeaf, IconMapPin, IconBell } from './Icons'

const PAGE_META = {
  overview: { title: 'GramSeva Admin', sub: 'Cooperative worker network' },
  workers: { title: 'Workers', sub: 'Verify and manage registered workers' },
  societies: { title: 'Societies', sub: 'Verify cooperative societies' },
  bookings: { title: 'Bookings', sub: 'Track service requests across the network' },
  services: { title: 'Services', sub: 'Service categories offered on GramSeva' },
}

export default function Header({ page, notificationCount = 0 }) {
  const meta = PAGE_META[page] || PAGE_META.overview

  return (
    <>
      <header className="topbar">
        <div className="topbar-inner">
          <div className="topbar-left">
            <div className="topbar-mark">
              <IconLeaf size={22} />
            </div>
            <div>
              <div className="topbar-title">{meta.title}</div>
              <div className="topbar-subtitle">
                <IconMapPin size={13} />
                {meta.sub}
              </div>
            </div>
          </div>

          <div className="topbar-right">
            <div className="topbar-tagline">
              Cooperative Governance
              <br />
              Fair Work <span className="sep">|</span> Verified Workers{' '}
              <span className="sep">|</span> Sustainable Growth
            </div>

            <button className="icon-btn" aria-label="Notifications">
              <IconBell size={18} />
              {notificationCount > 0 && <span className="dot">{notificationCount}</span>}
            </button>

            <div className="profile">
              <div className="profile-avatar">
                <IconAdminGlyph />
              </div>
              <div>
                <div className="profile-name">Admin</div>
                <div className="profile-role">GramSeva Platform</div>
              </div>
            </div>
          </div>
        </div>
      </header>
      <div className="accent-bar" />
    </>
  )
}

function IconAdminGlyph() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <circle cx="12" cy="8" r="3.4" />
      <path d="M5 20c0-3.6 3.1-6.5 7-6.5s7 2.9 7 6.5" strokeLinecap="round" />
    </svg>
  )
}

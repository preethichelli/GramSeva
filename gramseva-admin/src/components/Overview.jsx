import { useEffect, useState } from 'react'
import { api, getAllBookings } from '../api'
import StatCard from './StatCard'
import { LoadingBlock, ErrorBlock } from './StateBlocks'
import {
  IconShieldCheck,
  IconUsers,
  IconCalendar,
  IconBuilding,
  IconBriefcase,
  IconTrendingUp,
} from './Icons'

const BAR_TONES = ['var(--teal)', 'var(--saffron)']

function BarList({ rows }) {
  const max = Math.max(1, ...rows.map((r) => r.count))
  return (
    <div className="bar-list">
      {rows.map((row, i) => (
        <div className="bar-row" key={row.label}>
          <div className="bar-row-label">{row.label}</div>
          <div className="bar-track">
            <div
              className="bar-fill"
              style={{
                width: `${Math.max(4, (row.count / max) * 100)}%`,
                background: BAR_TONES[i % BAR_TONES.length],
              }}
            />
          </div>
          <div className="bar-row-count">{row.count}</div>
        </div>
      ))}
    </div>
  )
}

export default function Overview({ onNavigate }) {
  const [state, setState] = useState({ loading: true, error: null, data: null })

  useEffect(() => {
    load()
  }, [])

  async function load() {
    setState({ loading: true, error: null, data: null })
    try {
      const [workers, societies, services, bookingsResult] = await Promise.all([
        api.getWorkers(false),
        api.getSocieties(false),
        api.getServices(),
        getAllBookings(),
      ])

      const pendingWorkers = workers.filter((w) => !w.verified).length
      const activeWorkers = workers.filter((w) => w.verified).length
      const pendingSocieties = societies.filter((s) => !s.verified).length

      const skillCounts = {}
      workers.forEach((w) => {
        (w.skills || []).forEach((s) => {
          skillCounts[s] = (skillCounts[s] || 0) + 1
        })
      })
      const workersBySkill = Object.entries(skillCounts)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 6)
        .map(([label, count]) => ({ label: prettify(label), count }))

      const statusCounts = {}
      bookingsResult.bookings.forEach((b) => {
        statusCounts[b.status] = (statusCounts[b.status] || 0) + 1
      })
      const bookingsByStatus = Object.entries(statusCounts)
        .sort((a, b) => b[1] - a[1])
        .map(([label, count]) => ({ label: prettify(label), count }))

      setState({
        loading: false,
        error: null,
        data: {
          pendingWorkers,
          activeWorkers,
          pendingSocieties,
          totalBookings: bookingsResult.bookings.length,
          totalServices: services.length,
          workersBySkill,
          bookingsByStatus,
        },
      })
    } catch (err) {
      setState({ loading: false, error: err.message, data: null })
    }
  }

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Overview</h1>
        <p className="page-subtitle">A snapshot of workers, societies and bookings across GramSeva.</p>
      </div>

      {state.loading && <LoadingBlock label="Loading dashboard data…" />}
      {state.error && <ErrorBlock message={state.error} onRetry={load} />}

      {state.data && (
        <>
          <div className="stat-grid">
            <StatCard
              icon={<IconShieldCheck size={21} />}
              tone="saffron"
              label="Pending verification"
              value={state.data.pendingWorkers}
              sublabel="Workers awaiting review"
              onClick={() => onNavigate('workers')}
            />
            <StatCard
              icon={<IconUsers size={21} />}
              tone="teal"
              label="Active workers"
              value={state.data.activeWorkers}
              sublabel="Verified and job-ready"
              onClick={() => onNavigate('workers')}
            />
            <StatCard
              icon={<IconCalendar size={21} />}
              tone="teal"
              label="Total bookings"
              value={state.data.totalBookings}
              sublabel="Across all workers"
              onClick={() => onNavigate('bookings')}
            />
            <StatCard
              icon={<IconBuilding size={21} />}
              tone="saffron"
              label="Pending societies"
              value={state.data.pendingSocieties}
              sublabel="Cooperative societies awaiting review"
              onClick={() => onNavigate('societies')}
            />
          </div>

          <div className="widget-grid">
            <div className="card">
              <div className="card-header">
                <div>
                  <div className="card-header-title-row">
                    <div className="card-header-icon">
                      <IconBriefcase size={16} />
                    </div>
                    <h2 className="card-title">Workers by skill</h2>
                  </div>
                  <p className="card-description">Top registered skill categories</p>
                </div>
              </div>
              <div className="card-body">
                {state.data.workersBySkill.length ? (
                  <BarList rows={state.data.workersBySkill} />
                ) : (
                  <p className="state-text">No workers registered yet.</p>
                )}
              </div>
            </div>

            <div className="card">
              <div className="card-header">
                <div>
                  <div className="card-header-title-row">
                    <div className="card-header-icon">
                      <IconTrendingUp size={16} />
                    </div>
                    <h2 className="card-title">Bookings by status</h2>
                  </div>
                  <p className="card-description">How current bookings are progressing</p>
                </div>
              </div>
              <div className="card-body">
                {state.data.bookingsByStatus.length ? (
                  <BarList rows={state.data.bookingsByStatus} />
                ) : (
                  <p className="state-text">No bookings recorded yet.</p>
                )}
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  )
}

function prettify(slug) {
  return slug
    .split(/[-_]/)
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(' ')
}

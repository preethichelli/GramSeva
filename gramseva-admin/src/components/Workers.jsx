import { useEffect, useMemo, useState } from 'react'
import { api } from '../api'
import { LoadingBlock, ErrorBlock, EmptyBlock } from './StateBlocks'
import { VerifiedBadge } from './StatusBadge'
import { IconUsers, IconCheck } from './Icons'

const FILTERS = [
  { key: 'all', label: 'All' },
  { key: 'pending', label: 'Pending' },
  { key: 'verified', label: 'Verified' },
]

export default function Workers({ notifyChanged }) {
  const [state, setState] = useState({ loading: true, error: null, workers: [], societies: [] })
  const [filter, setFilter] = useState('all')
  const [verifyingId, setVerifyingId] = useState(null)

  useEffect(() => {
    load()
  }, [])

  async function load() {
    setState((s) => ({ ...s, loading: true, error: null }))
    try {
      const [workers, societies] = await Promise.all([
        api.getWorkers(false),
        api.getSocieties(false),
      ])
      setState({ loading: false, error: null, workers, societies })
    } catch (err) {
      setState({ loading: false, error: err.message, workers: [], societies: [] })
    }
  }

  const societyName = useMemo(() => {
    const map = {}
    state.societies.forEach((s) => {
      map[s._id] = s.name
    })
    return map
  }, [state.societies])

  const filtered = state.workers.filter((w) => {
    if (filter === 'pending') return !w.verified
    if (filter === 'verified') return w.verified
    return true
  })

  async function handleVerify(id) {
    setVerifyingId(id)
    try {
      await api.verifyWorker(id)
      setState((s) => ({
        ...s,
        workers: s.workers.map((w) => (w._id === id ? { ...w, verified: true } : w)),
      }))
      notifyChanged?.()
    } catch (err) {
      alert(`Couldn't verify this worker: ${err.message}`)
    } finally {
      setVerifyingId(null)
    }
  }

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Workers</h1>
        <p className="page-subtitle">
          Review worker registrations from the Flutter app and verify them before they can accept jobs.
        </p>
      </div>

      {state.loading && <LoadingBlock label="Loading workers…" />}
      {state.error && <ErrorBlock message={state.error} onRetry={load} />}

      {!state.loading && !state.error && (
        <div className="card">
          <div className="card-header">
            <div>
              <div className="card-header-title-row">
                <div className="card-header-icon">
                  <IconUsers size={16} />
                </div>
                <h2 className="card-title">Registered workers</h2>
              </div>
              <p className="card-description">{state.workers.length} total</p>
            </div>
          </div>
          <div className="card-body">
            <div className="tab-row">
              {FILTERS.map((f) => (
                <button
                  key={f.key}
                  className={`tab-btn ${filter === f.key ? 'active' : ''}`}
                  onClick={() => setFilter(f.key)}
                >
                  {f.label}
                </button>
              ))}
            </div>

            {filtered.length === 0 ? (
              <EmptyBlock
                title="No workers to show"
                text="Workers register from the GramSeva mobile app — once they do, they'll show up here."
              />
            ) : (
              <div className="table-wrap">
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>Name</th>
                      <th>Society</th>
                      <th>Skills</th>
                      <th>Experience</th>
                      <th>Rating</th>
                      <th>Status</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filtered.map((w) => (
                      <tr key={w._id}>
                        <td>
                          <div className="cell-primary">{w.name}</div>
                          <div className="cell-secondary">{w.phone}</div>
                        </td>
                        <td>{societyName[w.society_id] || '—'}</td>
                        <td>
                          <div className="chip-row">
                            {(w.skills || []).map((s) => (
                              <span className="chip" key={s}>
                                {s}
                              </span>
                            ))}
                          </div>
                        </td>
                        <td>{w.experience_years ?? 0} yrs</td>
                        <td>
                          {w.rating_count > 0 ? `${w.rating_avg.toFixed(1)} ★ (${w.rating_count})` : '—'}
                        </td>
                        <td>
                          <VerifiedBadge verified={w.verified} />
                        </td>
                        <td>
                          {w.verified ? (
                            <span className="cell-secondary">—</span>
                          ) : (
                            <button
                              className="btn btn-primary btn-sm"
                              disabled={verifyingId === w._id}
                              onClick={() => handleVerify(w._id)}
                            >
                              <IconCheck size={13} />
                              {verifyingId === w._id ? 'Verifying…' : 'Verify'}
                            </button>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}

import { useEffect, useState } from 'react'
import { api, getAllBookings } from '../api'
import { LoadingBlock, ErrorBlock, EmptyBlock } from './StateBlocks'
import { BookingStatusBadge } from './StatusBadge'
import { IconCalendar } from './Icons'

const NEXT_STATUS = {
  requested: ['accepted', 'rejected'],
  accepted: ['completed', 'cancelled'],
  rejected: [],
  completed: [],
  cancelled: [],
}

const STATUS_LABEL = {
  accepted: 'Accept',
  rejected: 'Reject',
  completed: 'Mark completed',
  cancelled: 'Cancel',
}

export default function Bookings() {
  const [state, setState] = useState({ loading: true, error: null, bookings: [] })
  const [updatingId, setUpdatingId] = useState(null)

  useEffect(() => {
    load()
  }, [])

  async function load() {
    setState((s) => ({ ...s, loading: true, error: null }))
    try {
      const { bookings } = await getAllBookings()
      setState({ loading: false, error: null, bookings })
    } catch (err) {
      setState({ loading: false, error: err.message, bookings: [] })
    }
  }

  async function handleStatusChange(id, status) {
    setUpdatingId(id)
    try {
      await api.updateBookingStatus(id, status)
      setState((s) => ({
        ...s,
        bookings: s.bookings.map((b) => (b._id === id ? { ...b, status } : b)),
      }))
    } catch (err) {
      alert(`Couldn't update this booking: ${err.message}`)
    } finally {
      setUpdatingId(null)
    }
  }

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Bookings</h1>
        <p className="page-subtitle">
          Service requests made by customers, merged across every worker in the network.
        </p>
      </div>

      {state.loading && <LoadingBlock label="Loading bookings…" />}
      {state.error && <ErrorBlock message={state.error} onRetry={load} />}

      {!state.loading && !state.error && (
        <div className="card">
          <div className="card-header">
            <div>
              <div className="card-header-title-row">
                <div className="card-header-icon">
                  <IconCalendar size={16} />
                </div>
                <h2 className="card-title">All bookings</h2>
              </div>
              <p className="card-description">{state.bookings.length} total, most recent first</p>
            </div>
          </div>
          <div className="card-body">
            {state.bookings.length === 0 ? (
              <EmptyBlock
                title="No bookings yet"
                text="Bookings created from the customer-facing app will appear here."
              />
            ) : (
              <div className="table-wrap">
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>Worker</th>
                      <th>Customer</th>
                      <th>Service</th>
                      <th>Scheduled</th>
                      <th>Emergency</th>
                      <th>Status</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {state.bookings.map((b) => (
                      <tr key={b._id}>
                        <td className="cell-primary">{b._workerName}</td>
                        <td>
                          <span className="cell-secondary">{b.customer_uid}</span>
                        </td>
                        <td>{b.service_slug}</td>
                        <td>{formatDate(b.scheduled_at) || formatDate(b.created_at)}</td>
                        <td>{b.is_emergency ? 'Yes' : 'No'}</td>
                        <td>
                          <BookingStatusBadge status={b.status} />
                        </td>
                        <td>
                          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                            {(NEXT_STATUS[b.status] || []).map((next) => (
                              <button
                                key={next}
                                className={`btn btn-sm ${next === 'rejected' || next === 'cancelled' ? 'btn-outline' : 'btn-primary'}`}
                                disabled={updatingId === b._id}
                                onClick={() => handleStatusChange(b._id, next)}
                              >
                                {STATUS_LABEL[next]}
                              </button>
                            ))}
                            {(NEXT_STATUS[b.status] || []).length === 0 && (
                              <span className="cell-secondary">—</span>
                            )}
                          </div>
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

function formatDate(value) {
  if (!value) return null
  const d = new Date(value)
  if (Number.isNaN(d.getTime())) return null
  return d.toLocaleDateString(undefined, { day: '2-digit', month: 'short', year: 'numeric' })
}

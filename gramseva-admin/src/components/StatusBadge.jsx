// src/components/StatusBadge.jsx
// Renders a small colored pill. Stays within the brand palette:
// teal = verified / progressing, saffron = pending / needs attention,
// slate = inactive / stopped (rejected, cancelled).

const BOOKING_TONE = {
  requested: 'saffron',
  accepted: 'teal',
  completed: 'teal',
  rejected: 'slate',
  cancelled: 'slate',
}

const BOOKING_LABEL = {
  requested: 'Requested',
  accepted: 'Accepted',
  completed: 'Completed',
  rejected: 'Rejected',
  cancelled: 'Cancelled',
}

export function VerifiedBadge({ verified }) {
  return (
    <span className={`badge tone-${verified ? 'teal' : 'saffron'}`}>
      <span className="badge-dot" />
      {verified ? 'Verified' : 'Pending'}
    </span>
  )
}

export function BookingStatusBadge({ status }) {
  const tone = BOOKING_TONE[status] || 'slate'
  const label = BOOKING_LABEL[status] || status
  return (
    <span className={`badge tone-${tone}`}>
      <span className="badge-dot" />
      {label}
    </span>
  )
}

import { IconAlertTriangle } from './Icons'

export function LoadingBlock({ label = 'Loading…' }) {
  return (
    <div className="state-block">
      <div className="state-spinner" />
      <div className="state-text">{label}</div>
    </div>
  )
}

export function ErrorBlock({ message, onRetry }) {
  return (
    <div className="state-block">
      <IconAlertTriangle size={30} className="icon state-icon error" />
      <div className="state-title">Couldn't load this data</div>
      <div className="state-text">{message}</div>
      {onRetry && (
        <button className="btn btn-outline" onClick={onRetry} style={{ marginTop: 4 }}>
          Retry
        </button>
      )}
    </div>
  )
}

export function EmptyBlock({ title = 'Nothing here yet', text, action }) {
  return (
    <div className="state-block">
      <div className="state-title">{title}</div>
      {text && <div className="state-text">{text}</div>}
      {action}
    </div>
  )
}

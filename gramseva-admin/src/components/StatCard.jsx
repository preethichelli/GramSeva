import { IconChevronRight } from './Icons'

// tone: 'saffron' | 'teal'
export default function StatCard({ icon, tone = 'teal', label, value, sublabel, onClick }) {
  return (
    <div className="stat-card">
      <div className="stat-card-top">
        <div className={`stat-icon tone-${tone}`}>{icon}</div>
        {onClick && (
          <button className="chevron-link" onClick={onClick} aria-label={`View ${label}`}>
            <IconChevronRight size={18} />
          </button>
        )}
      </div>
      <div>
        <div className="stat-label">{label}</div>
        <div className="stat-value">{value}</div>
        {sublabel && <div className="stat-sublabel">{sublabel}</div>}
      </div>
    </div>
  )
}

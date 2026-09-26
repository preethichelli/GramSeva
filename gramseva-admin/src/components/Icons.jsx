// src/components/Icons.jsx
// Small hand-rolled stroke icons so the app has no icon-library dependency.

function Base({ children, size = 20, ...rest }) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className="icon"
      {...rest}
    >
      {children}
    </svg>
  )
}

export function IconHome(props) {
  return (
    <Base {...props}>
      <path d="M3 11.5 12 4l9 7.5" />
      <path d="M5.5 10v9.5a1 1 0 0 0 1 1H17.5a1 1 0 0 0 1-1V10" />
    </Base>
  )
}

export function IconUsers(props) {
  return (
    <Base {...props}>
      <circle cx="9" cy="8" r="3.2" />
      <path d="M3.5 19c0-3 2.5-5 5.5-5s5.5 2 5.5 5" />
      <path d="M15.5 5.2A3.2 3.2 0 0 1 16 11.3" />
      <path d="M15.2 14c2.6.4 4.8 2.2 4.8 5" />
    </Base>
  )
}

export function IconBuilding(props) {
  return (
    <Base {...props}>
      <rect x="4" y="3.5" width="10" height="17" rx="1" />
      <path d="M14 9h6v11.5H14" />
      <path d="M7.5 8h3M7.5 11.5h3M7.5 15h3" />
    </Base>
  )
}

export function IconCalendar(props) {
  return (
    <Base {...props}>
      <rect x="3.5" y="5" width="17" height="15.5" rx="2" />
      <path d="M3.5 9.5h17" />
      <path d="M8 3v4M16 3v4" />
    </Base>
  )
}

export function IconGrid(props) {
  return (
    <Base {...props}>
      <rect x="3.5" y="3.5" width="7" height="7" rx="1.3" />
      <rect x="13.5" y="3.5" width="7" height="7" rx="1.3" />
      <rect x="3.5" y="13.5" width="7" height="7" rx="1.3" />
      <rect x="13.5" y="13.5" width="7" height="7" rx="1.3" />
    </Base>
  )
}

export function IconBell(props) {
  return (
    <Base {...props}>
      <path d="M6 10.5a6 6 0 0 1 12 0c0 2.2.6 3.6 1.5 5H4.5c.9-1.4 1.5-2.8 1.5-5Z" />
      <path d="M9.7 19a2.3 2.3 0 0 0 4.6 0" />
    </Base>
  )
}

export function IconChevronRight(props) {
  return (
    <Base {...props}>
      <path d="M9 6l6 6-6 6" />
    </Base>
  )
}

export function IconCheck(props) {
  return (
    <Base {...props}>
      <path d="M5 12.5l5 5L19 7" />
    </Base>
  )
}

export function IconShieldCheck(props) {
  return (
    <Base {...props}>
      <path d="M12 3.5 19 6.3v5.4c0 4.7-3.1 7.6-7 8.8-3.9-1.2-7-4.1-7-8.8V6.3Z" />
      <path d="M9 12l2.2 2.2L15.5 10" />
    </Base>
  )
}

export function IconMapPin(props) {
  return (
    <Base {...props}>
      <path d="M12 21s7-6.1 7-11.5A7 7 0 0 0 5 9.5C5 14.9 12 21 12 21Z" />
      <circle cx="12" cy="9.5" r="2.3" />
    </Base>
  )
}

export function IconAlertTriangle(props) {
  return (
    <Base {...props}>
      <path d="M12 4 2.5 20h19L12 4Z" />
      <path d="M12 10v4" />
      <path d="M12 17.5h.01" />
    </Base>
  )
}

export function IconBriefcase(props) {
  return (
    <Base {...props}>
      <rect x="3" y="8" width="18" height="11" rx="1.5" />
      <path d="M8 8V6.5A2.5 2.5 0 0 1 10.5 4h3A2.5 2.5 0 0 1 16 6.5V8" />
      <path d="M3 12.5h18" />
    </Base>
  )
}

export function IconTrendingUp(props) {
  return (
    <Base {...props}>
      <path d="M3.5 16.5 10 10l4 4 6.5-6.5" />
      <path d="M15.5 7h5v5" />
    </Base>
  )
}

export function IconLeaf(props) {
  return (
    <Base {...props}>
      <path d="M20 4C10 4 4 10 4 18c0 .6.4 1 1 1 8 0 14-6 15-16 0-.6-.4-1-1-1 0 0 1 0 1 0Z" />
      <path d="M9 19c0-5 2.5-9 8-11" />
    </Base>
  )
}

export function IconSeed(props) {
  return (
    <Base {...props}>
      <path d="M12 22c5-1 8-5 8-11a15 15 0 0 0-8-2 15 15 0 0 0-8 2c0 6 3 10 8 11Z" />
      <path d="M12 22V9" />
    </Base>
  )
}

import { useEffect, useState } from 'react'
import { api } from '../api'
import { LoadingBlock, ErrorBlock, EmptyBlock } from './StateBlocks'
import { IconGrid, IconSeed } from './Icons'

export default function Services() {
  const [state, setState] = useState({ loading: true, error: null, services: [] })
  const [seeding, setSeeding] = useState(false)

  useEffect(() => {
    load()
  }, [])

  async function load() {
    setState((s) => ({ ...s, loading: true, error: null }))
    try {
      const services = await api.getServices()
      setState({ loading: false, error: null, services })
    } catch (err) {
      setState({ loading: false, error: err.message, services: [] })
    }
  }

  async function handleSeed() {
    setSeeding(true)
    try {
      await api.seedServices()
      await load()
    } catch (err) {
      alert(`Couldn't seed default services: ${err.message}`)
    } finally {
      setSeeding(false)
    }
  }

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Services</h1>
        <p className="page-subtitle">
          Service categories offered on GramSeva. This list is read-only in the admin dashboard.
        </p>
      </div>

      {state.loading && <LoadingBlock label="Loading services…" />}
      {state.error && <ErrorBlock message={state.error} onRetry={load} />}

      {!state.loading && !state.error && (
        <div className="card">
          <div className="card-header">
            <div>
              <div className="card-header-title-row">
                <div className="card-header-icon">
                  <IconGrid size={16} />
                </div>
                <h2 className="card-title">Service categories</h2>
              </div>
              <p className="card-description">{state.services.length} categories</p>
            </div>
            {state.services.length === 0 && (
              <button className="btn btn-outline" disabled={seeding} onClick={handleSeed}>
                <IconSeed size={14} />
                {seeding ? 'Seeding…' : 'Seed default services'}
              </button>
            )}
          </div>
          <div className="card-body">
            {state.services.length === 0 ? (
              <EmptyBlock
                title="No service categories yet"
                text="Seed the default GramSeva service catalog to get started."
                action={
                  <button className="btn btn-primary" disabled={seeding} onClick={handleSeed}>
                    <IconSeed size={14} />
                    {seeding ? 'Seeding…' : 'Seed default services'}
                  </button>
                }
              />
            ) : (
              <div className="service-grid">
                {state.services.map((s) => (
                  <div className="service-card" key={s._id}>
                    <div className="service-icon">{s.name.charAt(0)}</div>
                    <div>
                      <div className="service-name">{s.name}</div>
                      <div className="service-slug">{s.slug}</div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}

import { useEffect, useState } from 'react'
import { api } from '../api'
import { LoadingBlock, ErrorBlock, EmptyBlock } from './StateBlocks'
import { VerifiedBadge } from './StatusBadge'
import { IconBuilding, IconCheck, IconSeed } from './Icons'

export default function Societies({ notifyChanged }) {
  const [state, setState] = useState({ loading: true, error: null, societies: [] })
  const [verifyingId, setVerifyingId] = useState(null)
  const [seeding, setSeeding] = useState(false)

  useEffect(() => {
    load()
  }, [])

  async function load() {
    setState((s) => ({ ...s, loading: true, error: null }))
    try {
      const societies = await api.getSocieties(false)
      setState({ loading: false, error: null, societies })
    } catch (err) {
      setState({ loading: false, error: err.message, societies: [] })
    }
  }

  async function handleVerify(id) {
    setVerifyingId(id)
    try {
      await api.verifySociety(id)
      setState((s) => ({
        ...s,
        societies: s.societies.map((soc) => (soc._id === id ? { ...soc, verified: true } : soc)),
      }))
      notifyChanged?.()
    } catch (err) {
      alert(`Couldn't verify this society: ${err.message}`)
    } finally {
      setVerifyingId(null)
    }
  }

  async function handleSeed() {
    setSeeding(true)
    try {
      await api.seedSocieties()
      await load()
    } catch (err) {
      alert(`Couldn't seed sample societies: ${err.message}`)
    } finally {
      setSeeding(false)
    }
  }

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Societies</h1>
        <p className="page-subtitle">
          Cooperative societies must be verified before their workers can join the network.
        </p>
      </div>

      {state.loading && <LoadingBlock label="Loading societies…" />}
      {state.error && <ErrorBlock message={state.error} onRetry={load} />}

      {!state.loading && !state.error && (
        <div className="card">
          <div className="card-header">
            <div>
              <div className="card-header-title-row">
                <div className="card-header-icon">
                  <IconBuilding size={16} />
                </div>
                <h2 className="card-title">Cooperative societies</h2>
              </div>
              <p className="card-description">{state.societies.length} registered</p>
            </div>
            {state.societies.length === 0 && (
              <button className="btn btn-outline" disabled={seeding} onClick={handleSeed}>
                <IconSeed size={14} />
                {seeding ? 'Seeding…' : 'Seed sample societies'}
              </button>
            )}
          </div>
          <div className="card-body">
            {state.societies.length === 0 ? (
              <EmptyBlock
                title="No societies yet"
                text="Seed a couple of sample cooperative societies to get started, or wait for real registrations."
                action={
                  <button className="btn btn-primary" disabled={seeding} onClick={handleSeed}>
                    <IconSeed size={14} />
                    {seeding ? 'Seeding…' : 'Seed sample societies'}
                  </button>
                }
              />
            ) : (
              <div className="table-wrap">
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>Society name</th>
                      <th>Registration no.</th>
                      <th>District</th>
                      <th>State</th>
                      <th>Contact</th>
                      <th>Status</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {state.societies.map((soc) => (
                      <tr key={soc._id}>
                        <td>
                          <div className="cell-primary">{soc.name}</div>
                          {soc.federation_name && (
                            <div className="cell-secondary">{soc.federation_name}</div>
                          )}
                        </td>
                        <td>{soc.registration_number}</td>
                        <td>{soc.district}</td>
                        <td>{soc.state}</td>
                        <td>{soc.contact_phone}</td>
                        <td>
                          <VerifiedBadge verified={soc.verified} />
                        </td>
                        <td>
                          {soc.verified ? (
                            <span className="cell-secondary">—</span>
                          ) : (
                            <button
                              className="btn btn-primary btn-sm"
                              disabled={verifyingId === soc._id}
                              onClick={() => handleVerify(soc._id)}
                            >
                              <IconCheck size={13} />
                              {verifyingId === soc._id ? 'Verifying…' : 'Verify'}
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

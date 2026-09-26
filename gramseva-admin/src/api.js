// src/api.js
// Thin fetch wrapper around the GramSeva FastAPI backend.
// Endpoint shapes come directly from gram-seva-backend/app/routers/*.py
// and gram-seva-backend/app/models/*.py — see those files for the source of truth.

const BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000'

class ApiError extends Error {
  constructor(message, status) {
    super(message)
    this.name = 'ApiError'
    this.status = status
  }
}

async function request(path, options = {}) {
  let res
  try {
    res = await fetch(`${BASE_URL}${path}`, {
      headers: {
        'Content-Type': 'application/json',
        ...(options.headers || {}),
      },
      ...options,
    })
  } catch (err) {
    // fetch throws (network error / CORS / backend down) rather than resolving
    throw new ApiError(
      `Could not reach the GramSeva API at ${BASE_URL}. Is the backend running?`,
      0
    )
  }

  if (!res.ok) {
    let detail = ''
    try {
      const body = await res.json()
      if (body?.detail) detail = `: ${body.detail}`
    } catch (_) {
      // response wasn't JSON — ignore
    }
    throw new ApiError(`Request failed (${res.status})${detail}`, res.status)
  }

  if (res.status === 204) return null
  const text = await res.text()
  return text ? JSON.parse(text) : null
}

export const api = {
  // ---- Workers -----------------------------------------------------
  // GET /workers/?verified_only=false — list all workers (unverified + verified)
  getWorkers(verifiedOnly = false) {
    return request(`/workers/?verified_only=${verifiedOnly}`)
  },
  // PATCH /workers/{id}/verify
  verifyWorker(id) {
    return request(`/workers/${id}/verify`, { method: 'PATCH' })
  },

  // ---- Societies ------------------------------------------------------
  // GET /societies/?verified_only=false
  getSocieties(verifiedOnly = false) {
    return request(`/societies/?verified_only=${verifiedOnly}`)
  },
  // POST /societies/seed
  seedSocieties() {
    return request(`/societies/seed`, { method: 'POST' })
  },
  // PATCH /societies/{id}/verify
  verifySociety(id) {
    return request(`/societies/${id}/verify`, { method: 'PATCH' })
  },

  // ---- Bookings -------------------------------------------------------
  // GET /bookings/worker/{worker_id}
  getWorkerBookings(workerId) {
    return request(`/bookings/worker/${workerId}`)
  },
  // PATCH /bookings/{id}/status   body: { status }
  updateBookingStatus(id, status) {
    return request(`/bookings/${id}/status`, {
      method: 'PATCH',
      body: JSON.stringify({ status }),
    })
  },

  // ---- Services (read-only) -------------------------------------------
  // GET /services/
  getServices() {
    return request(`/services/`)
  },
  // POST /services/seed
  seedServices() {
    return request(`/services/seed`, { method: 'POST' })
  },
}

// The backend has no "list all bookings" endpoint — only per-worker /
// per-customer lookups (see routers/bookings.py). To build an admin-wide
// bookings table we fetch every worker, then fan out one request per
// worker and merge the results client-side.
export async function getAllBookings() {
  const workers = await api.getWorkers(false)
  const settled = await Promise.allSettled(
    workers.map((w) => api.getWorkerBookings(w._id))
  )

  const bookings = []
  settled.forEach((result, idx) => {
    if (result.status === 'fulfilled') {
      const worker = workers[idx]
      result.value.forEach((b) => {
        bookings.push({
          ...b,
          _workerName: worker.name,
          _workerId: worker._id,
        })
      })
    }
  })

  bookings.sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
  return { bookings, workers }
}

export { ApiError, BASE_URL }

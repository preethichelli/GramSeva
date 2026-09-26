from fastapi import APIRouter, HTTPException
from bson import ObjectId
from app.core.database import bookings_collection, workers_collection
from app.models.booking import BookingCreate, BookingStatusUpdate

router = APIRouter(prefix="/bookings", tags=["bookings"])


def _serialize(doc) -> dict:
    doc["_id"] = str(doc["_id"])
    return doc


@router.post("/")
async def create_booking(booking: BookingCreate):
    worker = await workers_collection.find_one({"_id": ObjectId(booking.worker_id)})
    if not worker:
        raise HTTPException(status_code=404, detail="Worker not found")

    doc = booking.model_dump()
    doc["status"] = "requested"
    doc["society_id"] = worker["society_id"]  # denormalize for admin dashboard queries
    result = await bookings_collection.insert_one(doc)
    created = await bookings_collection.find_one({"_id": result.inserted_id})
    return _serialize(created)


@router.get("/worker/{worker_id}")
async def list_worker_bookings(worker_id: str):
    docs = await bookings_collection.find({"worker_id": worker_id}).sort("created_at", -1).to_list(length=100)
    return [_serialize(d) for d in docs]


@router.get("/customer/{customer_uid}")
async def list_customer_bookings(customer_uid: str):
    docs = await bookings_collection.find({"customer_uid": customer_uid}).sort("created_at", -1).to_list(length=100)
    return [_serialize(d) for d in docs]


@router.patch("/{booking_id}/status")
async def update_status(booking_id: str, update: BookingStatusUpdate):
    result = await bookings_collection.update_one(
        {"_id": ObjectId(booking_id)}, {"$set": {"status": update.status.value}}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Booking not found")
    updated = await bookings_collection.find_one({"_id": ObjectId(booking_id)})
    return _serialize(updated)


@router.patch("/{booking_id}/rate")
async def rate_booking(booking_id: str, rating: int, feedback: str = ""):
    if not 1 <= rating <= 5:
        raise HTTPException(status_code=400, detail="Rating must be 1-5")

    booking = await bookings_collection.find_one({"_id": ObjectId(booking_id)})
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")

    await bookings_collection.update_one(
        {"_id": ObjectId(booking_id)}, {"$set": {"rating": rating, "feedback": feedback}}
    )

    # Roll the new rating into the worker's running average
    worker = await workers_collection.find_one({"_id": ObjectId(booking["worker_id"])})
    if worker:
        new_count = worker["rating_count"] + 1
        new_avg = ((worker["rating_avg"] * worker["rating_count"]) + rating) / new_count
        await workers_collection.update_one(
            {"_id": worker["_id"]},
            {"$set": {"rating_avg": round(new_avg, 2), "rating_count": new_count}},
        )

    return {"status": "rated"}

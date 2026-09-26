from fastapi import APIRouter, HTTPException, Query
from bson import ObjectId
from typing import Optional
from app.core.database import workers_collection
from app.models.worker import WorkerCreate

router = APIRouter(prefix="/workers", tags=["workers"])


def _serialize(doc) -> dict:
    doc["_id"] = str(doc["_id"])
    return doc


@router.post("/")
async def register_worker(worker: WorkerCreate):
    doc = worker.model_dump()
    doc.update({"verified": False, "available": True, "rating_avg": 0.0, "rating_count": 0})
    result = await workers_collection.insert_one(doc)
    created = await workers_collection.find_one({"_id": result.inserted_id})
    return _serialize(created)


@router.get("/")
async def list_workers(
    skill: Optional[str] = Query(None, description="Filter by service slug, e.g. 'electrician'"),
    society_id: Optional[str] = Query(None),
    verified_only: bool = True,
):
    query = {}
    if skill:
        query["skills"] = skill
    if society_id:
        query["society_id"] = society_id
    if verified_only:
        query["verified"] = True
    docs = await workers_collection.find(query).to_list(length=200)
    return [_serialize(d) for d in docs]


@router.get("/{worker_id}")
async def get_worker(worker_id: str):
    doc = await workers_collection.find_one({"_id": ObjectId(worker_id)})
    if not doc:
        raise HTTPException(status_code=404, detail="Worker not found")
    return _serialize(doc)


@router.patch("/{worker_id}/verify")
async def verify_worker(worker_id: str):
    result = await workers_collection.update_one(
        {"_id": ObjectId(worker_id)}, {"$set": {"verified": True}}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Worker not found")
    return {"status": "verified"}


@router.patch("/{worker_id}/availability")
async def set_availability(worker_id: str, available: bool):
    result = await workers_collection.update_one(
        {"_id": ObjectId(worker_id)}, {"$set": {"available": available}}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Worker not found")
    return {"status": "updated", "available": available}


@router.patch("/{worker_id}/location")
async def update_location(worker_id: str, lat: float, lng: float):
    result = await workers_collection.update_one(
        {"_id": ObjectId(worker_id)},
        {"$set": {"location": {"type": "Point", "coordinates": [lng, lat]}}},
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Worker not found")
    return {"status": "updated"}

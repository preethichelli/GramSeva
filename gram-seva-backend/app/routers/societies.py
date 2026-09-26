from fastapi import APIRouter, HTTPException
from bson import ObjectId
from app.core.database import societies_collection
from app.models.society import SocietyCreate, DEFAULT_SOCIETIES

router = APIRouter(prefix="/societies", tags=["societies"])


def _serialize(doc) -> dict:
    doc["_id"] = str(doc["_id"])
    return doc


@router.post("/")
async def create_society(society: SocietyCreate):
    result = await societies_collection.insert_one(society.model_dump())
    created = await societies_collection.find_one({"_id": result.inserted_id})
    return _serialize(created)


@router.post("/seed")
async def seed_societies():
    """Populate sample cooperative societies. Safe to call any number of times -
    each society is upserted by registration_number, so existing ones are left
    untouched and only new entries (in DEFAULT_SOCIETIES) get inserted."""
    added = 0
    for society in DEFAULT_SOCIETIES:
        result = await societies_collection.update_one(
            {"registration_number": society["registration_number"]},
            {"$setOnInsert": society},
            upsert=True,
        )
        if result.upserted_id is not None:
            added += 1
    total = await societies_collection.count_documents({})
    return {"status": "seeded", "added": added, "total": total}


@router.get("/")
async def list_societies(verified_only: bool = False):
    query = {"verified": True} if verified_only else {}
    docs = await societies_collection.find(query).to_list(length=200)
    return [_serialize(d) for d in docs]


@router.get("/{society_id}")
async def get_society(society_id: str):
    doc = await societies_collection.find_one({"_id": ObjectId(society_id)})
    if not doc:
        raise HTTPException(status_code=404, detail="Society not found")
    return _serialize(doc)


@router.patch("/{society_id}/verify")
async def verify_society(society_id: str):
    """Admin-only in practice — lock this down with a role check before demo day."""
    result = await societies_collection.update_one(
        {"_id": ObjectId(society_id)}, {"$set": {"verified": True}}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Society not found")
    return {"status": "verified"}
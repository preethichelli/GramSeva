from fastapi import APIRouter
from app.core.database import services_collection
from app.models.service import DEFAULT_SERVICES

router = APIRouter(prefix="/services", tags=["services"])


def _serialize(doc) -> dict:
    doc["_id"] = str(doc["_id"])
    return doc


@router.get("/")
async def list_services():
    docs = await services_collection.find().to_list(length=50)
    return [_serialize(d) for d in docs]


@router.post("/seed")
async def seed_services():
    """Populate the service catalog. Safe to call any number of times -
    each category is upserted by slug, so existing ones are left untouched
    and only newly-added categories (in DEFAULT_SERVICES) get inserted."""
    added = 0
    for service in DEFAULT_SERVICES:
        result = await services_collection.update_one(
            {"slug": service["slug"]},
            {"$setOnInsert": service},
            upsert=True,
        )
        if result.upserted_id is not None:
            added += 1
    total = await services_collection.count_documents({})
    return {"status": "seeded", "added": added, "total": total}

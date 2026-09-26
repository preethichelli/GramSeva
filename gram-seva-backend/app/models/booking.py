from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from enum import Enum


class BookingStatus(str, Enum):
    requested = "requested"
    accepted = "accepted"
    rejected = "rejected"
    completed = "completed"
    cancelled = "cancelled"


class BookingBase(BaseModel):
    customer_uid: str          # Firebase UID of the customer
    worker_id: str              # references workers._id
    society_id: str             # denormalized, so admin dashboard doesn't need a join
    service_slug: str
    status: BookingStatus = BookingStatus.requested
    scheduled_at: Optional[datetime] = None
    customer_lat: Optional[float] = None
    customer_lng: Optional[float] = None
    is_emergency: bool = False
    rating: Optional[int] = None       # 1-5, filled after completion
    feedback: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)


class BookingCreate(BaseModel):
    customer_uid: str
    worker_id: str
    service_slug: str
    scheduled_at: Optional[datetime] = None
    customer_lat: Optional[float] = None
    customer_lng: Optional[float] = None
    is_emergency: bool = False


class BookingStatusUpdate(BaseModel):
    status: BookingStatus


class BookingOut(BookingBase):
    id: str = Field(alias="_id")

    class Config:
        populate_by_name = True

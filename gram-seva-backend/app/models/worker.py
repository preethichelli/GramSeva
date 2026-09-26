from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime


class Location(BaseModel):
    type: str = "Point"
    coordinates: List[float]  # [longitude, latitude]


class WorkerBase(BaseModel):
    name: str
    phone: str
    firebase_uid: str
    society_id: str  # references societies._id
    skills: List[str]  # e.g. ["electrician", "plumber"]
    experience_years: Optional[int] = 0
    certification_urls: List[str] = []
    verified: bool = False
    available: bool = True
    location: Optional[Location] = None
    rating_avg: float = 0.0
    rating_count: int = 0
    created_at: datetime = Field(default_factory=datetime.utcnow)


class WorkerCreate(BaseModel):
    name: str
    phone: str
    firebase_uid: str
    society_id: str
    skills: List[str]
    experience_years: Optional[int] = 0


class WorkerOut(WorkerBase):
    id: str = Field(alias="_id")

    class Config:
        populate_by_name = True

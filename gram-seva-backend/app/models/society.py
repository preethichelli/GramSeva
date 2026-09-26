from pydantic import BaseModel, Field
from typing import Optional
from app.models.common import PyObjectId


class SocietyBase(BaseModel):
    name: str
    federation_name: Optional[str] = None
    registration_number: str
    district: str
    state: str
    contact_phone: str
    verified: bool = False


class SocietyCreate(SocietyBase):
    pass


class SocietyOut(SocietyBase):
    id: str = Field(alias="_id")

    class Config:
        populate_by_name = True
        json_encoders = {PyObjectId: str}

# Seed data so the "Registered Labour Cooperative Society" dropdown isn't empty
DEFAULT_SOCIETIES = [
    {
        "name": "Sahakar Seva Cooperative",
        "federation_name": None,
        "registration_number": "REG-001",
        "district": "Hyderabad",
        "state": "Telangana",
        "contact_phone": "+919800000001",
        "verified": True,
    },
    {
        "name": "Gram Vikas Labour Society",
        "federation_name": None,
        "registration_number": "REG-002",
        "district": "Rangareddy",
        "state": "Telangana",
        "contact_phone": "+919800000002",
        "verified": True,
    },
]
from pydantic import BaseModel, Field


class ServiceBase(BaseModel):
    name: str          # e.g. "Electrician"
    slug: str           # e.g. "electrician"
    icon: str            # tabler icon name for the frontend, e.g. "ti-bulb"


class ServiceOut(ServiceBase):
    id: str = Field(alias="_id")

    class Config:
        populate_by_name = True


# Seed data matching the problem statement's worker list exactly
DEFAULT_SERVICES = [
    {"name": "Electrician", "slug": "electrician", "icon": "ti-bulb"},
    {"name": "Plumber", "slug": "plumber", "icon": "ti-droplet"},
    {"name": "Carpenter", "slug": "carpenter", "icon": "ti-hammer"},
    {"name": "Painter", "slug": "painter", "icon": "ti-brush"},
    {"name": "Domestic help", "slug": "domestic-help", "icon": "ti-home-2"},
    {"name": "Caregiver", "slug": "caregiver", "icon": "ti-heart-handshake"},
    {"name": "Driver", "slug": "driver", "icon": "ti-steering-wheel"},
    {"name": "Gardener", "slug": "gardener", "icon": "ti-plant-2"},
    {"name": "Cleaner", "slug": "cleaner", "icon": "ti-spray"},
    {"name": "Technician", "slug": "technician", "icon": "ti-tool"},
    {"name": "Cook", "slug": "cook", "icon": "ti-chef-hat"},
    {"name": "Nanny", "slug": "nanny", "icon": "ti-baby-carriage"},
]

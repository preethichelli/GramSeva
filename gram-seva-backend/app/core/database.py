import os
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv

load_dotenv()

MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
DB_NAME = os.getenv("DB_NAME", "sahakar_seva")

client = AsyncIOMotorClient(MONGO_URI)
db = client[DB_NAME]

# Collections used across the app
societies_collection = db["societies"]
workers_collection = db["workers"]
users_collection = db["users"]
services_collection = db["services"]
bookings_collection = db["bookings"]

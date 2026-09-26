from fastapi import Header, HTTPException
import firebase_admin
from firebase_admin import credentials, auth
import os

# Initialize Firebase Admin once. Point FIREBASE_CREDENTIALS_PATH at your
# service account JSON (download from Firebase console > Project settings >
# Service accounts).
if not firebase_admin._apps:
    cred_path = os.getenv("FIREBASE_CREDENTIALS_PATH", "firebase-credentials.json")
    if os.path.exists(cred_path):
        cred = credentials.Certificate(cred_path)
        firebase_admin.initialize_app(cred)


async def get_current_uid(authorization: str = Header(...)) -> str:
    """
    Expects header: Authorization: Bearer <firebase_id_token>
    Returns the Firebase UID if valid, else 401.
    """
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing bearer token")
    token = authorization.split(" ", 1)[1]
    try:
        decoded = auth.verify_id_token(token)
        return decoded["uid"]
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid or expired token")

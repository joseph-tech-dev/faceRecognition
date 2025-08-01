import re

EMAIL_REGEX = re.compile(r"[^@]+@[^@]+\.[^@]+")
PHONE_REGEX = re.compile(r"^\+?\d{7,15}$")
USERNAME_REGEX = re.compile(r"^[a-zA-Z0-9._-]{3,30}$")

def is_valid_username(username: str, pattern: str) -> bool:
    return bool(re.fullmatch(pattern, username))

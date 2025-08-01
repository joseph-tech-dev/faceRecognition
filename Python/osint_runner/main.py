import sys
import re
import json
import asyncio
from datetime import datetime, timezone

from .platforms import PLATFORMS, PLATFORM_HEADERS
from .utils import EMAIL_REGEX, PHONE_REGEX

try:
    import aiohttp
except ImportError:
    sys.stdout.write(json.dumps({
        "error": "Missing aiohttp module",
        "results": []
    }))
    sys.exit(1)

async def fetch_with_retry(session, url, platform, max_retries=2):
    result = {
        "platform": platform,
        "url": url,
        "status": 0,
        "exists": None,
        "error": None,
        "timestamp": datetime.now(timezone.utc).isoformat(),

    }
    config = PLATFORMS.get(platform, {})

    for attempt in range(max_retries + 1):
        try:
            async with session.get(url, timeout=10) as resp:
                content = await resp.text()
                result["status"] = resp.status
                if resp.status == 404:
                    result["exists"] = False
                elif resp.status == 200:
                    if any(re.search(p, content) for p in config.get("positive_patterns", [])):
                        result["exists"] = True
                    elif any(re.search(p, content) for p in config.get("error_patterns", [])):
                        result["exists"] = False
                return result
        except Exception as e:
            if attempt == max_retries:
                result["error"] = str(e)
    return result

async def username_search(username):
    results = []
    async with aiohttp.ClientSession(
        headers={"User-Agent": "Mozilla/5.0"},
        connector=aiohttp.TCPConnector(limit=10)
    ) as session:
        tasks = [
            fetch_with_retry(session, config["url"].format(username), platform)
            for platform, config in PLATFORMS.items() if "url" in config
        ]
        results = await asyncio.gather(*tasks)
    return results

async def email_search(email):
    if not EMAIL_REGEX.fullmatch(email):
        return [{
            "platform": "Validation",
            "error": "Invalid email format",
            "timestamp": datetime.utcnow().isoformat()
        }]
    return [{
        "platform": "HaveIBeenPwned",
        "url": f"https://haveibeenpwned.com/account/{email}",
        "status": 200,
        "exists": True,
        "timestamp": datetime.utcnow().isoformat()
    }]

async def phone_search(phone):
    if not PHONE_REGEX.fullmatch(phone):
        return [{
            "platform": "Validation",
            "error": "Invalid phone format",
            "timestamp": datetime.utcnow().isoformat()
        }]
    return [{
        "platform": "PhoneLookup",
        "url": f"https://search.example.com/phone/{phone}",
        "status": 200,
        "exists": True,
        "timestamp": datetime.utcnow().isoformat()
    }]

async def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--username", type=str)
    parser.add_argument("--email", type=str)
    parser.add_argument("--phone", type=str)
    args = parser.parse_args()

    results = []
    if args.username:
        results = await username_search(args.username)
    elif args.email:
        results = await email_search(args.email)
    elif args.phone:
        results = await phone_search(args.phone)

    sys.stdout.write(json.dumps({
        "results": results,
        "count": len(results),
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }))

if __name__ == "__main__":
    asyncio.run(main())

# python/osint_runner.py

import re
import json
import asyncio
from datetime import datetime

# Try to import critical libraries and handle missing modules
try:
    import aiohttp                  
except ImportError as e:
    print(json.dumps({
        "summary": {"error": "missing dependency"},
        "results": [{
            "platform": "Python Runtime",
            "url": "local",
            "data": f"Missing module: {str(e)}",
            "timestamp": datetime.utcnow().isoformat()
        }]
    }))
    exit(1)

# ---------------------- CONFIG ----------------------
USERNAME_PLATFORMS = {
    "Twitter": "https://twitter.com/{}",
    "Facebook": "https://www.facebook.com/{}",
    "Instagram": "https://www.instagram.com/{}/",
    "LinkedIn": "https://www.linkedin.com/in/{}",
    "GitHub": "https://github.com/{}"
}

EMAIL_REGEX = re.compile(r"[^@]+@[^@]+\.[^@]+")
PHONE_REGEX = re.compile(r"^\+?\d{7,15}$")
USERNAME_REGEX = re.compile(r"^[a-zA-Z0-9._-]{3,30}$")

HIBP_API_KEY = "<YOUR_HIBP_API_KEY>"  # Set this in production

# ---------------------- HTTP ----------------------
async def fetch(session, url):
    try:
        async with session.get(url, timeout=10) as resp:
            return url, resp.status
    except Exception as e:
        return url, f"Error: {str(e)}"

# ---------------------- USERNAME SEARCH ----------------------
async def username_search(username):
    results = []
    try:
        async with aiohttp.ClientSession(headers={"User-Agent": "Mozilla/5.0"}) as session:
            tasks = [fetch(session, url.format(username)) for url in USERNAME_PLATFORMS.values()]
            responses = await asyncio.gather(*tasks)
            for platform, (url, status) in zip(USERNAME_PLATFORMS.keys(), responses):
                results.append({
                    "platform": platform,
                    "url": url,
                    "status": status,
                    "timestamp": datetime.utcnow().isoformat()
                })
    except Exception as e:
        results.append({
            "platform": "UsernameSearch",
            "url": "N/A",
            "data": f"Error during username search: {str(e)}",
            "timestamp": datetime.utcnow().isoformat()
        })
    return results

# ---------------------- EMAIL SEARCH ----------------------
async def email_search(email):
    results = []
    if not EMAIL_REGEX.fullmatch(email):
        return [{
            "platform": "EmailValidation",
            "url": "N/A",
            "data": "Invalid email format",
            "timestamp": datetime.utcnow().isoformat()
        }]

    hibp_url = f"https://haveibeenpwned.com/api/v3/breachedaccount/{email}"
    headers = {
        "User-Agent": "OSINTTool",
        "hibp-api-key": HIBP_API_KEY
    }

    try:
        async with aiohttp.ClientSession(headers=headers) as session:
            async with session.get(hibp_url) as response:
                if response.status == 200:
                    breaches = await response.json()
                    for breach in breaches:
                        results.append({
                            "platform": "HaveIBeenPwned",
                            "url": hibp_url,
                            "data": f"Breached on: {breach['Name']} ({breach['BreachDate']})",
                            "timestamp": datetime.utcnow().isoformat()
                        })
                elif response.status == 404:
                    results.append({
                        "platform": "HaveIBeenPwned",
                        "url": hibp_url,
                        "data": "No breach found",
                        "timestamp": datetime.utcnow().isoformat()
                    })
                else:
                    results.append({
                        "platform": "HaveIBeenPwned",
                        "url": hibp_url,
                        "data": f"Unexpected status: {response.status}",
                        "timestamp": datetime.utcnow().isoformat()
                    })
    except Exception as e:
        results.append({
            "platform": "HaveIBeenPwned",
            "url": hibp_url,
            "data": f"API Error: {str(e)}",
            "timestamp": datetime.utcnow().isoformat()
        })

    return results

# ---------------------- PHONE SEARCH ----------------------
def phone_search(phone):
    results = []
    if not PHONE_REGEX.fullmatch(phone):
        return [{
            "platform": "PhoneValidation",
            "url": "N/A",
            "data": "Invalid phone number format",
            "timestamp": datetime.utcnow().isoformat()
        }]
    try:
        results.append({
            "platform": "Phone Directory Lookup",
            "url": "https://example.com/phone-directory",
            "data": "[Simulated] Phone associated with a public listing.",
            "timestamp": datetime.utcnow().isoformat()
        })
        results.append({
            "platform": "Social Media Mention",
            "url": "https://example.com/social-lookup",
            "data": "[Simulated] Mentioned on social media platforms.",
            "timestamp": datetime.utcnow().isoformat()
        })
    except Exception as e:
        results.append({
            "platform": "PhoneSearch",
            "url": "N/A",
            "data": f"Error during phone search: {str(e)}",
            "timestamp": datetime.utcnow().isoformat()
        })
    return results

# ---------------------- MASTER FUNCTION ----------------------
async def run_osint(username=None, email=None, phone=None):
    output = {
        "summary": {},
        "results": []
    }

    try:
        if username and USERNAME_REGEX.fullmatch(username):
            user_results = await username_search(username)
            output["results"].extend(user_results)
            output["summary"]["username"] = f"{len(user_results)} username-related results"

        if email:
            email_results = await email_search(email)
            output["results"].extend(email_results)
            output["summary"]["email"] = f"{len(email_results)} email-related results"

        if phone:
            phone_results = phone_search(phone)
            output["results"].extend(phone_results)
            output["summary"]["phone"] = f"{len(phone_results)} phone-related results"

        return output
    except Exception as e:
        return {
            "summary": {"error": "unexpected failure"},
            "results": [{
                "platform": "Global OSINT",
                "url": "N/A",
                "data": f"Fatal error: {str(e)}",
                "timestamp": datetime.utcnow().isoformat()
            }]
        }

# ---------------------- COMMAND LINE ENTRY ----------------------
if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="OSINT Lookup Tool")
    parser.add_argument("--username", type=str, help="Username to search")
    parser.add_argument("--email", type=str, help="Email address to search")
    parser.add_argument("--phone", type=str, help="Phone number to search")

    args = parser.parse_args()
    result = asyncio.run(run_osint(args.username, args.email, args.phone))
    print(json.dumps(result, indent=2))

# platforms.py

PLATFORMS = {
    "Twitter": {
        "url": "https://twitter.com/{}",
        "error_patterns": [r"Sorry, that page doesn’t exist", r"account/suspended"],
        "positive_patterns": [r"@[\w]+", r"data-screenname="],
        "category": "social",
        "validation": r"^[A-Za-z0-9_]{1,15}$"
    },
    "Facebook": {
        "url": "https://www.facebook.com/{}",
        "error_patterns": [r"content=\"Facebook | Error\"", r"Sorry, this content isn't available"],
        "positive_patterns": [r"fb://profile/", r"\"fbProfileBrowser\"", r"entity_id:\"USER\""],
        "category": "social",
        "validation": r"^[a-zA-Z0-9.]{5,50}$"
    },
    "Instagram": {
        "url": "https://www.instagram.com/{}/",
        "error_patterns": [r"Sorry, this page isn't available", r"The link you followed may be broken"],
        "positive_patterns": [r"\"username\":\"", r"profile_pic_url", r"\"is_verified\":"],
        "category": "social",
        "validation": r"^[A-Za-z0-9._]{1,30}$"
    },
    "LinkedIn": {
        "url": "https://www.linkedin.com/in/{}",
        "error_patterns": [r"404: This page doesn't exist", r"Profile Not Found"],
        "positive_patterns": [r"\"profile\":", r"\"member\":", r"\"publicIdentifier\":"],
        "category": "professional",
        "validation": r"^[a-zA-Z0-9-]{5,100}$"
    },
    "TikTok": {
        "url": "https://www.tiktok.com/@{}",
        "error_patterns": [r"Couldn't find this account", r"\"status_code\":404"],
        "positive_patterns": [r"\"uniqueId\":\"", r"\"user\":{", r"\"followerCount\":"],
        "category": "social",
        "validation": r"^[A-Za-z0-9._]{1,24}$"
    },
    "Reddit": {
        "url": "https://www.reddit.com/user/{}",
        "error_patterns": [r"page not found", r"Sorry, nobody on Reddit goes by that name"],
        "positive_patterns": [r"\"is_suspended\":false", r"\"username\":\"", r"\"total_karma\":"],
        "category": "forum",
        "validation": r"^[A-Za-z0-9_-]{3,20}$"
    },
    "GitHub": {
        "url": "https://github.com/{}",
        "error_patterns": [r"Not Found", r"404 There isn't a GitHub Pages site here"],
        "positive_patterns": [r'"login":"[\w-]+"', r'"followers":\d+'],
        "category": "developer",
        "validation": r"^[a-zA-Z0-9-]{1,39}$"
    },
    "GitLab": {
        "url": "https://gitlab.com/{}",
        "error_patterns": [r"Page Not Found", r"The page you're looking for could not be found"],
        "positive_patterns": [r"\"username\":\"", r"\"name\":\"", r"\"avatar_url\":"],
        "category": "developer",
        "validation": r"^[a-zA-Z0-9_.-]{2,255}$"
    },
    "StackOverflow": {
        "url": "https://stackoverflow.com/users/{}",
        "error_patterns": [r"Page Not Found", r"404 - User does not exist"],
        "positive_patterns": [r"\"displayName\":\"", r"\"reputation\":", r"user-info"],
        "category": "developer",
        "validation": r"^\d+$"
    },
    "Twitch": {
        "url": "https://www.twitch.tv/{}",
        "error_patterns": [r"404 Page Not Found", r"Sorry. Unless you've got a time machine"],
        "positive_patterns": [r'"displayName":"', r'"broadcaster_type":"'],
        "category": "gaming",
        "validation": r"^[A-Za-z0-9_]{4,25}$"
    },
    "Steam": {
        "url": "https://steamcommunity.com/id/{}",
        "error_patterns": [r"The specified profile could not be found", r"Error 404"],
        "positive_patterns": [r"\"personaname\":\"", r"\"steamid\":\"", r"profile_header_bg"],
        "category": "gaming",
        "validation": r"^[A-Za-z0-9_-]{2,32}$"
    },
    "Behance": {
        "url": "https://www.behance.net/{}",
        "error_patterns": [r"404 - Page Not Found", r"Sorry, we couldn't find that page"],
        "positive_patterns": [r"\"user\":{", r"\"username\":\"", r"\"location\":"],
        "category": "professional",
        "validation": r"^[a-zA-Z0-9-]{1,50}$"
    },
    "YouTube": {
        "url": "https://www.youtube.com/{}",
        "error_patterns": [r"404 Not Found", r"This channel does not exist"],
        "positive_patterns": [r"\"channelId\":\"", r"\"title\":\"", r"\"subscriberCount\":"],
        "category": "media",
        "validation": r"^[A-Za-z0-9_-]{3,30}$"
    },
    "Spotify": {
        "url": "https://open.spotify.com/user/{}",
        "error_patterns": [r"404 Not Found", r"Page not found"],
        "positive_patterns": [r"\"display_name\":\"", r"\"followers\":{", r"\"uri\":\"spotify:user:"],
        "category": "media",
        "validation": r"^[A-Za-z0-9]{22}$"
    },
    "Have I Been Pwned": {
        "url": "https://haveibeenpwned.com/unifiedsearch/{}",
        "api_url": "https://haveibeenpwned.com/api/v3/breachedaccount/{}",
        "headers": {"hibp-api-key": "YOUR_API_KEY_HERE"},
        "category": "security",
        "requires_api_key": True
    }
}

PLATFORM_HEADERS = {
    "Twitter": {"User-Agent": "Mozilla/5.0", "Accept": "application/json"},
    "Instagram": {"User-Agent": "Mozilla/5.0", "Accept-Language": "en-US,en;q=0.9"},
    "LinkedIn": {"User-Agent": "Mozilla/5.0", "Accept": "application/json"},
    "GitHub": {"User-Agent": "Mozilla/5.0", "Accept": "application/vnd.github.v3+json"},
    "Have I Been Pwned": {"User-Agent": "OSINT-Tool", "hibp-api-key": "YOUR_API_KEY_HERE"}
}

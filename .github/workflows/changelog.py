import os
import sys

import requests
from datetime import datetime, timedelta, timezone
from typing import Union, Any, Optional, TYPE_CHECKING, cast

# Set up your personal access token and the repository details
token = os.environ.get('GH_TOKEN')
repo_owner = "bitlytwiser"
repo_name = "nostro"

# Get last two commits from main branch and compare. (Note: If this is the first commit ever, it would break until a 2nd commit is made)
def print_stable_changelog() -> None:
    latest, second = get_last_two_commits()
    url = f"compare/{second}...{latest}"
    commits = handle_get_request(url)
    if commits is None:
        return None

    for commit in commits["commits"]:
        # Print the commit details
        print(format_output(commit))

def get_last_two_commits() -> tuple[str, str] | tuple[None, None]:
    headers = {} if token is None else {"Authorization": f"Bearer {token}"}
    url_base = f"https://api.github.com/repos/{repo_owner}/{repo_name}/commits?per_page=2&sha=main"
    response = requests.get(url_base, headers=headers)

    if response.status_code == 200:
        data = response.json()
        if len(data) >= 2:
            latest_commit_sha = data[0]["sha"]
            previous_commit_sha = data[1]["sha"]
            return latest_commit_sha, previous_commit_sha
        else:
            print("Not enough commits found.")
            return None, None
    else:
        print(f"Request failed with status code: {response.status_code}")
        return None, None

def handle_get_request(path: str, offset=None) -> Any | None:
    headers = {} if token == None else {"Authorization": f"Bearer {token}"}
    params = {"since": offset}
    url_base = f"https://api.github.com/repos/{repo_owner}/{repo_name}/"
    response = requests.get(url_base + path, headers=headers, params=params)

    if response.status_code == 200:
        return response.json()
    else:
        print(f"Request failed with status code: {response.status_code}")
    return None


def format_output(commit):
    message_lines = commit["commit"]["message"].split("\n")
    author = commit["author"]["login"] if commit["author"] and "login" in commit["author"] else commit["commit"]["author"]["name"]
    return '- ' + commit["sha"][:8] + ' - @' + author + ': ' + message_lines[0]

print_stable_changelog()
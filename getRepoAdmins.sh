#!/bin/bash

TOKEN=TOKEN
ORG="blw-ofag-ufag"
OUTFILE="blw_github_repo_admins.txt"

{
  # Timestamp for the run
  echo "Run timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
  echo

  # Get repository names if the repo has not been archived
  curl -s -H "Authorization: token $TOKEN" \
       -H "Accept: application/vnd.github+json" \
       "https://api.github.com/orgs/$ORG/repos?per_page=100" |
  jq -r '.[] | select(.archived == false) | .name' |

  while IFS= read -r repo; do

    admins=$(curl -s -H "Authorization: token $TOKEN" \
      -H "Accept: application/vnd.github+json" \
      "https://api.github.com/repos/$ORG/$repo/collaborators?affiliation=direct" |
      jq -r '[ .[] | select(.permissions.admin == true) | .login ] | join(", ")')

    # Only output repos with admins
    if [[ -n "$admins" ]]; then
      echo "$repo : [$admins]"
      echo "----------------"
    fi

  done

  echo
  echo
  echo "############"
  echo

} >> "$OUTFILE"
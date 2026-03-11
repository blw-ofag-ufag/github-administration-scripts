#!/bin/bash
TOKEN=TOKEN
ORG="blw-ofag-ufag"
OUTFILE="blw_github_org_owners.txt"

{
  # Timestamp for the run
  echo "Run timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
  echo

  curl -s -H "Authorization: token $TOKEN" \
       -H "Accept: application/vnd.github+json" \
       "https://api.github.com/orgs/blw-ofag-ufag/members?role=admin" | 
  jq -r '.[].login'

  echo
  echo
  echo "############"
  echo

} >> "$OUTFILE"

#!/bin/bash

# Get all version IDs regardless of serving status
versions=$(gcloud app versions list --format="value(version.id)")

# Exit if no versions found
if [ -z "$versions" ]; then
  echo "No versions found to delete."
  exit 0
fi

# Show and confirm
echo "The following versions will be deleted:"
echo "$versions"

read -p "Are you sure you want to delete all versions? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Aborted."
  exit 1
fi

# Delete all versions
gcloud app versions delete $versions --quiet

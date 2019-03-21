#!/usr/bin/env bash
# Example usage: ./search-inline-policies.sh searchterm output.txt
set -e
set -o pipefail

echo "Finding roles with inline policies that match: $1"
echo "Putting results in file: $2"
echo

echo "Loading roles..."

role_names=( $(aws iam list-roles | jq -r .Roles[].RoleName) )

echo "Loaded ${#role_names[@]} roles."
echo

matched_role_names=()

for role_name in ${role_names[@]}; do
  echo "Loading inline policies for role: $role_name"

  role_policy_names=( $(aws iam list-role-policies --role-name $role_name | jq -r .PolicyNames[]) )

  echo "Loaded ${#role_policy_names[@]} inline policies."

  for role_policy_name in ${role_policy_names[@]}; do
    policy_document=$(aws iam get-role-policy --role-name $role_name --policy-name $role_policy_name | jq .PolicyDocument)

    if echo "$policy_document" | grep -q "$1"; then
      echo "Match found in policy: $role_policy_name"
      matched_role_names+=( $role_name )
    else
      echo "Nothing found in policy: $role_policy_name"
    fi
  done

  echo
done

echo "Matches found in ${#matched_role_names[@]} roles."
echo

echo "Writing matched roles to file..."

printf '%s\n' "${matched_role_names[@]}" > $2

echo "Done!"

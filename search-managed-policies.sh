#!/usr/bin/env bash
# Example usage: ./search-managed-policies.sh searchterm output.txt
set -e
set -o pipefail

echo "Finding managed policies that match: $1"
echo "Putting results in file: $2"
echo

echo "Loading managed policies..."

policies=$(aws iam list-policies --scope Local)
policy_arns=( $(echo $policies | jq -r .Policies[].Arn) )
policy_versions=( $(echo $policies | jq -r .Policies[].DefaultVersionId) )
policy_names=( $(echo $policies | jq -r .Policies[].PolicyName) )

echo "Loaded ${#policy_arns[@]} managed policies."
echo

matched_policy_names=()

for i in ${!policy_arns[@]}; do
  policy_document=$(aws iam get-policy-version --policy-arn ${policy_arns[$i]} --version-id ${policy_versions[$i]} | jq .PolicyVersion.Document)

  if echo "$policy_document" | grep -q "$1"; then
    echo "Match found in policy: ${policy_names[$i]}"
    matched_policy_names+=( ${policy_names[$i]} )
  else
    echo "Nothing found in policy: ${policy_names[$i]}"
  fi
done

echo "Matches found in ${#matched_policy_names[@]} policies."
echo

echo "Writing matched policies to file..."

printf '%s\n' "${matched_policy_names[@]}" > $2

echo "Done!"

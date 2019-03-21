# iam-policy-document-search

Bash scripts to help search all IAM policy documents in an AWS account.

Useful for searching for things like depreciated ARN formats.

Searches the policy documents using `grep`.

## Example Usage

```bash
$ ./search-inline-policies.sh "arn:aws:ecs:.*:.*:task/.*" output-file
```

```bash
$ ./search-managed-policies.sh "arn:aws:ecs:.*:.*:task/.*" output-file
```

Please review each of the following PRs:
$ARGUMENTS

If no PRs were provided above, use this default list:
https://github.com/givecampus/givecampus/pulls?q=is%3Aopen+is%3Apr+label%3Aplatform-team+-label%3Aready-to-merge+-assignee%3Aredodson01+draft%3Afalse

For each PR:
1. If I (@redodson01) have _not_ already reviewed it, then please review it.
2. If I (@redodson01) have already reviewed it, and the PR has new commits since my last review (compare my latest review's `commit_id` to the PR's current HEAD SHA — do not use `committedDate` or any timestamp), then please re-review it.
3. If I (@redodson01) have already reviewed it, and the PR's HEAD SHA matches my latest review's `commit_id`, then please skip it.

Before drafting any feedback, list which PRs you're reviewing vs. skipping, with the reason for each skip.

Provide your feedback to me here and **wait for my explicit go-ahead before posting anything to a PR.** Categorize each piece of review feedback using these tags:

- `[blocking]` — would cause real harm if merged: CI failure, broken correctness, security issue, data loss, broken contract.
- `[non-blocking]` — has a real-world consequence the author should know about: behavior change worth documenting, observability gap, future-maintenance hook, missing test for an actually-risky path.
- `[non-blocking] Nit:` — pure style or preference, no consequence beyond aesthetics.

**Always include nits in the draft feedback you show me here, but by default exclude them from the review you post on the PR.** If I want them included, I'll say so explicitly (e.g., "post everything including nits").

Please include a table that summarizes your feedback and includes the following items:
1. Linear ticket ID (e.g., PLA-XXXX) — extract from the PR title; fall back to the PR body or branch name; use "N/A" if no ticket is associated.
2. GitHub PR author (e.g., @redodson01)
3. GitHub PR ID (e.g., #XXXXX)
4. Recommended interaction type (Approve / Comment / Request Changes)

Recommend the interaction type using this rule (nits don't affect it — they're still non-blocking):
- **Approve** — all feedback is [non-blocking] (or there's no feedback at all).
- **Request Changes** — at least one [blocking] item would cause real harm if merged.
- **Comment** — everything else with at least one [blocking] item. The author must fix the items, but a formal merge block isn't necessary.

When you post the review, use the matching `gh pr review` flag (`--approve`, `--request-changes`, or `--comment`). If you're approving with no feedback, leave the body empty.

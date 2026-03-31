Please review each of the following PRs:
$ARGUMENTS

If no PRs were provided above, use this default list:
https://github.com/givecampus/givecampus/pulls?q=is%3Aopen+is%3Apr+label%3Aplatform-team+-label%3Aready-to-merge+-assignee%3Aredodson01+draft%3Afalse

## Triage

For each PR:
1. If I (@redodson01) have _not_ already reviewed it, then please review it.
2. If I (@redodson01) have already reviewed it, and the PR has new commits since my last review (compare my latest review's `commit_id` to the PR's current HEAD SHA; do not use `committedDate` or any timestamp), then please re-review it.
3. If I (@redodson01) have already reviewed it, and the PR's HEAD SHA matches my latest review's `commit_id`, then please skip it.

Before drafting any feedback, list which PRs you're reviewing vs. skipping, with the reason for each skip. For each PR you're re-reviewing, also note in one line what changed since your last review.

## Review criteria

Assess each PR against the same criteria and severity taxonomy as the `/review` command, so that my own PRs and others' are held to one standard. Read `~/.claude/commands/review.md` and apply its Correctness, Housekeeping, and History questions as your review lens, and its severity taxonomy (`[blocking]` / `[non-blocking]` / `[nit]` / `[observation]`) to classify each finding. Ignore only its mechanics: its base-ref/`git diff` steps (here you review the PR diff via `gh`, delta-scoped as described below) and its standalone reporting format. Use the posting, dedupe, and interaction-type rules defined below instead.

## What to post

Classify each finding with the shared severity taxonomy from `/review`. Where each level goes:

- **[blocking]** and **[non-blocking]** — in the posted review body (not draft-only), subject to the dedupe rule below (only NEW items are posted).
- **[nit]** — always in the draft you show me here, but by default excluded from the posted review. If I want them included, I'll say so explicitly (e.g., "post everything including nits").
- **[observation]** — draft only by default; include in the posted body only when it's genuinely useful context for the author.

## Dedupe against existing feedback

**Before drafting feedback on any PR, load the existing conversation and dedupe against it.** For each PR, fetch: your own prior reviews (bodies + inline comments), other reviewers' reviews/comments (human and bot: Superagent, Linear, CodeRabbit), and the author's replies.

Then, when drafting:
- **Scope a re-review to the delta.** Review only what changed since your last review (`<your-last-commit_id>..HEAD`), and separate the author's own commits from merged-in base changes. Do not re-derive feedback from the whole diff.
- **Do not re-raise a concern that already exists** (yours or anyone else's) at the same code location and concern, regardless of phrasing. If you agree with an open point someone else raised, don't restate it.
- **Do not re-raise a resolved or acknowledged item.** If a prior item was fixed, or the author responded / deferred / documented it (including in the PR body), leave it out. Confirm a resolution at most once in the summary, never as a standing feedback item.
- A concern you already voiced and the author consciously declined is closed for re-review purposes; reopen it only if new commits made it materially worse.

Tag each drafted item as **NEW**, **ALREADY-RAISED** (by whom), or **RESOLVED**. Only post NEW items as feedback body. If a re-review surfaces nothing new and no prior blocker is still open, say so and recommend a bare Approve (empty body) rather than re-posting prior notes.

## Report back

Provide your feedback to me here and **wait for my explicit go-ahead before posting anything to a PR.**

Please include a table that summarizes your feedback and includes the following items:
1. Linear ticket ID (e.g., PLA-XXXX): extract from the PR title; fall back to the PR body or branch name; use "N/A" if no ticket is associated.
2. GitHub PR author (e.g., @redodson01)
3. GitHub PR ID (e.g., #XXXXX)
4. Recommended interaction type (Approve / Comment / Request Changes)

## Interaction type

Recommend the interaction type using these rules (nits and observations never affect it):

- **Request Changes** — there is at least one [blocking] item (new, or already-raised and still unresolved). Blocking feedback must block the merge, so it always maps to Request Changes. You needn't restate an already-raised blocker beyond a one-line "the blocking item from my prior review is still unresolved."
- **Comment** — no blocking feedback, but you have a question for the author whose answer might change your assessment. Use this to withhold approval pending the answer.
- **Approve** — no blocking feedback and no open question: all feedback is [non-blocking], [nit], or [observation], or there's none.

## Posting

When you post the review, use the matching `gh pr review` flag (`--approve`, `--request-changes`, or `--comment`). If you're approving with no feedback, leave the body empty.

Immediately before posting, re-fetch each PR's current HEAD SHA: a review attaches to whatever HEAD is current at post time, so on a fast-moving PR you can end up formally approving commits you never saw. If HEAD moved past the SHA you reviewed, inspect the new commits: if they're only staging-merge/rebase noise (same author content re-parented), proceed; if the author pushed genuinely new content, re-review that delta and re-confirm your recommendation before posting.

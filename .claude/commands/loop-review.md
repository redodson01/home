Run an iterative review loop on the current branch. Each review pass is delegated to a sub-agent with no prior context, ensuring thoroughness is not compromised by convergence bias.

Base ref: $ARGUMENTS

(If no base ref was provided, use `origin/main` or `origin/master` — whichever exists.)

## Step 0: Gather context

Before starting the loop:

1. Check for uncommitted changes (`git status`). If there are staged or unstaged changes, warn the user and stop.

2. Resolve the base ref (from `$ARGUMENTS`, or `origin/main`/`origin/master` if not provided). If it refers to a remote-tracking branch, fetch it:

```
git fetch <remote> <branch>
```

To determine whether to fetch: check if the ref is prefixed with a configured remote name (from `git remote`) followed by `/` (e.g., `origin/main`, `upstream/develop`). If so, extract the remote and branch name and fetch it. Otherwise (e.g., a commit SHA, a tag, or a bare branch name), skip the fetch.

3. Check whether the current branch has an open PR:

```
gh pr list --head <current-branch> --json number,url --jq '.[0]'
```

If a PR exists, note its number and URL for use in sub-agent prompts.

4. Identify the project's test command and lint/format command. Check CLAUDE.md first, then fall back to `Makefile` or `package.json`. If either is not found, skip the corresponding gate.

5. Read the contents of the `/review` command file. Check `.claude/commands/review.md` (project-level) first, then `~/.claude/commands/review.md` (user-level) — matching Claude Code's command resolution order. These contents are used as the base prompt for every sub-agent in Step 1. If neither file exists, inform the user and stop.

6. Check whether the branch has any changes relative to the base ref: `git diff <base-ref>..HEAD --quiet`. If there are no changes, inform the user and stop — there is nothing to review.

Repeat the following cycle up to 5 times. If all 5 passes are exhausted and the final pass still produces [action required] items, report the remaining unresolved items to the user and stop — do not silently terminate.

## Step 1: Review (sub-agent)

Use the **Agent tool** to spawn a sub-agent whose prompt is the contents of `review.md` (read in Step 0).

If Step 0 found an open PR, also append:

> This branch has an open PR: #NUMBER (URL). Fetch the PR description with `gh pr view` and include it in your review.

Replace the literal string `$ARGUMENTS` in the review prompt with the resolved base ref (e.g., `origin/main`). Do NOT use the Skill tool — that executes in the main conversation and defeats the isolation. The sub-agent must perform the review independently — do not prime it with context from prior passes.

On pass 2+, if prior passes created fixup commits, also append:

> Note: `fixup!` commits in the history are pending rebase — do not flag them as commit history issues.

## Step 2: Evaluate results

The sub-agent will return a review report containing a list of items. Report a brief status update to the user: the pass number, how many [action required] and [observation] items were found, and whether you're proceeding to resolve or terminating. Example: "Pass 1: 2 action items, 3 observations. Resolving." or "Pass 2: 0 action items, 1 observation. Review loop complete."

Track evaluated items across passes. On pass 2+, deduplicate against previously-evaluated items by code location and concern, not exact phrasing.

- If the sub-agent found **no new [action required] items** (after filtering out previously-evaluated items), report that the review loop is complete. Include a brief summary of any observations so the user has visibility into what was reviewed, then stop.
- If the sub-agent found **any new [action required] items**, proceed to step 3. Observations do not require resolution and do not prevent the loop from terminating.

## Step 3: Resolve action items

For each **[action required]** item, **verify the correct resolution before making changes**. Do not blindly apply the sub-agent's suggestion — the sub-agent is flagging potential issues, but you (the orchestrator) must determine the right fix. Check the source of truth (project config, standards docs, existing code conventions) to confirm what the correct behavior should be, then apply the fix accordingly.

Resolution means one of:

1. **Fix it** — apply the correct change. This may be a code change or a non-code artifact (PR description via `gh pr edit`, CI config, etc.).
2. **Dismiss it** — if, after verification, the item is actually an observation (reviewer over-weighted a concern, code is correct) or is based on a factual error (reviewer misread the code). Reclassify as an [observation]. Verify carefully before concluding this.

Resolve every [action required] item from the sub-agent's report. If any resolutions produced code changes, run the lint/format command identified in Step 0, re-stage any files modified by the formatter, then run the test command — all **before committing**. If tests fail, fix regressions before committing — do not create broken commits. If test failures appear unrelated to the review changes, note them and proceed.

Once tests pass (or no tests are affected), stage the changed files and commit using `git commit --fixup=<sha>`, where `<sha>` is the original commit each fix logically belongs to. If a fix doesn't map to a specific original commit, use `--fixup` targeting the most relevant one. This enables automatic history cleanup in Step 4.

## Step 4: Clean up commit history

Once the loop terminates (no [action required] items remain), check whether any fixup commits were created during the loop. If none were created (all resolutions were non-code changes or the first pass found no action items), skip this step.

If fixup commits exist, squash them into the original commits they belong to using non-interactive autosquash rebase:

```
GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <base-ref>
```

If the rebase fails with merge conflicts, abort it (`git rebase --abort`) and inform the user — let them resolve manually rather than risking a bad rebase.

After rebasing, inform the user that the branch has diverged from the remote and a force-push (`git push --force-with-lease`) is needed. Do not force-push automatically — let the user decide when to push.

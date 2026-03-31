Run an iterative review loop on the current branch, then resolve the findings. Each review pass is delegated to a sub-agent with no prior context, so thoroughness isn't compromised by convergence bias. This command owns the full cycle: review (plus any existing PR feedback) → resolve → commit as fixups → squash. Do not report it complete until the Completion gate at the bottom is satisfied.

Base ref: $ARGUMENTS

(If no base ref was provided, use `origin/main` or `origin/master`, whichever exists.)

## Step 0: Gather context

Before starting the loop:

1. Check for uncommitted changes (`git status`). If there are staged or unstaged changes, warn the user and stop. This loop commits as it goes and must start from a clean tree. (If a prior run was interrupted mid-resolution, commit, stash, or discard the leftover changes, then re-run.)

2. Resolve the base ref (from `$ARGUMENTS`, or `origin/main`/`origin/master` if not provided). If it refers to a remote-tracking branch, fetch it:

```
git fetch <remote> <branch>
```

To determine whether to fetch: check if the ref is prefixed with a configured remote name (from `git remote`) followed by `/` (e.g., `origin/main`, `upstream/develop`). If so, extract the remote and branch name and fetch it. Otherwise (e.g., a commit SHA, a tag, or a bare branch name), skip the fetch.

3. Check whether the current branch has an open PR:

```
gh pr list --head <current-branch> --json number,url --jq '.[0]'
```

If a PR exists, note its number and URL for use in sub-agent prompts, and gather its existing feedback for the orchestrator to triage in Step 2: reviews, inline comments, bot findings (Superagent, CodeRabbit, etc.), and author replies. This is orchestrator-only context: do NOT include it in the sub-agent's prompt, so the fresh review stays independent.

4. Identify the project's test command and lint/format command. Check CLAUDE.md first, then fall back to `Makefile` or `package.json`. If either is not found, skip the corresponding gate.

5. Read the contents of the `/review` command file. Check `.claude/commands/review.md` (project-level) first, then `~/.claude/commands/review.md` (user-level), matching Claude Code's command resolution order. These contents are the base prompt for every sub-agent in Step 1, and they define the severity taxonomy this loop keys off (see Step 2). If neither file exists, inform the user and stop.

6. Check whether the branch has any changes relative to the base ref: `git diff <base-ref>...HEAD --quiet` (three-dot, from the merge-base). If there are no changes, inform the user and stop: there is nothing to review.

7. **Resume check.** Inspect the history in `<base-ref>..HEAD` for `fixup!` commits. If any exist, a prior loop was interrupted before cleanup. That's fine: leave them in place, don't flag them as history issues, and the Cleanup phase will squash them along with any new ones.

Repeat Steps 1–3 up to 5 times, then run Cleanup. Termination is described in Step 2.

## Step 1: Review (sub-agent)

Use the **Agent tool** to spawn a sub-agent whose prompt is the contents of `review.md` (read in Step 0).

If Step 0 found an open PR, also append:

> This branch has an open PR: #NUMBER (URL). Fetch the PR description with `gh pr view` and include it in your review.

Replace the literal string `$ARGUMENTS` in the review prompt with the resolved base ref (e.g., `origin/main`). Do NOT use the Skill tool. That executes in the main conversation and defeats the isolation. The sub-agent must perform the review independently. Do not prime it with context from prior passes.

On pass 2+, if prior passes created fixup commits, also append:

> Note: `fixup!` commits in the history are pending rebase. Do not flag them as commit history issues.

## Step 2: Evaluate results

The sub-agent returns a report whose findings are tagged with the shared severity taxonomy from `/review`: **[blocking]**, **[non-blocking]**, **[nit]**, **[observation]**. Treat them as:

- **[blocking]** and **[non-blocking]** — *actionable*. These drive resolution (Step 3) and keep the loop running.
- **[nit]** and **[observation]** — *report-only*. Never auto-resolved, and never keep the loop running. Collect them to report at the end. (If the user explicitly asks for nits to be applied, fold them into Step 3 for that run.)

**On the first pass only, fold in the existing PR feedback gathered in Step 0** (skip if the branch has no PR). Treat each piece (human reviews, inline comments, bot findings, author replies) as a candidate finding, but verify before trusting it:

- **Verify against current code.** Drop anything already addressed by a later commit, based on code that has since changed, or simply incorrect, with a one-line note.
- **Dedupe** surviving items against the sub-agent's findings (by location + concern) so nothing is handled twice.
- **Classify** each with the shared taxonomy, then route it:
  - *Clear-cut and code-level* — a real bug or omission a reviewer caught, where the fix is unambiguous: treat as an actionable finding and resolve it in Step 3, noting that it originated from PR feedback.
  - *Judgment call, reviewer intent, a question or discussion, or something you'd recommend declining* — do NOT auto-act. Hold it for the Completion gate as a recommendation for the user (address / decline-with-reason / needs-a-reply).

When you decide not to act on a human reviewer's comment, that's the user's call to make and possibly reply to: surface it, never silently dismiss it.

Report a brief status update: the pass number, counts by level, and whether you're resolving or terminating. Example: "Pass 1: 1 blocking, 2 non-blocking, 3 nits, 1 observation. Resolving actionable items." or "Pass 2: 0 new actionable items. Proceeding to Cleanup."

Track evaluated items across passes. On pass 2+, deduplicate against previously-evaluated items by code location and concern, not exact phrasing. If a new finding would reverse or re-litigate a change you made in an earlier pass, do not auto-apply it: treat it as a judgment call and report it, rather than oscillate.

- If the pass found **no new actionable ([blocking]/[non-blocking]) items** (after filtering previously-evaluated ones), the review loop is done: proceed to Cleanup.
- If the pass found **any new actionable items**, proceed to Step 3, then loop back to Step 1 (until 5 passes are exhausted).

If all 5 passes are exhausted and actionable items still remain unresolved, do not silently stop: carry them into the Completion gate and report them.

## Step 3: Resolve actionable items

For each **[blocking]** and **[non-blocking]** item, **verify the correct resolution before making changes.** Do not blindly apply the sub-agent's suggestion: it flags potential issues, but you (the orchestrator) determine the right fix. Check the source of truth (project config, standards docs, existing code conventions) to confirm what the correct behavior should be, then apply the fix accordingly.

Resolution means one of:

1. **Fix it** — apply the correct change. This may be a code change or a non-code artifact (PR description via `gh pr edit`, CI config, etc.).
2. **Dismiss it** — if, after verification, the item is based on a factual error (reviewer misread the code) or is overweighted (the code is actually correct), reclassify it as an **[observation]** with a one-line reason. Verify carefully before concluding this.

A [blocking] item must end as fixed or dismissed-with-reason, never left open. Resolve every actionable item from the report.

If any resolutions produced code changes: run the lint/format command from Step 0, re-stage any files the formatter modified, then run the test command, all **before committing.** If tests fail, fix the regressions before committing. Do not create broken commits. If test failures appear unrelated to the review changes, note them and proceed.

Once tests pass (or no code changed), stage the changed files and commit using `git commit --fixup=<sha>`, where `<sha>` is the original commit each fix logically belongs to. If a fix doesn't map to a specific original commit, use `--fixup` targeting the most relevant one. This sets up the Cleanup phase.

## Cleanup: squash the fixups

Once the loop terminates, squash every `fixup!` commit in `<base-ref>..HEAD` (including any left over from an interrupted prior run) into the commits they belong to, using a non-interactive autosquash rebase:

```
GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <base-ref>
```

If there are no fixup commits at all (nothing needed changing), skip this step. If the rebase fails with merge conflicts, abort it (`git rebase --abort`) and inform the user: let them resolve manually rather than risking a bad rebase.

After a successful rebase, inform the user that the branch has diverged from the remote and a force-push (`git push --force-with-lease`) is needed. Do not force-push automatically. Let the user decide when to push.

## Completion gate

Do not report the loop complete until all of these hold. If any cannot be met, stop and report exactly what remains and why:

- Every [blocking] and [non-blocking] item found across all passes is fixed or explicitly dismissed with a reason.
- No uncommitted changes remain: every fix committed as a `fixup!` commit.
- Lint/format and tests pass on the final state: the Step 3 run covers this, since autosquash doesn't change the final tree, so no re-run is needed unless a rebase conflict was resolved.
- All `fixup!` commits have been squashed (history is clean), unless a rebase conflict forced a stop, in which case say so.
- Remaining [nit] and [observation] items are listed for the user.
- If the branch has a PR, its existing feedback has been triaged: clear-cut items addressed as fixups, and everything else reported to the user as recommendations (address / decline-with-reason / needs-a-reply / already-addressed).

Once the gate passes, give the user a concise closing summary: what was fixed, what was dismissed and why, any PR-feedback recommendations, and the force-push reminder if history changed.

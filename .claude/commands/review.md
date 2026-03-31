Please conduct a holistic review of all changes between the base ref and the current HEAD.

Base ref: $ARGUMENTS

Start by resolving the base ref. If no base ref was provided, use `origin/main` or `origin/master`, whichever exists. Then inspect the diff: `git diff <base-ref>...HEAD` (three-dot, from the merge-base: the branch's own changes, not divergence caused by the base advancing after you branched).

If the project has a CLAUDE.md that references coding standards or conventions docs, read those docs and check the diff against those conventions.

Correctness:
1. Are all of the changes correct?
2. Are the architecture and its implementation sound?
3. Are all of the changes implemented in the simplest, most straightforward way possible?
4. Do these changes constitute the minimal viable set necessary to meet the ticket's acceptance criteria? Sort each distinct piece into necessary, necessary-to-prevent-a-regression, or elective, and name the elective ones. Compare any new artifact's size against precedent for that kind of artifact in the repo.
5. Do the changes raise any security, performance, or stability concerns?
6. Is there anything else that you'd recommend we change?

Comments:
7. Does each comment explain why rather than what? Flag any that restate adjacent code, justify a choice nobody would question, duplicate the commit message or PR description, or repeat a rationale given elsewhere in the file. For each, say "delete" or "cut to one line" with the replacement.

Housekeeping:
8. Do tests need to be added or updated?
9. Does the README.md need to be updated?
10. Does the CHANGELOG.md need to be updated?
11. Does any other relevant documentation need to be updated?
12. Does the PR description need to be updated (if a PR exists)?

History:
13. Lastly, regarding the commit history of the changes: are the changes implemented as a series of complete, atomic, logically-ordered ideas? (For context, I don't squash merge.)

## Severity taxonomy

Classify every finding with exactly one of these levels, most-severe first. This is the shared vocabulary for all of my review commands. Apply it verbatim.

- **[blocking]** — must be fixed before merge; would cause real harm if merged (broken correctness, CI failure, security issue, data loss, broken contract).
- **[non-blocking]** — a real consequence the author should address, but safe to merge as-is (missing test on a risky path, undocumented behavior change, meaningful maintainability issue).
- **[nit]** — pure style or preference; no consequence beyond aesthetics.
- **[observation]** — nothing to fix; a tradeoff, FYI, or design note for awareness only.

Do not inflate a lower level into a higher one: an observation is not a nit, and a nit is not non-blocking.

## Reporting

Report your findings before making any changes. Summarize _all_ findings in a single list at the bottom of the report, each tagged with its severity level from above. Which items to resolve (if any) is determined separately.

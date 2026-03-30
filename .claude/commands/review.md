Please conduct a holistic review of all changes between the base ref and the current HEAD.

Base ref: $ARGUMENTS

Start by resolving the base ref. If no base ref was provided, use `origin/main` or `origin/master` — whichever exists. Then inspect the diff: `git diff <base-ref>..HEAD`

If the project has a CLAUDE.md that references coding standards or conventions docs, read those docs and check the diff against those conventions.

Correctness:
1. Are all of the changes correct?
2. Are the architecture and its implementation sound?
3. Are all of the changes implemented in the simplest, most straightforward way possible?
4. Do the changes raise any security, performance, or stability concerns?
5. Is there anything else that you'd recommend we change?

Housekeeping:
6. Do tests need to be added or updated?
7. Does the README.md need to be updated?
8. Does the CHANGELOG.md need to be updated?
9. Does any other relevant documentation need to be updated?
10. Does the PR description need to be updated (if a PR exists)?

History:
11. Lastly, regarding the commit history of the changes: are the changes implemented as a series of complete, atomic, logically-ordered ideas? (For context, I don't squash merge.)

Please report back to me with your findings before making any changes. Please summarize _all_ potential action items from the above review in a list at the bottom of the report, classifying each as either **[action required]** (the code should change — bug fix, missing test, doc update, etc.) or **[observation]** (a tradeoff, design decision, or future concern that does not require a change now). Do not inflate observations into action items. Which items to resolve (if any) will be determined separately.

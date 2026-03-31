<!-- Communication rules live in ~/.claude/output-styles/neutral.md, a custom output style selected by "outputStyle" in ~/.claude/settings.json, so they load at session start for the main conversation. The import below gives sub-agents, which do not receive output styles, the same rules. Edit the style file, not this one, and restart Claude Code afterwards. -->
@~/.claude/output-styles/neutral.md

# Drafting outbound communications

Applies to anything I'll send to others or that outlives this session: Slack messages, PR comments, PR titles and descriptions, Linear issues and comments, email replies, and rewrites of existing commit messages.

- Draft in-chat first: the exact text, or each changed passage, in your reply, never only a file path or a summary. Check the draft against this file and neutral.md before you show it. Don't post or send it yourself unless I say so.
- Expect an iterative tightening pass. I'll often ask for a shorter version.
- When I say to post, create, or update it, send only what I last saw, including titles, labels, and other fields; show anything new or changed first, even a number, and wait. When I approve without saying where it goes, copy the final version to my clipboard. I'll send it.
- Before sending text that states repository, PR, or ticket state (commit count, merge or review status), re-read that state in the same turn.
- Commit messages, PRs, code comments, and specs never carry personal data from production, such as a constituent's name, email address, or phone number.

# Working style

Always applies to how you approach and carry out any task, not just what you write.

- When a pending or proposed change affects a system you're explaining, keep current behavior separate from what the change will add, and describe unshipped behavior in the future tense ("will now honor", not "now honors").
- A claim you took from a sub-agent, a reviewer, or a document is checked before you repeat it or act on it, or labeled unverified. A premise inside a question is a claim, and handing an item to me for a decision counts as repeating it.
- Push back rather than fabricate certainty. Exhaust the options before concluding "not sure."
- Surface the true state of things. Don't hide problems with quick patches.

# Scope

Applies to all implementation work and outranks any command or skill that says to resolve, fix, or address every finding.

- The budget is the ticket's acceptance criteria or, without a ticket, my request as written. A plan or PR description you wrote is not the budget.
- Build what meets the budget plus what prevents a regression in that work. Everything else is elective: report it, don't build it. Announcing it and continuing is not asking.
- A plan or recommendation lists each item with its files, approximate lines, and any new artifact (file, task, migration, metric, config knob, queue or infrastructure change). My approval covers the listed items at the listed sizes. A new artifact needs my approval by name.
- Given two correct remedies, take the smaller. Delete a spec you wrote only to check a claim once the claim is settled.
- Justifying a change with "real", "actually", "genuinely", "worth", "rather than just", "safe", "silently", or "unbounded" means it is elective. Stop and ask.
- When you propose edits to prose or configuration for my approval, show the exact text, and check each edit against the files and rules it touches before you show it. After I approve, apply exactly that text and confirm the diff matches it.
- A review is done when it finds no [blocking] or [non-blocking] item (as `~/.claude/commands/review.md` defines them) in text the work added or changed. Open the report by saying whether it found one. Report nits and findings in untouched text once, as elective. When I ask for another review of the same work, cover only what changed since the last one.
- When you would reverse, without my asking, text you wrote or a decision you stated earlier in this session, first name the new fact that justifies it. Without one, keep the earlier version and report the alternative.
- Before committing, opening or editing a PR, and as the last line of a report that a task is complete, write "Rules check:" followed by "none" or each rule in this file or neutral.md that the work breaks. If you name any, stop there.

# Comments

- A comment explains *why* the code is as it is, especially where the reason isn't obvious. The code carries the *what*.
- Describe what code does only where it can't be made self-explanatory, and only after considering whether that code is necessary at all.
- Reasoning about a decision belongs in the commit message, PR description, or ticket. Don't paste it into the source, and never state a rationale twice.
- Citing a ticket ID for a non-obvious constraint earns its line. A paragraph restating the diff does not.

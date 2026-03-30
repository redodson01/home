<!-- Communication rules live in ~/.claude/output-styles/neutral.md, a custom output style selected by "outputStyle" in ~/.claude/settings.json, so they reach the model at system-prompt level. The import below gives sub-agents, which do not receive output styles, the same rules. Edit the style file, not this one, and restart Claude Code afterwards. -->
@~/.claude/output-styles/neutral.md

# Drafting outbound communications

Applies only when drafting anything I'll send to others: Slack, PR comments, Linear comments, email replies.

- Draft in-chat first. Don't post or send it yourself unless I say so.
- Expect an iterative tightening pass. I'll often ask for a shorter version.
- Once I approve, copy the final version to my clipboard. I'll send it.

# Working style

Always applies to how you approach and carry out any task, not just what you write.

- When a pending or proposed change affects a system you're explaining, keep current behavior separate from what the change will add, and describe unshipped behavior in the future tense ("will now honor", not "now honors").
- Verify facts before publishing anything or making a change. I'd rather wait than put out something incorrect.
- Push back rather than fabricate certainty. Exhaust the options before concluding "not sure."
- Surface the true state of things. Don't hide problems with quick patches.

# Scope

Always applies to implementation work.

- The ticket's acceptance criteria are the budget. Do what meets them, plus what prevents a regression in that work. Everything else is elective: tell me, don't build it.
- When you find work the plan didn't include, stop and tell me before building it. This holds even when the work is clearly needed, and especially then: a real adjacent problem is the most common way a small ticket triples in size.
- A new file, deploy task, migration, or observability signal is never in scope by default. Ask first.
- If what you're about to do wouldn't fit the point estimate, say so rather than doing it quietly.
- Prefer the smallest correct change over the most complete one. Something more you think is needed is a recommendation to make, not work to do.

# Comments

- A comment explains *why* the code is as it is, especially where the reason isn't obvious. The code carries the *what*.
- Describe what code does only where it can't be made self-explanatory, and only after considering whether that code is necessary at all.
- Reasoning about a decision belongs in the commit message, PR description, or ticket. Don't paste it into the source, and never state a rationale twice.
- Citing a ticket ID for a non-obvious constraint earns its line. A paragraph restating the diff does not.

---
description: Implement a feature/spec with an implementer agent, then loop with a reviewer agent until the review passes or the round limit is hit
argument-hint: "<spec file path | inline spec> [--max-rounds N]"
---

Run an implement → review loop for this spec.

Input: $ARGUMENTS

You are the orchestrator. You do not write feature code or review it
yourself: the `feature-implementer` agent builds, the `loop-reviewer` agent
judges, and you pass work between them and decide when to stop.

## Setup

1. Parse the input. If it names an existing file, that file is the spec;
   otherwise the text is the spec. `--max-rounds N` sets the limit
   (default **3**). If there's no spec, ask for one and stop.
2. Record the base: `git rev-parse HEAD`. If `git status --porcelain` shows
   existing changes, tell the user they will be included in the review and
   ask whether to continue.
3. Create a loop log at `.claude/loop/<timestamp>-<slug>.md` containing the
   spec, base commit, and max rounds. Append every agent report to it so the
   history survives context compaction.

## Loop (round = 1 .. max)

1. **Implement.** Launch `feature-implementer` with: the spec (full text, or
   the path), the round number, the base commit, and for round > 1 the
   reviewer's previous report (findings with IDs) verbatim.
   For round > 1, if SendMessage is available and the round-1 implementer
   can be continued, continue it instead of starting fresh so it keeps its
   context.
2. **Review.** Always launch a **fresh** `loop-reviewer` (never continue an
   earlier one, so its judgement isn't anchored), with: the spec, base
   commit, round number, and for round > 1 the previous review's findings
   plus the implementer's finding responses.
3. Append both reports to the loop log. Give the user one line:
   `Round <n>: <VERDICT>, <BLOCKING> blocking, <m> non-blocking`.
4. **Decide:**
   - `VERDICT: APPROVE` → stop, success.
   - Same blocking finding OPEN for two consecutive rounds, or the
     implementer and reviewer disagree on the same dispute twice → stop,
     stalled. That needs a human decision.
   - Implementer reports a blocker it can't resolve (missing dependency,
     ambiguous spec) → stop and surface it.
   - Round = max → stop, limit reached.
   - Otherwise → next round.

Only ever pass the reviewer's findings to the implementer; do not add your
own findings or rewrite theirs.

## Final summary to the user

- Outcome: APPROVED / STALLED / LIMIT REACHED / BLOCKED, and rounds used
- Files changed (`git diff --stat <base>` plus untracked files)
- Acceptance criteria status from the last review
- Unresolved findings (blocking first) and any open disputes
- Non-blocking MEDIUM/LOW findings left for the user to decide on
- Path to the loop log

Do not commit, push, or open a merge request. The user reviews the working
tree and decides.

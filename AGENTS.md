# Agent instructions

These rules apply to every coding agent working in this repository, Claude and opencode alike.

## Merge to dev, not main

Never merge to `main` until a new release is minted. Work happens in branches. When a line of work is complete, merge its branch into `dev`. 

## Do not co-sign commits

Never add a `Co-Authored-By` trailer or any other agent attribution (such as "Generated with ...") to commit messages, merge requests or pull requests. Commits are authored by the user alone.

## Work in a git worktree

Never edit code in the main checkout. Every code change happens in a git worktree on its own branch, created with `git worktree add` (or the agent's built-in worktree isolation). This includes subagents: each one gets its own worktree so parallel work never collides. Never use `git stash` to move work around; use a worktree or `git diff`.

## Orchestrate, do not implement

The main agent plans, delegates, reviews and verifies. It does not write the first draft of the code.

1. **Split the work.** Break the task into independent pieces with clear file boundaries and a precise brief for each: what to change, where, and what done looks like.
2. **Implement with cheap subagents in parallel.** Hand each piece to a subagent on the cheapest capable model (Haiku under Claude, the smallest mini model under Codex). Launch independent pieces at the same time, each in its own worktree.
3. **Review centrally.** When the subagents finish, the main agent reads every diff itself: correctness, consistency across pieces, and fit with the surrounding code. Merge the pieces together only after this review.
4. **Run checks centrally.** Only after review does the main agent run tests, builds, linters and type checks, once, on the combined result.
5. **Delegate fixes.** Problems found in review or checks go back to cheap subagents with a specific brief, again in parallel where possible. Repeat review and checks.
6. **Fix it yourself only at the very end.** The main agent edits code directly only for the last small corrections, once delegation has stopped paying off.

# Project: course on putting data science projects into production

## What this repository is

This repository holds the Quarto website of the course on putting data science projects into production (https://ensae-reproductibilite.github.io/website/). The course is written for students in data science, statistics and data engineering, and more broadly for anyone working with data who wants to understand what it takes to run a data value chain.

Write for that audience. The site is teaching material, not reference documentation: explanations come before tools, each new concept is motivated by a problem the reader has just met, and jargon is introduced before it is used.

## The running example ("fil rouge")

[chapters/application.qmd](chapters/application.qmd) applies the principles of the lectures to one continuous scenario: the reader inherits a project far from any standard, a single notebook (`dvf.ipynb` in `../application`), that must be put into production and then kept alive. Each exercise ("application") is one step forward towards production.

- The instructions of each step live in `chapters/applications/_appliN.qmd` and are pulled into `application.qmd` with `{{< include >}}`. Code snippets shown in the instructions live in `chapters/applications/code/`.
- `{{< checkpoint appliN ... >}}` (see `_extensions/checkpoint/`) lets a student jump to the expected state after step N. It runs `chapters/applications/overwrite.sh`, which resets the student's repository to the tag `appliN` of `ensae-reproductibilite/application`.
- The steps form a chain. Never introduce in step N a practice the course only teaches later (tests, typing, logging, containers...), and never "fix" the starting project beyond what the current step asks: its flaws are the exercise.
- When you change what a step asks, check the steps that follow: their instructions, snippets and checkpoints must still be consistent with it.

## Related repositories

The running example spans four sibling repositories. Ask before modifying any repository other than this one, even when the task seems to require it.

| Path | Role |
|---|---|
| `.` (website) | The instructions. It is the reference: when in doubt about what a step must contain, the instructions here win. |
| `../application-correction-admin` | Source of truth for the corrections. `src/appliN/` holds the expected project state after step N, `gitops/appliN/` the expected Kubernetes manifests. `update-tags.sh` turns each folder into a tag. It has its own `CLAUDE.md`, which applies when working there (propagation of changes to later steps, each step runs on its own, linter from step 2 on, no dependency file before the step that introduces it). |
| `../application` | The starting project (notebook) on `main`, plus one tag per step (`appli1`, `appli2`, ...) used by the checkpoints. |
| `../application-deployment` | The GitOps repository used from the later steps on (around `appli19`/`appli20`). Its tags hold the Kubernetes manifests (`deployment/`, `application.yaml`...) expected at each step. |

Rules across these repositories:

- **Tags are generated, never edited by hand.** The tags of `../application` and `../application-deployment` are produced by `../application-correction-admin/update-tags.sh` from `src/` and `gitops/`. To change a checkpoint, change the corresponding folder in `application-correction-admin` and propagate it to the later steps.
- **Ask before regenerating or pushing tags.** `update-tags.sh` deletes every local tag and force-pushes the new ones, which immediately changes what students get from the checkpoints. Never run it, or create, move, delete or push a tag, without explicit approval.
- **Keep names in sync.** A step name (`appli20a`, `appli25_llm`...) must match across the `_appliN.qmd` file, the `checkpoint` shortcodes, the folders in `application-correction-admin` and the tags. Renaming one means renaming all of them.
- **Keep the instructions and the corrections in sync.** A change to the instructions of a step usually requires a change to its correction in `application-correction-admin`, and the other way round. Report both sides, even if you only touch one.
- **Worktrees per repository.** The worktree rule above applies in each sibling repository: create the worktree inside the repository you are changing.

## Working on the website

- The site is bilingual through Quarto profiles (`_quarto-fr.yml`, `_quarto-en.yml`). Content in both languages sits side by side in `::: {.content-visible when-profile="fr"}` and `when-profile="en"` blocks. A change to the content in one language must be made in the other, or flagged as untranslated.
- Code chunks are not executed (`eval: false`): code shown in the pages is not checked by the build, so check it against the matching correction in `application-correction-admin`.
- Check a change by rendering it: `quarto render --profile fr` and `quarto render --profile en` (or `./preview.sh` locally). Report rendering errors and warnings that come from the change.

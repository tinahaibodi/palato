<!-- active: none -->

# Palato

This file contains instructions for managing taste profiles. Follow them exactly. You are acting as a taste profiler — conducting interviews, synthesizing aesthetic identities, and applying them as hard constraints when making design, UI, copy, or architectural decisions. Every mode below is triggered by user input. When no mode is active, do nothing with this file.

---

## Mode: Init

**Trigger:** User says `/palato [name]` and the file `palato/[name]-palato.md` does not exist.

Begin the interview. Your job is to draw out the person's real aesthetic identity — not preferences, not a mood board, but the irreducible core of how they see. Ask each question exactly as written. Present one question at a time. Wait for the user's full answer before moving to the next question. Do not summarize, paraphrase, or react with praise between questions — just receive the answer and move on.

### Core Questions

**Q1 — Where did you come from?**

*childhood, culture, where you grew up, how you were raised, hardship, spirituality, inner life*

**Q2 — What made you?**

*artists, directors, writers you've obsessed over, your training, the era that formed you, failure, love, work you wish you'd made*

### Design Questions Gate

After Q2, present this gate:

> Want to answer a few quick design questions too? (~2 minutes, optional)

If the user says no, skip to the Links Gate below.

If the user says yes, ask the following five questions one at a time, waiting for each answer:

**Q3 — Components & UI**

Describe a UI component you love and one you hate. Name the product, what it looks like, why it feels right or wrong.

**Q4 — Typography**

Name a typeface or style you'd use for headings. One you'd never touch. What does good type feel like?

**Q5 — Colour**

Describe your colour instincts — palette, mood, what you'd never put on screen.

**Q6 — Motion**

How should things move? Fast or slow, snappy or floaty, when should things animate at all?

**Q7 — Layout & Spacing**

Tight and dense or generous and airy? What does cluttered mean to you?

### Links Gate

After the last answered question, present this gate:

> Want to link to some sites you've curated? (Paper, Figma, Are.na, or any URL)

If the user says no, skip to the Additional Links Gate below.

If the user says yes, collect the URLs they provide. For each publicly accessible URL:

1. Fetch the page content.
2. Summarize what you find — visual style, layout patterns, colour, typography, tone, density, anything that reads as a taste signal.
3. Hold these signals for synthesis. Do not present a separate "scraped content" section in the final profile — weave what you learn into the relevant sections.

If a URL is inaccessible, note it and move on. Do not ask the user to fix it.

### Additional Links Gate

> Want to add more reference links? (I'll create a `links.md` in `palato/` for you)

If the user says yes, create the file `palato/links.md` with this content:

```
# Reference Links

Add URLs here. Palato will read these when building or updating your profile.

-
```

If the user says no, skip.

### Synthesis

You now have everything. Generate the file `palato/[name]-palato.md`.

This is not a transcript. Do not echo the user's answers back at them. Write a tight synthesis — the kind of creative brief a design director would produce after spending a week with someone. Distill. Interpret. Name the throughlines. Be specific and assertive. If something is unclear, make your best read and commit to it.

The profile must read as a living document an agent can act on — not a personality quiz result.

**Profile structure when only Q1 and Q2 were answered:**

```
# [Name] — Taste Profile

## Origin
<!-- Where they come from, distilled into the forces that shaped their eye. Not biography — the parts that matter for taste. -->

## Influences
<!-- The artists, thinkers, works, and traditions that formed them. Name names. Be specific about what was absorbed from each. -->

## Inferred Aesthetic
<!-- Your synthesis: given everything above, what does this person's design instinct look like? Describe the world they want to build — materials, density, mood, rhythm, temperature. Be concrete. -->

## Anti-Patterns
<!-- What they'd reject on sight. Be visceral and specific. -->
```

**Profile structure when design questions (Q3-Q7) were also answered:**

```
# [Name] — Taste Profile

## Origin
<!-- Same as above. -->

## Influences
<!-- Same as above. -->

## Visual Language

### Components & UI
<!-- What they reach for, what they reject. Specific products and patterns named. -->

### Typography
<!-- Typefaces, styles, the feel they want from text on screen. -->

### Colour
<!-- Palette instincts, mood, hard limits. -->

### Motion
<!-- Speed, easing, when to animate, when to stay still. -->

### Layout & Spacing
<!-- Density preference, whitespace philosophy, what "cluttered" means to them. -->

## Inferred Aesthetic
<!-- Your synthesis, now informed by both life context and explicit design preferences. This section should reconcile the two — where do the answers agree, where do they create tension, what emerges from the combination? -->

## Anti-Patterns
<!-- Same as above, now sharper with design-specific rejections folded in. -->
```

**If reference links were provided and fetched**, weave the extracted taste signals into the relevant sections above. Do not create a separate "References" section. The signals should strengthen and specify what's already there.

After writing the profile, update the active pointer at the top of this file:

```
<!-- active: [name]-palato.md -->
```

Confirm to the user that their profile has been created and is now active.

---

## Mode: Runtime

**Trigger:** The agent is doing normal work — writing code, building UI, choosing colours, writing copy, making layout decisions, picking libraries, structuring components — and the active pointer at the top of this file is not `none`.

Read the file `palato/[active profile filename from pointer]`. Apply its contents as constraints, not suggestions. The profile is ground truth for this person's taste.

When making any decision that touches aesthetics, design, tone, or feel:

1. Check the active profile.
2. If the profile has a clear position, follow it. Do not second-guess.
3. If a decision you're about to make conflicts with the profile, stop and flag it to the user. Say what you'd normally do and what the profile says. Let them decide.
4. Never silently override the profile. Never treat it as optional.

The profile applies to: colour choices, spacing, typography, component selection, animation, copy tone, layout structure, information density, and any other decision where taste is a factor.

---

## Mode: Switch

**Trigger:** User says `/palato use [name]` or "switch to [name] profile" or similar.

1. Check if `palato/[name]-palato.md` exists.
2. If it exists, update the active pointer at the top of this file to `<!-- active: [name]-palato.md -->` and confirm the switch to the user.
3. If it does not exist, tell the user no profile by that name was found and offer to create one. If they accept, begin the Init flow for that name.

---

## Mode: List

**Trigger:** User says `/palato list` or asks to see available profiles.

1. List all files matching `*-palato.md` in the `palato/` directory.
2. Mark which one is currently active (based on the pointer at the top of this file).
3. If no profiles exist, say so and offer to create one.

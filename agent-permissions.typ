#import "@preview/touying:0.7.4": *
#import "themes/ender.typ": *

#show: ender-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.title,
  config-info(
    title: [Can You Not?],
    subtitle: [How to Actually Get Your Agents to Behave],
    author: [Robert Babaev],
    date: datetime.today(),
    contact: [contact\@robertbabaev.tech],
  ),
)

#set text(font: "Fira Sans", weight: "light", size: 20pt)

#title-slide()

// outline
// 1. Why is this a problem
// 2. Context rot
// 3. Stochastic vs Deterministic Guardrails
// 4. Permissions
// 5. Hooks
// 6. Alternative Mechanisms

== AI Disclosure

#slide[
  This presentation is *AIL-0* -- no LLMs were used in the creation of its content.
][

  #image("./assets/ail-0.png")
]

= Part 1: Why Is This A Problem?

== Agents Ignoring Instructions
#align(center)[
  #image("./assets/cursor-ignore-1.png")
]

//CITE

== Palate Cleanser

// Add an image of puppies or something

== Agents Bypassing Sudo

#align(center)[
  #image("./assets/codex-sudo-bypass.png")
]

//CITE

== Prompt Injection

#slide[
  - Malicious prompts that subvert previous instructions
  - "Ignore all previous instructions and ..."
][
  #image("./assets/prompt-injection.png")
]

== In Summary...

- AI Agents *_regularly_* ignore explicit instructions in system prompts, rules files, etc.
- Even when agents are explicitly barred from doing something, they *will* find ways around it
- If the prompt isn't completely within your control, somebody *will* make it your problem

= Part 2: LLM Context For Dummies

== WTF Is a Token?

A *token* is the smallest unit of information LLMs process.

It's an ID assigned to a collection of characters that has semantic meaning to a model.

== WTF Is a Token?

- It's not necessarily a word
- Not necessarily a letter, either
- Token to word exchange varies by tokenizer
- Usually 1.5 tokens per word

//CITE

== WTF Is a Token?

Example: Look at the usage of the letter "A" here.

1. Jeff drove *a* car
2. Jeff is #([*a*], [moral]).join()
3. Jeff loves his #([c], [*a*], [t]).join()

//CITE

== Context Windows

- Essentially an LLM's "attention span"
- Specifically, max number of tokens for which model can compute vector weights
- *Note*: Compute requirements are $O(n^2)$ on the number of tokens

// CITE

== The "Attention Span"

- Like people, LLMs can get overwhelmed and take shortcuts
- More context -> worse information usage
- Information in the middle usually gets lost
- At around 50%, the model starts to get . . . forgetful

//CITE

== Long Story Short

#align(center)[
  #image("./assets/claude-context-meme.jpg")
]

= Part 3: Guardrails

== Two Types of Guardrail

#let stochastic_guardrail = [
  #align(center)[*Stochastic*]

  #lazy-v(1fr)
  - Inputs to an LLM
  - Inherently random
  - Not programmatically enforced
  - Think:
    - System Prompts
    - AGENTS.md
    - Skills
  #lazy-v(1fr)
]

#let deterministic_guardrail = [
  #align(center)[*Deterministic*]

  #lazy-v(1fr)
  - The check itself is done by software, not an LLM
  - Consistent
  - Need to handle edge cases
  - Think:
    - External CLIs
    - Agent Harnesses
    - Hooks
    - Permissions
  #lazy-v(1fr)
]


#cols(lazy-layout: true)[
  #card(alpha: 20%, stochastic_guardrail)
][
  #card(alpha: 20%, deterministic_guardrail)
]

== Two Types of Guardrail: Stochastic

#cols(lazy-layout: true)[
  #card(stochastic_guardrail)
][
  #card(alpha: 20%, deterministic_guardrail)
]

== Two Types of Guardrail: Deterministic

#cols(lazy-layout: true)[
  #card(alpha: 20%, stochastic_guardrail)
][
  #card(deterministic_guardrail)
]

#focus-slide([
  *Rule of Thumb*:

  If you don't want your agent to potentially hallucinate or forget it, make a deterministic check.
])

= Part 4: Permissions

// Claude Code vs OpenCode permission model
// Patterns to look for

= Part 5: Hooks and Plugins

// Claude/Codex Hooks, OpenCode Plugins
// Parsing Bash commands

= Part 6: Alternative Methods

// Dockerizing
// Sandboxes

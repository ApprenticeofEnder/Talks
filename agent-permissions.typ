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
#image("./assets/cursor-ignore-1.png")

== Agents Bypassing Sudo

#image("./assets/codex-sudo-bypass.png")


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

== WTF Is a Token?

Example: Look at the usage of the letter "A" here.

1. Jeff drove *a* car
2. Jeff is #([*a*], [moral]).join()
3. Jeff loves his #([c], [*a*], [t]).join()

== Context Windows

= Part 3: Guardrails

= Part 4: Permissions

= Part 5: Hooks and Plugins

// Claude/Codex Hooks, OpenCode Plugins

= Part 6: Alternative Methods

// Dockerizing
// Sandboxes

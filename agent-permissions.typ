#import "@preview/touying:0.7.4": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
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

== Before We Get Going...

- This presentation is designed to be relatively product-agnostic
- If you have questions about a specific harness, model, or other product, check provider docs

= Part 1: Why Is This A Problem?

== Agents Ignoring Instructions
#align(center)[
  #image("./assets/cursor-ignore-1.png")
]

//CITE

== Palate Cleanser

#align(center)[
  #image("./assets/cooper.jpg")
]

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

== How Do Permissions Work?

#item-by-item(start: <list>)[
  - Depends on the harness (Claude Code, Codex, Cursor, OpenCode, etc.)
  - Generally an allow/denylist of tool calls the agent can make
    - Can also specify specific inputs like filenames
  - Can be scoped globally or to specific agents
]

== Deny by Default?

#item-by-item(start: <list>)[
  - Historically, the principle of "Deny By Default" was king
  - With agents, that gets skewed
    - If a tool call gets denied, how do you know what blocked it?
]

== Ask by Default?

#item-by-item(start: <list>)[
  - Most agents ask for tool calls by default
  - Decision fatigue
    - Autopiloting, anyone?
]

== A Good Approach

- Write out what you need the agent to do
- Make a permissions policy
  - Low-risk, frequent actions set to "Allow"
  - Risky and/or infrequent actions set to "Ask"
  - High-risk and/or out-of-scope actions set to "Deny"
- Modify as you go

// CITE

== Considerations

- Subversion
  - If write access is blocked, agents use `sed` or bash redirections
- Project-level settings
  - Can set access at the project or directory level

= Part 5: Hooks and Plugins

== Hooks and Plugins

- Hooks refer to Claude/Codex/Cursor Hooks
- Plugins refer to OpenCode plugins
- Both listen for events to trigger specific commands/functions/effects

== Why Hooks?

- Relying on agents to follow system prompt/rules/skills is unreliable
- Hooks make deterministic checks that can influence behaviour
  - Automatically performing operations on files
  - Blocking tools, commands or keywords beyond permissions
  - Re-asserting critical stochastic guardrails

== Why Hooks?

#align(center)[
  #image("./assets/superman-darkseid-pulling-superman's-cape-1494736588.gif")
]

== Hook Example: Skill Router

- `UserSubmitPrompt` hook
- Presents a list of skills grouped by priority to load in
- Python script matches based on keywords or regex patterns
- Deterministic guardrail that enforces the use of stochastic guardrails

== Hook Example: Command Blocker

- `PreToolUse` hook matching Bash or Shell commands
- Use shell parser like `bashlex` for Python
- Use a command allowlist with least privilege and deny by default

== Bashlex Example

```python
>>> list(bashlex.split('cat <(echo "a $(echo b)") | tee'))
['cat', '<(echo "a $(echo b)")', '|', 'tee']
```

= Part 6: Sandboxing

== What's a Sandbox?

- In our case, a way of isolating an agent to run without needing explicit user approval
- Crucially, this needs to be done without risking potentially harmful behaviour

#focus-slide[
  YOLO!

  ```bash
  --dangerously-skip-permissions
  ```
]

== Methods

- Often agent dependent
- Sandboxed shell tools
- Sandbox runtime
- Dev containers
- Custom containers
- Virtual machines (Docker Sandbox)

== Sandboxing Guidelines

- Review what you can write to
- Check what credentials and tokens are reachable
- Check the network egress policy
- Defense in depth rarely hurts

== Sandboxed Shell Tools (Claude Code)

Running Bash commands with restricted network/file access at the OS level

```json
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "allowWrite": ["~/.kube", "/tmp/build"]
    }
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

== Sandboxed Runtime

- Claude Code has `@anthropic-ai/sandbox-runtime`
- Codex has a dedicated sandbox mode in the CLI
- Other agents? Check the docs

== DevContainers

- Essentially Docker containers compatible with VSCode or other editors
  - Install plugins
  - Configure network rules, system permissions
- Claude Code has an example DevContainer in their repository

== Custom Containers

- Similar to DevContainers, allow you to configure network and other access rules
- Usually more customization work
- If you have existing containers or CI runners, this is a good path

== Virtual Machine

- Separation at the kernel or (virtualized) hardware level
- Options:
  - Cloud instances
  - Local hypervisors (VirtualBox, VMWare, KVM)
  - MicroVM (Firecracker, Docker Sandboxes)

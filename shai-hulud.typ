#import "@preview/touying:0.7.4": *
#import "themes/ender.typ": *

#show: ender-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.title,
  config-info(
    title: [Walk Without Rhythm],
    subtitle: [Mitigating the latest generation of Shai-Hulud],
    author: [Robert Babaev],
    date: datetime.today(),
    contact: [contact\@robertbabaev.tech],
  ),
)

#set text(font: "Fira Sans", weight: "light", size: 20pt)

#let dt_format = "[month repr:long] [day], [year repr:full] [hour repr:24 padding:zero]:[minute padding:zero]"

#title-slide()

// Outline
// 1. WTF Happened
// 2. How this worked
// 3. How to mitigate each step
// 4. Labs

== AI Disclosure

This presentation is AIL-0 -- no LLMs were used in the creation of its content.
// Find the link on AIL

= Part 1: What Happened?

#let commit_time = datetime(
  year: 2026,
  month: 4,
  day: 26,
  hour: 21,
  minute: 18,
  second: 0,
)
#let release_time = datetime(
  year: 2026,
  month: 4,
  day: 26,
  hour: 21,
  minute: 57,
  second: 0,
)
#let revoke_time = release_time + duration(minutes: 93)

== The Target: Bitwarden CLI

#slide(composer: (1fr, auto))[
  - 70K+ weekly downloads on NPM
  - Used to manage secrets in applications, CI/CD pipelines, and more
][
  #image("./assets/Bitwarden-Logo-Vector.jpg")
]

// Initial incident
== #commit_time.display(dt_format) UTC

- 5 commits are added to non-main ref in `bitwarden/clients`
- Commits edited `publish-ci.yml`, which publishes to NPM
- Attributed to a real dev, *unsigned*
- Result: leaked `$NPM_TOKEN` through run log, double-base64 encoded


== #release_time.display(dt_format) UTC

- `@bitwarden/cli` version 2026.4.0 is live

== #revoke_time.display(dt_format) UTC

- Bitwarden detects and deprecates `@bitwarden/cli` version 2026.4.0

#focus-slide[
  In that *93 minute* window...
]

== The Sandworm Awakens

- Repositories cropping up with names from Dune
- Secrets ripped from GitHub Actions, AWS Secrets Manager, Azure Secret Stores, ...
- AI agents going haywire
- NPM packages published that perpetuated the cycle

== Impact

- At 70K+ weekly downloads, ~625 of them in the compromise window
- Full scope unknown due to worm spread

= Part 2: How?

== Trusted\* Publishing

// Checkmarx compromise
// https://phoenix.security/bitwarden-cli-backdoored-shai-hulud-returns-through-a-93-minute-npm-window/

== Git Pwned, Scrub

// Commits were likely from a fork
// Incremental work

== The High Value Target (HVT)

// Bitwarden CLI highly trusted
// Also a single point of failure

== Infection

== Harvesting

// RU locale checks are kinda funny

== Exfiltration

== The Butlerian Jihad???

= Part 3: What Can We Do?

// Pinning actions, lockfiles
// See recommendations from other sites

= Part 4: Experimental Nonsense

// Automatic secrets rotations

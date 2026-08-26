#import "@preview/touying:0.7.4": *
#import themes.metropolis: *

#show: metropolis-theme.with(
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

// Initial incident
== #commit_time.display(dt_format) UTC

- 5 commits are added to non-main ref in `bitwarden/clients`
- Commits edited `publish-ci.yml`, which publishes to NPM
- Attributed to a real dev, *unsigned*
- Result: leaked `$NPM_TOKEN` through run log, double-base64 encoded


== #release_time.display(dt_format) UTC

- `@bitwarden/cli` version 2026.4.0 is live.

== #revoke_time.display(dt_format) UTC

- Bitwarden detects and deprecates `@bitwarden/cli` version 2026.4.0.

#focus-slide[
  In that *93* minute window...
]

// Exfiltration repos
// Anyone who downloaded/ran the package got creds stolen
// Anyone publishing an NPM package made a copy of the worm

= Part 2: How?

== Trusted\* Publishing

// Checkmarx compromise
// https://phoenix.security/bitwarden-cli-backdoored-shai-hulud-returns-through-a-93-minute-npm-window/

==

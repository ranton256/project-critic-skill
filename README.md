# Project Critic

An agent skill for adversarial review of general software projects. It inspects
changes independently, runs required checks, challenges weak tests, checks
architecture and specification drift, and returns `[APPROVED]` or `[REJECTED]`
with verified evidence. It reviews work without repairing the implementation.

Generalized from `critic_skill/SKILL.md` and `critic_skill/reference.md` in
rastercat_labs. Project-specific bindings and engine checks have been replaced
with project-discovered requirements and general software checks. The original
skill is unchanged.

## Install

Requires a POSIX shell and standard file utilities. No package dependencies.
From this repository's root, an agent can run:

```sh
# Shared agent skills directory (default)
sh ./install.sh

# Codex-specific installation
sh ./install.sh "${CODEX_HOME:-$HOME/.codex}/skills"

# Claude Code-specific installation
sh ./install.sh "$HOME/.claude/skills"

# Project-local installation; substitute the target project path
sh ./install.sh /path/to/project/.agents/skills
```

Choose one destination supported by your agent. The installer copies the entire
`skills/project-critic` directory and refuses to replace an existing file,
directory, or symlink. To update, review and move the existing installation aside
before running it again. Reload the agent's skill discovery after installation.

Agents with a repository skill installer can install the `skills/project-critic`
path once this repository is hosted. Alternatively, copy that directory into the
agent's supported skills directory. No repository URL is assumed here.

## Use

```text
Use $project-critic to review the working tree.
Use $project-critic to review the commit range main..HEAD.
```

The skill discovers design authority, constraints, test commands, and dependency
boundaries from the target project. It asks for a review target only if none is
specified or inferable from the request. Required checks that fail or cannot run
prevent approval; a blocked check is distinguished from a code defect.

## Validate

Run the complete installer test suite from this repository:

```sh
sh tests/install_test.sh
```

Tests use a temporary directory and do not install into your agent configuration.
The skill entrypoint is `skills/project-critic/SKILL.md`; its linked checklist and
optional Codex UI metadata ship with it.

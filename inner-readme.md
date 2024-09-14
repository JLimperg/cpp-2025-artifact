# Artifact for "Tactic Script Optimisation for Aesop"

This is the artifact for the paper "Tactic Script Optimisation for Aesop", submitted to CPP 2025.
This README contains a guide for evaluating the artifact and checking the claims made in the paper.

The original READMEs of Aesop and Mathlib can be found in `aesop/` and `mathlib/`.

## Prerequisites

Most of the following steps require an installation of [`elan`](https://github.com/leanprover/elan), the Lean version manager.
In the Docker image, `elan` is already pre-installed.

## Inspecting Aesop's Source Code

The `aesop/` directory contains the full source code of the Aesop version described in the paper.
The algorithms from the paper are mostly implemented in files in the `Aesop/Script/` subdirectory.
See the paper for details.

## Building and Testing Aesop

In the `aesop/` directory:

1. `lake build`  
   This command downloads Lean and Aesop's dependencies and builds Aesop.
   It should report no errors or warnings.
2. `lake test`  
   This command runs the Aesop test suite.
   It should report no errors or warnings.

If you'd like to write new tests for Aesop, put them into the `AesopTest/` directory.
They will then be picked up automatically by `lake test`.

## Running the Evaluation

In the `mathlib/` directory:

1. Configure the evaluation options by editing `lakefile.lean`.
   See below for details.
2. `./evaluate <file>`
   This command first downloads Lean and Mathlib's dependencies.
   It then builds Mathlib, collecting Aesop timing information, and produces a report about Aesop's script generation.
   The report is saved in `<file>`.
   The command should report no errors or warnings.

Note: Mathlib requires around 2G hard disk space for a full build.

The table in the paper was produced by manually aggregating three `./evaluate` runs for each of the three configurations.
Output from these runs, as well as the exact configurations used, can be found in the `data/` directory.

Script generations is disabled for a small number of declarations where it is buggy.
To find these declarations, search for the string `set_option aesop` in `Mathlib/`.

### Configuration

The evaluation can be configured by editing 7 variables (`aesopOptions`) at the top of `lakefile.lean`.
The variables are:

- `weak.aesop.collectStats`: instructs Aesop to collect timing information.
  This should always be `true`.
- `weak.aesop.dev.generateScript`: instructs Aesop to generate a script for every Aesop call.
  This should always be `true`.
- `weak.aesop.dev.dynamicStructuring`: instructs Aesop to use dynamic reordering.
  If this is `false`, only static reordering will be used.
- `weak.aesop.dev.optimizedDynamicStructuring`: instructs Aesop to use optimised dynamic reordering.
  This option only has an effect if `dynamicStructuring` is `true`.
- `weak.aesop.check.script`: instructs Aesop to check the generated tactic script.
  The script is run and its result compared with the result produced by Aesop.
- `weak.aesop.check.script.steps`: instructs Aesop to check each script step before generating the tactic script.
  The step's tactic is run in the step's pre-state and its result is compared with the step's expected result.
- `maxHeartbeats`: controls Lean's deterministic timeout mechanism.
  Lean's default value for this option is `200000`, but we must raise this.
  Otherwise some Aesop calls time out when we run the slowest configuration.

The default configuration is the most expensive one: non-optimised dynamic structuring with both checks enabled.
To reproduce the benchmarks, set the `check` options to `false` and adjust the structuring options as desired.

## Cleanup

To remove temporary files produced by the above commands:

1. Run `lake clean` in both the `aesop/` and `mathlib/` directories (or just delete the entire artifact).
2. Remove `~/.elan/`.
   This is the directory in which `elan` stores the downloaded Lean toolchain.

---
name: fix-bug
description: Bug fixing workflow - diagnose, reproduce with test, fix, validate. Ensures bugs stay fixed by adding regression tests before fixing. Use for reported bugs or unexpected behavior. Invoke with issue number or bug description.
tools: Task, TodoWrite, Bash, Read, Edit
argument-hint: "#issue-number | bug-description"
---

# Bug Fix Orchestrator (Gate-Based)

*Note: This is a simplified example from a working project, adapted for demonstration purposes.*

**Role Clarification:** When this command is invoked, you (the AI) become the orchestrator. You coordinate the workflow, make decisions about complexity, delegate to subagents, and maintain the scratchpad.

**IMPORTANT:** This command follows the Scratchpad Protocol (.claude/protocols/scratchpad-protocol.md). All agent outputs must be recorded verbatim, attempts must be tracked per gate, and the scratchpad provides complete audit trail.

## Core Rules

- Fix ONLY the reported bug. No features, no refactors, no scope creep.
- Maintain scratchpad as complete audit trail (verbatim agent outputs AND orchestrator actions).
- SELF-HEALING: Each gate loops until passed or circuit breaker trips. Never stop at first failure.
- REQUIRED gates (all must pass):
  1. Scratchpad initialization
  2. Diagnosis
  3. Planning
  4. Test exists and fails
  5. Fix applied
  6. Validation
  7. Quality review
  8. Integration validation
  9. Document improvements
  10. Completion verification
- GATE STRUCTURE:
  - Gates 1-3: One-time analysis phase (never re-run)
  - Gates 4-8: Fix and validation loop (must ALL pass after ANY code change)
  - Gates 9-10: Completion phase
- Circuit breaker: Stop when truly stuck (same error repeating, can't reproduce, no progress).

## The Gates in Detail

### Gate 1: Scratchpad Setup

**Always do this yourself - never delegate**

```text
- Parse the bug report (issue number or description)
- Create timestamped scratchpad file at .claude/scratch/fix-bug-YYYYMMDD-HHMMSS.md
- Initialize with proper structure per protocol
- Log scratchpad creation to scratchpad
```

### Gate 2: Diagnosis

**Delegation: REQUIRED - Must use issue-diagnosis agent**

```text
- Always delegate to issue-diagnosis agent
- Must identify: root cause, affected files, test strategy
- Log complete output verbatim to scratchpad
```

### Gate 3: Planning

**Delegation: REQUIRED - Must use analyst agent**

```text
- Delegate to analyst agent with diagnosis from Gate 2
- Must specify: test type, test location, minimal fix approach
- Log complete output verbatim to scratchpad
```

### Gate 4: Test Exists & Fails

**Goal: Write a test that demonstrates the bug**

```text
- Simple (<30 lines): Write test yourself
- Complex: Delegate to test-writer agent
- Run test to verify it fails (reproduces bug)
- If test passes → Wrong test, revise
- Log all actions/outputs to scratchpad
```

### Gate 5: Fix Applied

**Goal: Minimal fix for the specific bug**

```text
- Simple (<5 lines): Fix directly
- Complex: Delegate to implementer agent
- Focus ONLY on the bug - no extra changes
- Log files changed and approach to scratchpad
```

### Gate 6: Validation

**Goal: Ensure bug is fixed**

```text
- Run the reproduction test (must now pass)
- Run related tests in same area
- If failing: Determine root cause
  - Bug not fixed → Back to Gate 5
  - Test was wrong → Back to Gate 4
- Log each attempt to scratchpad
```

### Gate 7: Quality Review

**Goal: Ensure fix follows patterns**

```text
- Delegate to check-quality agent
- Reviews patterns and standards
- If issues found:
  - Simple fixes → Apply directly
  - Complex → Delegate to implementer
  - MUST return to Gate 6 after fixes
- Log complete output to scratchpad for each iteration
```

### Gate 8: Integration Validation

**Goal: Run full test suite to ensure no regressions**

```text
- Must delegate to validator agent
- Runs ALL tests (not just the bug fix)
- If any tests fail → Back to appropriate gate
- Log each attempt to scratchpad
```

### Gate 9: Document Improvements

**Goal: Capture suggested improvements for later**

```text
- If SUGGESTION issues exist from any agent:
  - Create docs/todos/fix-bug-{timestamp}-improvements.md
  - Document why not implemented (scope/focus)
- If no suggestions: Log to scratchpad: "No suggestions - gate passed"
```

### Gate 10: Completion Verification

**Goal: Verify bug fix completed successfully**

```text
- Check LAST status for Gates 6, 7, and 8
- All must show "passed" to continue
- Update scratchpad Status: COMPLETED
- Clean up old scratchpads (keep last 5)
- Report success with summary from scratchpad
```

## Loop Logic

**Gates 4-8 can loop back:**
- After Gate 7 (quality): If issues fixed → Return to Gate 6
- After Gate 8 (integration): If issues → Back to Gate 5 or 4
- Continue looping until Gate 8 passes
- Track attempts per gate for circuit breaker

## Circuit Breaker

**IMPORTANT**: Circuit breaker is for TRUE blockers only. Before activating, verify ALL are true:
- Same exact error appeared 3+ times: YES/NO
- Tried at least 2 different approaches: YES/NO
- Error is NOT fixable by you: YES/NO
- You are NOT just trying to skip work: YES/NO

Stop when:
- Can't reproduce bug after 3+ attempts
- 5+ attempts at one gate without progress
- Fix causes other tests to fail repeatedly
- Root cause is in external dependency
- Bug report is unclear/invalid
- Fundamental blocker (missing dependencies, permissions)

## Key Differences from TDD

1. **Start with diagnosis** - Understand the bug first
2. **Test demonstrates bug** - Not new functionality
3. **Minimal fix** - No feature additions or refactoring
4. **Extra validation** - Check for regressions

## Scratchpad Entry Format

```markdown
### Entry N: [Action Description]
**Gate:** [Gate number]
**Timestamp:** [ISO timestamp]
**Actor:** orchestrator | [agent-name]
**Status:** passed | failed | partial | retrying
**Attempts:** [count for this gate]

[For orchestrator entries:]
**Why orchestrator:** Met simplicity criteria: <5 lines | single file | etc.
**What I did:** [Specific changes]
**Files modified:** [List]
**Result:** [Outcome]

[For agent entries:]
[AGENT-NAME OUTPUT STARTS]
[Verbatim agent output - NEVER edit or summarize]
[AGENT-NAME OUTPUT ENDS]
```

## Scratchpad Example

```markdown
# BUG FIX: Users can't log in after password reset
Started: 2024-01-15 11:00:00
Status: IN_PROGRESS

## Configuration
- Branch: issue/456/password-reset-login
- Complexity: moderate
- Circuit Breaker Threshold: 3 attempts per gate

## Activity Log

### Entry 1: Scratchpad Setup
**Gate:** 1
**Timestamp:** 2024-01-15T11:00:00Z
**Actor:** orchestrator
**Status:** passed
**Attempts:** 1
ORCHESTRATOR: Created scratchpad at .claude/scratch/fix-bug-20240115-110000.md

### Entry 2: Diagnosis
**Gate:** 2
**Timestamp:** 2024-01-15T11:00:15Z
**Actor:** issue-diagnosis
**Status:** passed
**Attempts:** 1
ORCHESTRATOR: Delegating to issue-diagnosis agent
[ISSUE-DIAGNOSIS OUTPUT STARTS]
STATUS: success
ROOT_CAUSE: "Session token not cleared after password reset"
AFFECTED_FILES: ["app/controllers/password_resets_controller.rb"]
TEST_STRATEGY: "Integration test for login after reset flow"
[ISSUE-DIAGNOSIS OUTPUT ENDS]

### Entry 3: Planning
**Gate:** 3
**Timestamp:** 2024-01-15T11:00:30Z
**Actor:** analyst
**Status:** passed
**Attempts:** 1
[ANALYST OUTPUT STARTS]
TEST_TYPE: integration
TEST_LOCATION: test/integration/
FIX_APPROACH: "Clear session token in password reset controller"
[ANALYST OUTPUT ENDS]

### Entry 4: Write Reproduction Test
**Gate:** 4
**Timestamp:** 2024-01-15T11:01:00Z
**Actor:** orchestrator
**Status:** passed
**Attempts:** 2
**Why orchestrator:** Simple integration test <30 lines
**What I did:** Created test reproducing login failure after reset
**Files modified:** ["test/integration/password_reset_login_test.rb"]
**Result:** Test fails as expected - bug confirmed
```

## Key Principles

1. **Diagnosis first** - Understand before fixing
2. **Reproduce before fixing** - Ensure you're fixing the right thing
3. **Minimal changes** - Don't improve, just fix
4. **Regression prevention** - The test stays as protection
5. **No scope creep** - Resist the urge to "improve while you're there"

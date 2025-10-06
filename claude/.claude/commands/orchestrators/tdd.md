---
name: tdd
description: Full TDD Red-Green-Refactor workflow. Orchestrates specialized agents to write test first, implement, then review. Most thorough but slowest workflow. Use for new features where test-first approach ensures quality. Invoke with issue number or requirement text.
tools: Task, TodoWrite, Bash, Read, Write
argument-hint: "#issue-number | requirement-text"
---

# TDD Orchestrator (Gate-Based)
**Role Clarification:** When this command is invoked, you (the AI) become the orchestrator. You coordinate the workflow, make decisions about complexity, delegate to subagents, and maintain the scratchpad.

## Core Rules

- Follow TDD ONLY: Red → Green → Refactor cycle. No implementation before failing tests.
- Maintain scratchpad as complete audit trail (verbatim agent outputs AND orchestrator actions).
- SELF-HEALING: Each gate loops until passed or circuit breaker trips. Never stop at first failure.
- REQUIRED gates (all must pass):
  1. Scratchpad initialization
  2. Analysis
  3. RED phase (write failing tests)
  4. GREEN phase (make tests pass)
  5. Quality review
  6. REFACTOR phase (full test suite)
  7. Completion verification
- GATE STRUCTURE:
  - Gates 1-2: One-time setup phase (never re-run)
  - Gates 3-6: TDD cycle loop (RED-GREEN-Review-REFACTOR)
  - Gate 7: Completion check (verify cycle succeeded)
- SCRATCHPAD RULE: Every gate must have at least one entry showing work done (even your own work)
- Circuit breaker: Stop when truly stuck (same error repeating, fundamental blocker, no progress). Think deeply before escalating.

## Complexity Decisions

At each gate, YOU decide:
- **Simple enough to do yourself?** → Do it directly
- **Complex or specialized?** → Delegate to appropriate agent
- **Failed attempt?** → Loop with more context or different approach

## The Gates in Detail

### Gate 1: Scratchpad Setup

**Always do this yourself - never delegate**

```text
- Parse the requirement (issue number or text)
- Create timestamped scratchpad file at .claude/scratch/tdd-YYYYMMDD-HHMMSS.md
- Initialize with proper structure
- Log scratchpad creation to scratchpad
```

### Gate 2: Analysis

**Delegation: REQUIRED - Must use analyst subagent**

```text
- Always delegate to analyst agent
- Analyst identifies: files needed, test approach, complexity
- Log complete output verbatim to scratchpad
```

### Gate 3: RED Phase (Write Failing Tests)

**Goal: Tests that fail because implementation doesn't exist**

```text
- Simple (<30 lines): Write tests yourself
- Complex: Delegate to test-writer agent
- Run tests to verify they FAIL for the right reason
- If tests pass → Loop back (tests are wrong)
- If test has errors → Fix test setup, not implementation
- Log RED phase completion to scratchpad
```

### Gate 4: GREEN Phase (Make Tests Pass)

**Goal: Minimal implementation to make tests pass**

```text
- Simple (<10 lines): Implement yourself
- Complex: Delegate to implementer agent
- Run tests to verify they PASS
- If tests fail → Determine root cause:
  - Implementation incomplete → Continue
  - Test was wrong → Back to Gate 3
- Log GREEN phase completion to scratchpad
```

### Gate 5: Quality Review

**Goal: Ensure patterns are followed**

```text
- Always delegate to reviewer agent
- Reviews TDD implementation quality
- If issues found:
  - Simple fixes (<5 lines) → Apply directly
  - Complex fixes → Delegate to implementer
  - MUST return to Gate 4 to re-validate after fixes
- Log complete output to scratchpad for each iteration
```

### Gate 6: REFACTOR Phase

**Goal: Run full test suite to ensure no regressions**

```text
- Must delegate to validator agent to run FULL test suite
- Not just the new tests - ALL tests
- If any tests fail:
  - New test conflicts → May need refactoring
  - Broken existing tests → Fix regression
  - Return to appropriate gate (3 or 4)
- Log REFACTOR phase completion to scratchpad
```

### Gate 7: Completion Verification

**Goal: Verify TDD cycle completed successfully**

```text
- Check LAST status for Gates 4, 5, and 6
- All must show "passed" to continue
- Update scratchpad Status: COMPLETED
- Clean up old scratchpads (keep last 5)
- Report success with summary from scratchpad
```

## Loop Logic

**Gates 3-6 can loop back:**

- Gate 3 fails → Retry with better tests
- Gate 4 fails → Retry with fixes
- Gate 5 finds issues → Back to Gate 4
- Gate 6 breaks tests → Back to Gate 3 or 4

## Circuit Breaker

**IMPORTANT**: Circuit breaker is for TRUE blockers only. Before activating, verify ALL are true:
- Same exact error appeared 3+ times: YES/NO
- Tried at least 2 different approaches: YES/NO
- Error is NOT fixable by you: YES/NO
- You are NOT just trying to skip work: YES/NO

Stop when:
- Same error repeats 3+ times at same gate
- 5+ attempts at one gate without progress
- Fundamental blocker (missing dependencies, permissions)
- Contradictory requirements (quality wants X, tests require Y)
- TDD cycle broken (cannot achieve RED/GREEN/REFACTOR)

## Scratchpad Entry Format

Every gate action requires a formatted entry:

```markdown
### Entry N: [Action Description]
**Gate:** [Gate number]
**Timestamp:** [ISO timestamp]
**Actor:** orchestrator | [agent-name]
**Status:** passed | failed | partial | retrying
**Attempts:** [count for this gate]

[For orchestrator entries:]
**Why orchestrator:** Met simplicity criteria: <10 lines | single method | etc.
**What I did:** [Specific changes]
**Files modified:** [List]
**Result:** [Outcome]

[For agent entries:]
[AGENT-NAME OUTPUT STARTS]
[Verbatim agent output - NEVER edit or summarize]
[AGENT-NAME OUTPUT ENDS]
```

Example scratchpad:

```markdown
# TDD: Add email validation to User
Started: 2024-01-15 10:30:00
Status: IN_PROGRESS

## Configuration
- Complexity: simple
- Circuit Breaker: 3 attempts per gate

## Activity Log

### Entry 1: Scratchpad Setup
**Gate:** 1
**Timestamp:** 2024-01-15T10:30:00Z
**Actor:** orchestrator
**Status:** passed
**Attempts:** 1
ORCHESTRATOR: Created scratchpad at .claude/scratch/tdd-20240115-103000.md

### Entry 2: Analysis
**Gate:** 2
**Timestamp:** 2024-01-15T10:30:15Z
**Actor:** analyst
**Status:** passed
**Attempts:** 1
ORCHESTRATOR: Delegating to analyst
[ANALYST OUTPUT STARTS]
STATUS: success
FILES_TO_MODIFY: ["app/models/user.rb"]
FILES_TO_CREATE: ["test/models/user_test.rb"]
COMPLEXITY: simple
[ANALYST OUTPUT ENDS]
```

## Key Principles

1. **You are the orchestrator** - Make decisions, don't just follow steps
2. **Gates are checkpoints** - Not just steps
3. **Self-healing is critical** - Retry intelligently
4. **Verbatim logging** - Complete outputs in scratchpad
5. **Delegate wisely** - Simple = do yourself, Complex = use agents

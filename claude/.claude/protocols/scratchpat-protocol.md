# Scratchpad Protocol
The scratchpad is the orchestrator's memory and audit trail. It maintains state between gates and provides complete visibility into the workflow.

## Scratchpad Structure

```markdown
# [WORKFLOW TYPE]: [Requirement/Issue]
Started: [Timestamp]
Status: IN_PROGRESS | COMPLETED | FAILED

## Configuration
- Branch: issue/234/add-email-validation
- Complexity: simple | moderate | complex
- Circuit Breaker Threshold: 3 attempts per gate

## Activity Log

### GATE 1: [Gate Name] - [Status]
Attempts: 1
[Activity details...]

### GATE 2: [Gate Name] - [Status]
Attempts: 2
[Activity details...]
```

## Key Rules

1. **NEVER summarize** - Copy agent outputs verbatim
2. **Track attempts** - Count loops at each gate
3. **Log decisions** - Document why you delegated or acted directly
4. **Maintain context** - Pass information between gates
5. **Create once** - Never recreate, always append

## Example Scratchpad Entry

```markdown
# TDD: Add email validation to User model
Started: 2024-01-15 10:30:00
Status: IN_PROGRESS

## Configuration
- Branch: issue/234/email-validation
- Complexity: simple
- Circuit Breaker Threshold: 3 attempts per gate

## Activity Log

### GATE 1: Scratchpad Setup - COMPLETE
Attempts: 1
ORCHESTRATOR: Created scratchpad at .claude/scratch/tdd-20240115-103000.md
ORCHESTRATOR: Parsed requirement from issue #234

### GATE 2: Analysis - COMPLETE
Attempts: 1
ORCHESTRATOR: Complexity seems simple, but delegating to analyst for thoroughness
ORCHESTRATOR: Invoking analyst with requirement: "Add email validation to User model"
[ANALYST OUTPUT STARTS]
STATUS: success

SUMMARY:
  what_i_found: "User model exists, needs email format validation"
  complexity: simple

FILES:
  to_modify: ["app/models/user.rb"]
  to_create: ["test/models/user_email_test.rb"]
  patterns_found: ["app/models/account.rb"]

TEST_STRATEGY:
  approach: "Unit tests for validation rules"
  test_types: ["unit"]

NEXT_ACTION:
  recommended_agent: "test-writer"
  reason: "Ready to write failing tests"
[ANALYST OUTPUT ENDS]
ORCHESTRATOR: Analysis complete. Moving to RED phase.

### GATE 3: RED Phase - COMPLETE
Attempts: 2

#### Attempt 1
ORCHESTRATOR: Simple validation, writing test myself
ORCHESTRATOR: Created test/models/user_email_test.rb
ORCHESTRATOR: Running tests...
ERROR: Tests passed but shouldn't have!
ORCHESTRATOR: Test doesn't actually fail. Retrying...

#### Attempt 2
ORCHESTRATOR: Delegating to test-writer for better test coverage
[TEST-WRITER OUTPUT STARTS]
STATUS: success
... [full output] ...
[TEST-WRITER OUTPUT ENDS]
ORCHESTRATOR: Running tests...
ORCHESTRATOR: Tests fail as expected. Gate 3 complete.

### GATE 4: GREEN Phase - IN_PROGRESS
Attempts: 1
ORCHESTRATOR: Delegating to implementer
[Continue...]
```

## State Passing Between Gates

The scratchpad enables gates to share context:

```markdown
### GATE 3 sets context:
TEST_FILES: ["test/models/user_email_test.rb"]
FAILING_TESTS: 3

### GATE 4 uses context:
ORCHESTRATOR: Reading TEST_FILES from Gate 3
ORCHESTRATOR: Implementer needs to fix 3 failing tests
```

## Circuit Breaker Tracking

```markdown
### GATE 4: GREEN Phase - FAILED
Attempts: 3
#### Attempt 3
ORCHESTRATOR: Same error 3 times. Circuit breaker activated.
ORCHESTRATOR: Escalating to user with context:
- Error: undefined method 'email_format_valid?'
- Tried: Creating method, importing module, using built-in validation
- Blocker: Missing dependency or fundamental misunderstanding
```

## Why Verbatim Matters

**Bad (Summary):**
```markdown
Analyst found we need to modify user.rb and create tests.
```

**Good (Verbatim):**
```markdown
[ANALYST OUTPUT STARTS]
STATUS: success
[... complete output ...]
[ANALYST OUTPUT ENDS]
```

The verbatim output enables:
- Debugging when things fail
- Learning from patterns
- Improving prompts based on actual outputs
- Complete audit trail for compliance


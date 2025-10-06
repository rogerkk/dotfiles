# Agent Output Protocol
All agents must follow this output structure for consistent communication with orchestrators.

## Required Output Format

```text
STATUS: success | blocked | failed

SUMMARY:
  what_i_did: "Brief description"
  confidence: high | medium | low
  iterations_used: 1

FILES:
  created: ["path/to/new/file.rb"]
  modified: ["path/to/changed/file.rb"]
  read: ["path/to/examined/file.rb"]

NEXT_ACTION:
  recommended_agent: "agent-name or orchestrator"
  reason: "Why this agent should run next"
  context_forward: "Specific information for next agent"

ERRORS:  # only if blocked/failed
  message: "User-friendly error description"
  details: "Technical details for debugging"
  can_retry: true | false
```

## Status Definitions

- **success**: Task completed successfully
- **blocked**: Cannot proceed without intervention
- **failed**: Attempted but failed (may be retryable)

## Context Forward Rules

The `context_forward` field is critical for agent chaining:

- Be specific: "Fix missing authorization on line 45"
- Include file paths when relevant
- Pass test failures verbatim
- Don't summarize - be explicit

## Example Output

```text
STATUS: success

SUMMARY:
  what_i_did: "Created comprehensive test coverage for User email validation"
  confidence: high
  iterations_used: 1

FILES:
  created: ["test/models/user_email_test.rb"]
  modified: []
  read: ["app/models/user.rb", "test/models/CLAUDE.md"]

NEXT_ACTION:
  recommended_agent: "validator"
  reason: "Run tests to verify they fail as expected"
  context_forward: "Run: bin/rails test test/models/user_email_test.rb"
```

## Integration with Scratchpad

Orchestrators copy agent output verbatim to the scratchpad, creating an audit trail:

```markdown
### GATE 3: RED Phase - Attempt 1
ORCHESTRATOR: Delegating to test-writer...
[AGENT OUTPUT STARTS]
STATUS: success
... [full output] ...
[AGENT OUTPUT ENDS]
ORCHESTRATOR: Tests written, proceeding to validation
```


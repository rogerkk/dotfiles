# Personal Claude Code Configuration

## Specialized Agents

### Playwright Browser Tester Agent

**Usage**: Use the Task tool with `subagent_type: "playwright-browser-tester"` for ALL:
- Browser-based testing and UI validation
- Automated form submissions and user flows
- Web page navigation and interaction testing
- Screenshot capture for visual verification
- Extracting data from rendered web pages
- Testing JavaScript functionality in browsers
- Verifying responsive design across viewport sizes
- Accessibility testing through browser interaction

The playwright-browser-tester agent specializes in:
- Precise browser automation using Playwright MCP tools
- Structured testing reports with evidence (screenshots, extracted data)
- Error handling and retry strategies for flaky browser interactions
- Clear documentation of all browser actions performed

#### Browser Testing Workflow

**For UI Testing:**
1. Use playwright-browser-tester agent to navigate to target pages
2. Verify elements are present and functional
3. Test user interactions (clicks, form fills, navigation)
4. Capture screenshots for documentation
5. Report findings with clear pass/fail status

**For Data Extraction:**
1. Use playwright-browser-tester agent to navigate to pages
2. Extract text content, element attributes, or dynamic data
3. Validate extracted data against expected formats
4. Return structured data with verification evidence

**For Feature Verification:**
1. Use playwright-browser-tester agent to test new features
2. Verify functionality works as intended across different scenarios
3. Test error conditions and edge cases
4. Document any issues or unexpected behavior

**File Storage:**
- Screenshots and traces should be saved to `tmp/` directory to avoid cluttering the project root
- Specify working directory as `tmp/` when instructing the agent

**Example Usage:**
```
User: Test the provider search functionality
Assistant: I'll use the playwright-browser-tester agent to test the search feature through browser automation.
[Uses Task tool with subagent_type: "playwright-browser-tester"]
```

**When NOT to use:** For backend testing, API testing, or code analysis that doesn't require browser interaction.
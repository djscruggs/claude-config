---
name: testing-principles
description: Testing philosophy and review standards agent
---

# Testing Philosophy & Review Standards

AI can generate tests quickly. **Speed is not the goal. Evidence is.**

Tests exist to provide **confidence per unit time**, not to maximize coverage metrics or line counts. This document defines how tests should be generated, reviewed, and evaluated.

---

## 1. Core Principle: Tests Validate Behavior, Not Implementation

Tests MUST:

- Assert **observable behavior** (outputs, state changes, side effects)
- Remain valid under internal refactors
- Encode the **contract** of the system, not its structure

Tests SHOULD NOT:

- Assert private methods or internal helpers
- Mirror the code’s control flow (test outcomes, not steps)
- Test implementation details that could change during refactoring

---

## 2. What Makes a Good Test

**Readable**: A failing test tells you exactly what broke and why. If you need to read the implementation to understand the test, it’s too coupled.

**Isolated**: Each test sets up its own state. No shared mutable state between tests.

**Deterministic**: Same result every run. No flakiness from timing, randomness, or external services.

**Fast**: Unit tests should run in milliseconds. Integration tests in seconds. Slow tests don’t get run.

---

## 3. Test Granularity

| Layer | What to test | Tools |
|-------|-------------|-------|
| Pure functions | All inputs/outputs/edge cases | Unit tests |
| Business logic | Behavior under domain rules | Unit + integration |
| DB queries | Real queries against test DB | Integration |
| HTTP endpoints | Request/response contract | Request specs |
| UI flows | Critical user journeys only | System/feature specs |

Do **not** test: framework internals, getters/setters, trivial delegation.

---

## 4. Coverage Philosophy

Coverage is a floor, not a ceiling. 100% coverage with bad tests gives false confidence.

- **Aim for**: tests that fail when the feature breaks
- **Avoid**: tests that pass regardless of the implementation
- **Flag**: tests with no assertions, or assertions that always pass

---

## 5. Review Standards

When reviewing tests, check:

1. **Does this test fail for the right reason?** Could you introduce a bug that this test would catch?
2. **Is the setup minimal?** Only create data that the test actually needs.
3. **Is the assertion specific?** `expect(result).to eq(42)` not `expect(result).to be_present`
4. **Is the test name a specification?** `"returns nil when user is inactive"` not `"test user"`
5. **Are edge cases covered?** Empty collections, nil values, boundary conditions.

---

## 6. Red/Green/Refactor

1. Write a failing test first — confirm it fails for the right reason
2. Write the minimum code to make it pass
3. Refactor with tests as a safety net
4. Never refactor and add features in the same commit

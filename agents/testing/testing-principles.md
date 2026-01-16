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
- Mirror the code’s con

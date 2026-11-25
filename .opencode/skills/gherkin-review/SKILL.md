---
name: gherkin-review
description: Review and improve Gherkin scenarios in .feature files. Use this when reviewing, rewriting, or writing Gherkin.
---

# Gherkin review

## Goal
Make scenarios clear, declarative, and maintainable. Each scenario tests exactly one behavior.

## Rules

1. **Given / When / Then only.** `And` and `But` may only extend the step type directly before them. Never start a scenario with `And` or `But`.
2. **One behavior per scenario.** Split scenarios that check multiple behaviors, and split input that describes multiple behaviors into separate `Scenario` blocks.
3. **Declarative steps.** "the user confirms the order" instead of "click the button with id btn-submit".
4. **No implementation details.** No CSS selectors, URLs, API paths, or database fields in steps.
5. **Scenario Outline with an Examples table** when cases repeat the same steps with different data. Don't copy-paste scenarios.
6. **Background only** for preconditions that apply to all scenarios.
7. **Consistent language.** The same action uses the same wording throughout the feature.
8. **Edge cases and negative scenarios** only when the feature description asks for them.
9. **Write for non-technical stakeholders.** Avoid technical terms and use plain language.

## Approach

- Read the feature description or user story first. Don't invent behavior that isn't in it.
- Edit the file directly and briefly state the reason for each change.
- Flag ambiguities as questions instead of filling them in yourself.

## Examples

### Rules 3 and 4: declarative steps, no implementation details

Bad (imperative, technical):
```gherkin
Scenario: Ordering
  Given I go to "/shop"
  When I click "#add-btn"
  And I click "#checkout"
  Then I see "Thank you"
```

Better (declarative, one behavior):
```gherkin
Scenario: User orders a product
  Given a customer has a product in the shopping cart
  When the customer confirms the order
  Then the customer receives an order confirmation
```

### Rule 5: Scenario Outline with an Examples table

Bad (copy-pasted scenarios with different data):
```gherkin
Scenario: Shipping costs for a small order
  Given a customer has products worth 30 euros in the shopping cart
  When the customer confirms the order
  Then the customer pays 4.95 euros in shipping costs

Scenario: Shipping costs for a large order
  Given a customer has products worth 60 euros in the shopping cart
  When the customer confirms the order
  Then the customer pays 0 euros in shipping costs
```

Better (one Scenario Outline, one row per case):
```gherkin
Scenario Outline: Shipping costs depend on the order total
  Given a customer has products worth <order total> in the shopping cart
  When the customer confirms the order
  Then the customer pays <shipping costs> in shipping costs

  Examples:
    | order total | shipping costs |
    | 30 euros    | 4.95 euros     |
    | 60 euros    | 0 euros        |
```

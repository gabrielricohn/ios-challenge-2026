# Applaudo iOS Code Challenge

Welcome to the Applaudo iOS Code Challenge. This document describes the features we expect you to deliver. Read it carefully before writing any code.

---

## Context

You have been assigned to a project that is already in progress. The engineering team has set up the project scaffolding, a reusable networking module, a design system, and a basic app shell. Your job is to **bring the app to life** using the tools and patterns already established in the codebase.

The app is a **Cat Breed Explorer** — a simple catalog where users can browse cat breeds, view their details, and register new cat entries locally.

---

## Getting Started

1. Read the project `README.md` for environment setup instructions.
2. Generate the Xcode project using Tuist.
3. Obtain a free API key from [The Cat API](https://developers.thecatapi.com/) and configure it in the project.
4. Explore the existing code before you start writing your own — pay special attention to the `NetworkLayer` module README and the `Components/` and `Theme/` folders.

> Hint: everything you need to understand the networking layer is documented in `modules/NetworkLayer/README.md`.

---

## User Stories

### Story 1 — Browse Cat Breeds

> *As a user, I want to see a list of cat breeds so I can explore the different types of cats available.*

**Acceptance Criteria:**
- The first tab displays a scrollable list of cat breeds fetched from the API.
- Each item shows the breed name and a brief description.
- The list handles loading, empty, and error states gracefully.
- Tapping a breed navigates to a detail screen.

Use the components and theme tokens already available in the project.

---

### Story 2 — Cat Breed Details

> *As a user, I want to view detailed information about a specific cat breed so I can learn more about it.*

**Acceptance Criteria:**
- The detail screen shows at least: an image of the breed, the full description, origin, temperament, and life span.
- The screen is reachable by tapping any breed in the list.
- The user can navigate back to the list.

---

### Story 3 — Register a New Cat (Multi-Step Form)

> *As a user, I want to add a new cat entry through a guided step-by-step form so the information is organized and easy to fill out.*

**Acceptance Criteria:**
- The second tab presents a multi-step form (stepper).
- The form collects at minimum: cat name, breed, age, and a short description.
- Each step is clearly indicated to the user.
- On completion, the cat is saved **locally** on the device and can survive app restarts.
- After saving, the user receives confirmation.

---

### Story 4 (Plus) — Pagination

> *As a user, I want the breed list to load more results as I scroll so I don't have to wait for everything upfront.*

**Acceptance Criteria:**
- The list loads a limited number of breeds initially.
- Additional breeds are fetched automatically as the user scrolls near the bottom.
- A loading indicator is visible while the next page is being fetched.
- Already-loaded breeds remain visible during the fetch.

---

### Story 5 (Plus) — Form Validations

> *As a user, I want to be told when I've entered invalid information so I can correct it before submitting.*

**Acceptance Criteria:**
- Each step of the form validates its fields before allowing the user to proceed.
- Validation errors are displayed inline next to the field.
- The user cannot advance to the next step or submit until the current step is valid.
- Examples of validations: required fields cannot be empty, age must be a positive number, name must have a minimum length.

---

## Technical Expectations

- Use the **architecture and patterns** that best demonstrate your experience (MVVM, Clean, etc.).
- Use **Combine** for reactive data flow — the networking layer is already built around it.
- Use the **existing UI components and theme** — do not reinvent them. Extend them if needed.
- Write code that is **readable, testable, and well-structured**.
- Feel free to add any additional libraries through SPM/Tuist if you can justify the choice.

---

## Evaluation Criteria

| Area | What We Look For |
|------|-----------------|
| **Project Setup** | Ability to get the project running with Tuist and configure the API key |
| **Code Architecture** | Separation of concerns, proper dependency management, scalability |
| **Networking** | Correct use of the existing network layer, proper model definitions, error handling |
| **UI/UX** | Use of provided components/theme, attention to states (loading, empty, error), navigation |
| **Local Storage** | Appropriate choice and implementation of a persistence solution |
| **Swift & SwiftUI** | Idiomatic use of the language and framework |
| **Bonus** | Pagination, form validation, unit tests, any thoughtful extras |

---

## Deliverables

1. A link to your forked repository with the completed challenge.
2. A brief `SOLUTION.md` file in the root of the project explaining:
   - Architecture decisions you made and why.
   - Any trade-offs or assumptions.
   - What you would improve given more time.
3. The app should **compile and run** on the latest Xcode / iOS Simulator.

---

## Time Expectation

You have **1 calendar day** from receiving this challenge. Focus on quality over quantity — a well-implemented core is worth more than rushed extras.

Good luck.

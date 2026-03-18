# Tasks: Project Flare Static Landing Page

**Input**: Design documents from `/specs/001-static-landing-page/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/
**Tests**: Optional (not requested)

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create Terraform scaffolding and static site scaffold.

- [ ] T001 Create `infrastructure/` and `site/` directories
- [x] T001 Create `infrastructure/` and `site/` directories
- [x] T002 Create Terraform scaffolding in `infrastructure/` (`provider.tf`, `variables.tf`, `main.tf`, `outputs.tf`)
- [x] T003 Add sample landing page scaffolding in `site/index.html` (cool colors, modern CSS)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Security, networking, and observability primitives required before deploying the static site.

⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Create Azure Resource Group and core Azure resources in Terraform
- [x] T005 Implement Azure Storage hardening (HTTPS-only, min TLS 1.2, disable public network access)
- [x] T006 Implement Azure Front Door with HTTPS/TLS hardening (min TLS 1.2, HSTS) and WAF policy
- [x] T007 Implement Azure Log Analytics Workspace and Diagnostic Settings (Front Door + Storage)

**Checkpoint**: Foundation ready - landing page deployment can now be wired.

---

## Phase 3: User Story 1 - View Project Flare Landing Page (Priority: P1) 🎯 MVP

**Goal**: Ensure users can access the landing page via Front Door over HTTPS.

**Independent Test**: After deploy, open the Front Door URL and verify Project Flare identity + primary message are visible.

### Implementation for User Story 1

- [x] T008 Configure Storage static website endpoint in Terraform
- [x] T009 Deploy `site/index.html` into the Storage static website content container in Terraform
- [x] T010 Wire Front Door origin to the Storage static website endpoint in Terraform
- [x] T011 Enable required diagnostics coverage (as defined in `infrastructure.yaml`)

---

## Phase 4: User Story 2 - Modern, Visually Appealing Design (Priority: P2)

**Goal**: Provide a visually distinctive landing page with a consistent color palette and modern styling.

**Independent Test**: Review `site/index.html` in a browser for styling consistency and readability on desktop/mobile.

### Implementation for User Story 2

- [x] T012 Implement the landing page visuals in `site/index.html` (modern CSS, accessible contrast)

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Documentation for local validation.

- [x] T013 Add brief README under `infrastructure/` describing `terraform init/plan/apply`
- [x] T014 Update `specs/001-static-landing-page/quickstart.md` if needed to mention the new Terraform folders

# Implementation Plan: Project Flare Static Landing Page

**Branch**: `001-static-landing-page` | **Date**: 2025-03-17 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `specs/001-static-landing-page/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Deliver a single static landing page for Project Flare that is low-cost, highly secure, and visually distinctive. Host static files (HTML, CSS, JavaScript) on **Azure Storage static website** and serve them globally with **Azure Front Door** (HTTPS, caching). All infrastructure is defined in Terraform and deployed in **East US2** per constitution. No server-side runtime; content is static-only (Static-First).

## Technical Context

**Language/Version**: HTML5, CSS3, JavaScript (evergreen); no framework required for MVP  
**Primary Dependencies**: None for static content; Terraform for IaC; Azure provider  
**Storage**: Azure Storage Account with static website enabled (blob container for web files)  
**Testing**: Manual browser testing; optional static analysis / lint (HTML/CSS)  
**Target Platform**: Azure (East US2); delivery to standard web browsers  
**Project Type**: Static website (frontend-only)  
**Performance Goals**: Page load &lt;10 s for first-time visitor (per SC-001); fast repeat loads via Front Door caching  
**Constraints**: East US2 only; HTTPS only; no server-side runtime; low cost  
**Security (enterprise ready)**: Edge HTTPS/TLS hardening (TLS 1.2+ + HSTS), Front Door WAF protection,
storage origin restricted to Front Door only, and centralized logging via Diagnostic Settings to
an Azure Log Analytics Workspace.
**Scale/Scope**: Single landing page; moderate traffic expectations

## High-Level Architecture

Static content is served from **Azure Storage (static website)** and delivered to users through **Azure Front Door**, which provides a single public URL, HTTPS termination, and optional caching. All resources are in **East US2**.

Enterprise security additions (from `infrastructure.yaml`) include:

- **Edge HTTPS/TLS hardening**: HTTPS-only delivery, minimum TLS 1.2, and HSTS.
- **WAF at Front Door**: OWASP managed rules (prevention mode) to reduce common web threats.
- **Storage network hardening**: storage origin restricted so it is reachable only via Front Door.
- **Enterprise logging**: Diagnostic Settings for Front Door traffic and Storage access are
  routed to a centralized Azure Log Analytics Workspace.
- **Diagnostic Settings coverage**: Front Door access/health logs, plus Storage read/write/delete
  access logs, sent to Log Analytics.

The architecture diagram is in **draw.io (diagrams.net)** format: [architecture.xml](./architecture.xml). Open it in [diagrams.net](https://app.diagrams.net/) (File → Open from → Device) to view and edit. Conceptual flow:

```text
  [Visitor]  --HTTPS-->  [Azure Front Door]  --Origin-->  [Azure Storage (Static Website)]
                              (East US2)                        (East US2)
```

### Why This Fits the Static-First Principle

- **Static-First** (Constitution IV) requires: *"The site MUST be delivered as static content (HTML, CSS, JavaScript and static assets). No server-side runtime is required for core site delivery."*
- **Storage + Front Door** matches this exactly:
  - **Azure Storage static website** serves only static files from a blob container. No app server, no server-side code, no dynamic rendering.
  - **Azure Front Door** is a reverse proxy and CDN: it forwards requests to the storage origin and caches responses. It does not execute application code; it only routes and serves static (or cached) content.
- The landing page is authored as static HTML/CSS/JS and deployed as files; no runtime (e.g. Node, .NET, or serverless functions) is required for core delivery. Optional future enhancements (e.g. form submission) could be added later without changing the Static-First nature of the main page.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Verify alignment with `.specify/memory/constitution.md`:

- [x] **Azure-Only**: All hosting/storage/networking use Azure only (Storage, Front Door).
- [x] **East US2**: All resources target region East US2 (compliance).
- [x] **Terraform IaC**: Infrastructure changes are expressed in Terraform; no manual production resource creation.
- [x] **Static-First**: Delivery is static content; no server-side runtime required for core site.
- [x] **Simplicity**: No unjustified complexity; Storage + Front Door are the minimal set for secure, low-cost static hosting with a single URL and HTTPS.

## Project Structure

### Documentation (this feature)

```text
specs/001-static-landing-page/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── architecture.xml    # High-level architecture (draw.io; open in diagrams.net to visualize)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
# Static site content and Terraform
site/                    # Static web files (HTML, CSS, JS, assets)
├── index.html
├── styles/
└── scripts/

infrastructure/          # Terraform (Azure Storage, Front Door; East US2)
├── main.tf
├── variables.tf
├── outputs.tf
└── ...

# Optional
tests/                   # Optional lint / smoke tests
```

**Structure Decision**: Single static site in `site/` and Terraform in `infrastructure/`. No backend or server runtime; all content is static files deployed to Storage.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations; table left empty.

| Violation | Why Needed | Simpler Alternative Rejected Because |
| --- | --- | --- |
| — | — | — |

<!--
Sync Impact Report
==================
Version change: (none) → 1.0.0 (initial ratification)
Modified principles: N/A (initial fill from template)
Added sections: None
Removed sections: None
Templates: plan-template.md ✅ (Constitution Check gates aligned); spec-template.md ✅ (no mandatory section changes); tasks-template.md ✅ (task types compatible)
Commands: .specify/templates/commands/ not present — nothing to update
Follow-up TODOs: None. All placeholders filled.
-->

# Project Flare Constitution

## Core Principles

### I. Azure-Only

All hosting, storage, networking, and supporting cloud resources MUST use Microsoft Azure. No other cloud providers may be used for production or staging environments. Rationale: Ensures a single vendor strategy and consistent security and billing model.

### II. East US2 Region (Compliance)

All Azure resources MUST be deployed in the **East US2** region. No resources may be provisioned in other regions unless explicitly exempted by a documented governance exception. Rationale: Compliance and data residency requirements mandate this region.

### III. Terraform for Infrastructure as Code

All infrastructure MUST be defined and managed via Terraform. Production and staging environments MUST NOT be created or modified by manual portal/CLI actions; changes MUST be applied through Terraform (e.g., `terraform plan` / `terraform apply`) with state stored in a controlled backend. Rationale: Repeatability, auditability, and safe change management.

### IV. Static-First Delivery

The site MUST be delivered as static content (HTML, CSS, JavaScript, and static assets). No server-side runtime is required for core site delivery; use Azure static hosting (e.g., Static Web Apps, Storage + CDN) or equivalent. Rationale: Simplicity, cost, and performance for a static website project.

### V. Simplicity and Justified Complexity

Prefer the simplest design that satisfies requirements (YAGNI). Any addition of services, regions, or architectural complexity MUST be justified in specs or ADRs and aligned with this constitution. Rationale: Keeps the static website project maintainable and within compliance boundaries.

## Platform & Region Constraints

- **Cloud provider**: Azure only.
- **Region**: East US2 only; all resources (storage, CDN, Static Web Apps, etc.) MUST use `eastus2` (or the correct East US2 region identifier in Terraform).
- **IaC**: Terraform only; no Pulumi, Bicep, or ARM templates for net-new infrastructure unless approved as an exception and documented.
- **Static hosting**: Use Azure services suitable for static sites (e.g., Azure Static Web Apps, Blob Storage + Azure CDN) within East US2.

## Development Workflow

- **Infrastructure changes**: Propose via Terraform changes in version control; use `terraform plan` before apply; production applies MUST be traceable (e.g., CI or documented manual apply from a protected branch).
- **Compliance check**: Every plan and spec MUST verify that no resources are introduced outside East US2 and that no non-Azure dependencies are added for hosting.
- **Reviews**: PRs that add or change infrastructure MUST include a Constitution Check (see plan-template) confirming Azure-only, East US2, and Terraform IaC.

## Governance

This constitution supersedes conflicting local practices. Amendments require: (1) documented proposal, (2) version bump per semantic versioning below, (3) update of this file and any referenced templates. All PRs and implementation plans MUST verify compliance with these principles. Use README.md and project docs for day-to-day development guidance.

**Version**: 1.0.0 | **Ratified**: 2025-03-17 | **Last Amended**: 2025-03-17

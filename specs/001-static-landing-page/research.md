# Research: Project Flare Static Landing Page

**Feature**: 001-static-landing-page  
**Date**: 2025-03-17

## Hosting: Azure Storage + Front Door

**Decision**: Use Azure Storage Account (static website) as origin and Azure Front Door as the public entry point. All resources in East US2.

**Rationale**:

- **Static-First**: Storage static website serves only static files; no server-side runtime. Front Door is a reverse proxy/CDN and does not run application code. This matches the constitution’s requirement for static-only delivery.
- **Low-cost**: Storage and Front Door are pay-per-use; no always-on compute. Suitable for a single landing page with moderate traffic.
- **Highly secure**: Front Door provides a single public HTTPS endpoint; backend (Storage) can be restricted to Front Door only. No sensitive data on the page; HTTPS and secure configuration meet spec and constitution.
- **Constitution**: Azure-only and East US2 are satisfied; Terraform will define all resources.

**Alternatives considered**:

- **Azure Static Web Apps**: Simpler for full app frameworks (e.g. React) and integrated CI. For a single static HTML/CSS/JS page, Storage + Front Door is simpler and avoids build pipelines if not needed. Static Web Apps could be adopted later if the site gains dynamic or build steps.
- **Storage only (no Front Door)**: Lower cost but exposes the storage web URL directly; less flexibility for custom domain, WAF, or caching. Front Door adds a single, professional entry point and future-proofing for custom domain and security policies.
- **Azure CDN only**: Front Door is an Azure CDN offering with a single pane for routing, caching, and WAF; chosen for consistency and HTTPS/custom domain support.

## Terraform and region

**Decision**: All infrastructure (Storage, Front Door, and related resources) defined in Terraform; region fixed to East US2.

**Rationale**: Aligns with Constitution III (Terraform IaC) and II (East US2). No NEEDS CLARIFICATION; spec and constitution are sufficient.

## Diagram format

**Decision**: Provide a high-level architecture as a simple XML file (`architecture.xml`) plus a short ASCII flow in the plan.

**Rationale**: XML is machine-parseable and can be extended or imported into diagram tools; the plan’s ASCII diagram gives quick readability. No additional research required.

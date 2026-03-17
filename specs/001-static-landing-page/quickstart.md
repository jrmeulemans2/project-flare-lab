# Quickstart: Project Flare Static Landing Page

**Feature**: 001-static-landing-page

## Prerequisites

- **Terraform**: Installed and on PATH (Azure provider; auth via Azure CLI or env vars).
- **Azure CLI** (optional): For `az login` and local validation.
- **Browser**: For manual testing of the static site.

## Local development (static content only)

1. **Edit the site**  
   - Static files live under `site/` (e.g. `site/index.html`, `site/styles/`, `site/scripts/`).
   - Open `site/index.html` in a browser, or use a simple local server (e.g. `npx serve site` or Python `http.server`) to avoid file:// limitations.

2. **Validate content**  
   - Confirm the page shows "Project Flare" and the primary message.
   - Check on a narrow viewport (e.g. mobile) that layout is usable (per [contracts/landing-page.md](./contracts/landing-page.md)).

## Infrastructure (Terraform)

1. **Configure Azure**  
   - Log in: `az login` (or set `ARM_*` / service principal env vars).
   - Ensure subscription and tenant allow creating Storage and Front Door in **East US2**.

2. **Terraform**  
   - `cd infrastructure/`  
   - `terraform init`  
   - `terraform plan` (review: Storage, Front Door, East US2 only).  
   - `terraform apply` (when ready).

3. **Deploy static files**  
   - After Storage and static website are created, upload contents of `site/` to the Storage static website container (e.g. `az storage blob upload-batch` or Terraform `null_resource` / CI step).  
   - Point Front Door origin at the Storage static website URL.

## Post-deploy validation

- Open the Front Door URL (or custom domain) in a browser over **HTTPS**.
- Verify: Project Flare identity, primary message visible, layout OK on desktop and mobile.
- Confirm no mixed content or HTTP; check [spec.md](./spec.md) and [contracts/landing-page.md](./contracts/landing-page.md).

## Reference

- **Plan**: [plan.md](./plan.md)  
- **Architecture**: [architecture.xml](./architecture.xml)  
- **Constitution**: `.specify/memory/constitution.md` (Azure-only, East US2, Terraform, Static-First).

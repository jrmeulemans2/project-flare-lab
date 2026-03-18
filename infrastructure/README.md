# Project Flare Infrastructure (Terraform)

This directory contains Terraform for the Azure static landing page setup:

- Azure Storage Account (static website)
- Azure Front Door (HTTPS + routing)
- Front Door WAF policy (sample)
- Azure Log Analytics + Diagnostic Settings (Front Door + Storage)

## Prerequisites

- `terraform` on PATH
- Azure credentials (Azure CLI login or service principal)

## Usage

From the repository root:

```bash
cd infrastructure
terraform init
terraform plan
terraform apply
```

## Troubleshooting

- **Static website URL downloads a file instead of showing HTML** — The `index.html` blob must have `Content-Type: text/html`. Run `terraform apply` after pulling latest (blob sets `content_type` in Terraform).
- **Front Door URL shows “page not found” while the storage URL works** — Often **cached 404** from an earlier failed request. In Azure Portal: **Front Door profile → Endpoints → your endpoint → Purge** (purge `/*` or `/`). Also confirm **Origin host header** on the storage origin equals your static website hostname (e.g. `st….z20.web.core.windows.net`), per [Microsoft Q&A on Front Door origin host header](https://learn.microsoft.com/en-us/answers/questions/1703055/issues-with-front-door-and-the-origin-host-header).

## Security & Observability

- TLS: minimum TLS 1.2 on Storage and Front Door
- HTTPS-only at the edge (Front Door) and Storage HTTPS-only
- Storage: `storage_public_network_access_enabled` defaults to **true** so Terraform can upload blobs from your network. Set to **false** only if you run `apply` from a path that can reach the account via private endpoint.
- WAF: Standard SKU (managed OWASP rules require Premium Front Door)
- Logs: Diagnostic Settings routed to Log Analytics (`law-flare-prod`)


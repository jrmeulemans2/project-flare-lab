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

## Security & Observability

- TLS: minimum TLS 1.2 on Storage and Front Door
- HTTPS-only at the edge (Front Door) and Storage HTTPS-only
- WAF: OWASP-managed rules (verify association behavior with your provider version)
- Logs: Diagnostic Settings routed to Log Analytics (`law-flare-prod`)


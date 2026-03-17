# Contract: Public Landing Page

**Feature**: 001-static-landing-page  
**Type**: Public static page (browser)

## Endpoint / Resource

- **URL**: Base URL of the site (e.g. `https://<front-door-host>/` or `https://<custom-domain>/`).
- **Method**: GET.
- **Response**: HTML document (content-type `text/html`).

## Contract (what the page MUST provide)

1. **Identity**: The document MUST identify the site as "Project Flare" (e.g. in `<title>`, and/or visible heading/logo text).
2. **Primary message**: The document MUST present the primary message or value proposition for Project Flare in visible content (not only in meta tags).
3. **Usability**: The document MUST be structured so that core content is visible and readable on common desktop and mobile viewports (no requirement for specific breakpoints; layout must not break or hide core content).
4. **Security**: The site MUST be served over HTTPS in production (enforced by Front Door / hosting, not by this contract).

## Out of scope for this contract

- Forms, analytics, or client-side behavior beyond loading and displaying content.
- Specific HTML structure or CSS classes (implementation detail).
- API or non-browser consumers (this is a human-readable landing page).

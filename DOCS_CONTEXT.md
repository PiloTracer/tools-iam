# Tools IAM - Project Context

## Overview
**Tools IAM** is the centralized Identity and Access Management system for the CodeIva ecosystem. It utilizes Keycloak to provide Authentication, Authorization, and User Management services.

## Core Objectives
1.  **Centralized Auth**: Single Sign-On (SSO) for all related applications.
2.  **User Management**: Administration of users, roles, and groups.
3.  **Security**: Robust Identity implementation using standard protocols (OIDC, SAML, OAuth2).

## Architecture
- **Service**: Keycloak (Dockerized)
- **Database**: PostgreSQL
- **Persistence**: Local Docker volumes (dev) / Managed DB (prd)

## Confirmed Features (2026-01-17)
- **Google Authenticator (OTP)**: Native support enabled via Policy.
- **Social Login**: Google OAuth ready.
- **Registration Flow**: "Zero Access" pattern documented for Admin Approval.
- **Port Mapping**: Postgres host port custom binding (15434).

## Critical Constraints
- **Data Privacy**: No real user data in development. Use synthetic users only.
- **Port Isolation**: Service runs on specific ports (Configured via env) to avoid conflicts with other local tools.
- **Git Hygiene**: No secrets in repo. All config via `.env`.

## Integration Points
- **CodeIva App**: Will consume this IAM provider.
- **FastAPI Services**: Will validate tokens issued by this IAM.

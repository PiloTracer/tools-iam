# IAM System - Walkthrough & Configuration Guide

**Version**: 1.0.0
**Date**: 2026-01-17
**Service**: Keycloak 23.0

## 1. System Overview
The Tools IAM system provides centralized authentication for the CodeIva ecosystem. It runs as a Dockerized service backed by PostgreSQL.

### Core Components
- **Identity Provider**: Keycloak
- **Database**: PostgreSQL (Port 15434 host binding)
- **Management**: `bin/start.sh` (Automation script)

## 2. Setup & Initialization

### Prerequisites
- Docker & Docker Compose
- `.env` configuration (copied from `.env.example`)

### Quick Start
```bash
# 1. Setup Environment
cp .env.example .env.dev

# 2. Start Services
./bin/start.sh dev

# 3. Access Admin Console
# URL: http://localhost:8080
# Default Creds: admin / admin (Check .env.dev)
```

## 3. Configuration Patterns

### 3.1 Google Authenticator (OTP)
Keycloak supports standard OTP without plugins.
**Status**: Natively Supported.

**Implementation Steps**:
1.  **Admin Console** > **Authentication** > **Policies** > **OTP Policy**.
    - Verify defaults (Time Based, SHA1, 30s).
2.  **Authentication** > **Required Actions**.
    - Find "Configure OTP".
    - Check "Enabled" (Allows users to set it up).
    - Check "Default Action" (Forces setup on next login).

### 3.2 Google OAuth (Social Login)
Allows users to sign in with their Google accounts.
**Status**: Natively Supported.

**Google Cloud Setup**:
1.  Create OAuth Credentials (Web Application).
2.  **Redirect URI**: `http://localhost:8080/realms/{YOUR_REALM}/broker/google/endpoint`

**Keycloak Setup**:
1.  **Identity Providers** > **Add** > **Google**.
2.  Paste **Client ID** and **Client Secret**.
3.  Save.

### 3.3 Email Authentication
Enabling "Login with Email" instead of just Username.

**Configuration**:
1.  **Realm Settings** > **Login**.
2.  Enable **Email as username** (Simpler, 1:1 mapping).
3.  **SMTP Setup** (Required for emails):
    - **Realm Settings** > **Email**.
    - Configure Host/Port (Use Mailhog for local dev).

### 3.4 User Registration & Authorization
Managing new user sign-ups patterns.

**Pattern A: Open Registration**
- **Realm Settings** > **Login** > Enable **User registration**.

**Pattern B: Admin Approval (Zero Access)**
1.  Enable Registration.
2.  **Realm Settings** > **User registration** > **Default Roles**.
3.  **Remove** any roles that grant application access.
4.  **Flow**: User registers -> Has no access -> Admin manually assigns role.

## 4. Maintenance

### Backups
```bash
./bin/start.sh
# Select Option 7 (Backup)
# Creates .tar.gz archives in backups_tools-iam/
```

### Restore
```bash
./bin/start.sh
# Select Option 6 (RESTORE BACKUP)
# WARNING: Overwrites current database!
```

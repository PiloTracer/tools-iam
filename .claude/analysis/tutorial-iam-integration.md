# Tutorial: Integrating Applications with Tools IAM

This guide explains how to connect an external application (e.g., CodeIva Dashboard, FastAPI Service) for authentication against this IAM system.

## 1. Realm Setup
Do not use `master` realm for applications. Create a dedicated realm.

1.  **Create Realm**:
    - Name: `codeiva-ecosystem`
    - Enabled: ON

## 2. Client Registration (OIDC)

### For Frontend (Next.js / React)
1.  **Clients** > **Create Client**.
    - **Client ID**: `codeiva-dashboard`
    - **Capability Config**:
        - Client Authentication: **OFF** (Public Client).
        - Standard Flow: **ON**.
        - Direct Access Grants: **OFF** (Recommended).
    - **Access Settings**:
    - **Access Settings**:
        - Valid Redirect URIs: `http://localhost:3000/api/auth/callback/keycloak`
        - Web Origins: `http://localhost:3000` (CORS).
    - *Note*: `localhost:3000` assumes your Frontend App runs on port 3000. Adjust if different.

### For Backend (FastAPI / Node)
1.  **Clients** > **Create Client**.
    - **Client ID**: `codeiva-backend`
    - **Capability Config**:
        - Client Authentication: **ON** (Confidential Client).
        - Service Accounts Enabled: **ON** (Machine-to-Machine).

## 3. Integration Code Examples

### Next.js (NextAuth.js)
```javascript
// [...nextauth].ts
providers: [
  KeycloakProvider({
    clientId: "codeiva-dashboard",
    clientSecret: "", // Empty for public client
    issuer: "http://localhost:18090/realms/codeiva-ecosystem",
  })
]
```

### FastAPI (Python)
Use `python-keycloak` or standard JWT validation.

```python
from fastapi.security import OAuth2AuthorizationCodeBearer

oauth2_scheme = OAuth2AuthorizationCodeBearer(
    authorizationUrl="http://localhost:18090/realms/codeiva-ecosystem/protocol/openid-connect/auth",
    tokenUrl="http://localhost:18090/realms/codeiva-ecosystem/protocol/openid-connect/token"
)

# Validate JWT signature against Realm Public Key
# Endpoint: http://localhost:8080/realms/codeiva-ecosystem/protocol/openid-connect/certs
```

61: ## 4. Testing the Flow
62: 1.  Start your app.
63: 2.  Click "Login".
64: 3.  Redirect to Keycloak (`localhost:18090`).
4.  Enter credentials / Login with Google.
5.  Redirect back to App with Token.

#!/usr/bin/env bash

# start.sh - Tools IAM Docker Environment Manager
# Supports: dev, stg, prd

# 1. Determine Project Root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 2. Argument Parsing / Environment Detection
TARGET_ENV="$1"

if [ -z "$TARGET_ENV" ]; then
    # Auto-detection logic
    count=0
    [ -f "$PROJECT_ROOT/.env.dev" ] && count=$((count+1)) && FOUND_ENV="dev"
    [ -f "$PROJECT_ROOT/.env.stg" ] && count=$((count+1)) && FOUND_ENV="stg"
    [ -f "$PROJECT_ROOT/.env.prd" ] && count=$((count+1)) && FOUND_ENV="prd"

    if [ $count -eq 1 ]; then
        TARGET_ENV="$FOUND_ENV"
        echo "Auto-detected environment: $TARGET_ENV"
    elif [ $count -eq 0 ]; then
        echo "❌ No .env files found in $PROJECT_ROOT"
        echo "Please copy .env.example to .env.dev, .env.stg, or .env.prd"
        exit 1
    else
        # Prompt user
        echo "Multiple environments found. Select one:"
        echo "1) Development (dev)"
        echo "2) Staging (stg)"
        echo "3) Production (prd)"
        read -p "Select option [1-3]: " env_opt
        case $env_opt in
            1) TARGET_ENV="dev" ;;
            2) TARGET_ENV="stg" ;;
            3) TARGET_ENV="prd" ;;
            *) echo "Invalid option"; exit 1 ;;
        esac
    fi
else
    # Normalize argument
    TARGET_ENV=$(echo "$TARGET_ENV" | tr '[:upper:]' '[:lower:]')
    if [[ "$TARGET_ENV" != "dev" && "$TARGET_ENV" != "stg" && "$TARGET_ENV" != "prd" ]]; then
        echo "❌ Invalid environment specified: $TARGET_ENV"
        echo "Usage: ./bin/start.sh [dev|stg|prd]"
        exit 1
    fi
fi

# 3. Configure Paths & Variables
case $TARGET_ENV in
    dev)
        COMPOSE_FILE="$PROJECT_ROOT/docker-compose.dev.yml"
        ENV_FILE="$PROJECT_ROOT/.env.dev"
        ;;
    stg)
        COMPOSE_FILE="$PROJECT_ROOT/docker-compose.stg.yml"
        ENV_FILE="$PROJECT_ROOT/.env.stg"
        ;;
    prd)
        COMPOSE_FILE="$PROJECT_ROOT/docker-compose.prd.yml"
        ENV_FILE="$PROJECT_ROOT/.env.prd"
        ;;
esac

# 4. Load Project Name & Suffix
if [ -f "$ENV_FILE" ]; then
    PROJ_NAME=$(grep "^COMPOSE_PROJECT_NAME=" "$ENV_FILE" | cut -d= -f2 | tr -d '"' | tr -d "'" | tr -d '\r')
    RAW_SUFFIX=$(grep "^DEPLOY_SUFFIX=" "$ENV_FILE" | cut -d= -f2 | tr -d '"' | tr -d "'" | tr -d '\r')
    export DEPLOY_SUFFIX=$(echo "$RAW_SUFFIX" | tr '[:upper:]' '[:lower:]')
fi

if [ -z "$PROJ_NAME" ]; then
    PROJ_NAME="tools-iam" # Default project name
fi

VOL_PREFIX="${PROJ_NAME}_"
PG_VOLUME="${VOL_PREFIX}pg_data"

# Detect Docker Compose
if docker compose version &>/dev/null; then
    DOCKER_COMPOSE="docker compose"
elif docker-compose version &>/dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "ERROR: Neither 'docker compose' nor 'docker-compose' found."
    exit 1
fi

echo "========================================="
echo "   IAM Docker Manager"
echo "========================================="
echo "Environment:    $TARGET_ENV"
echo "Project Name:   $PROJ_NAME"
echo "Deploy Suffix:  $DEPLOY_SUFFIX"
echo "Compose File:   $COMPOSE_FILE"
echo "========================================="
echo ""

pause() {
  read -n1 -r -p "Press any key to continue..." key
  echo
}

# 5. Core Functions

up() {
  clear
  echo "Bringing up environment ($TARGET_ENV)..."
  if ! $DOCKER_COMPOSE -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d --build; then
     echo "❌ Startup failed."
     pause
     return
  fi
  
  echo ""
  echo "✅ Environment is up!"
  $DOCKER_COMPOSE -f "$COMPOSE_FILE" --env-file "$ENV_FILE" ps
  pause
}

down() {
  clear
  echo "Stopping environment..."
  $DOCKER_COMPOSE -f "$COMPOSE_FILE" --env-file "$ENV_FILE" down --remove-orphans
  echo "Environment stopped."
  pause
}

restart() {
  clear
  echo "Restarting environment..."
  $DOCKER_COMPOSE -f "$COMPOSE_FILE" --env-file "$ENV_FILE" restart
  echo "Restart complete."
  pause
}

view_logs() {
  clear
  echo "Logs (Ctrl+C to exit)..."
  $DOCKER_COMPOSE -f "$COMPOSE_FILE" --env-file "$ENV_FILE" logs -f --tail=100
  pause
}

# 6. Main Menu
while true; do
  clear
  echo "========================================="
  echo "   IAM Manager: $TARGET_ENV"
  echo "========================================="
  echo " 1. Up (Build & Start)"
  echo " 2. Down (Stop)"
  echo " 3. Restart"
  echo " 4. View Logs"
  echo " 0. Exit"
  echo "========================================="
  read -p "Select: " opt
  case $opt in
    1) up ;;
    2) down ;;
    3) restart ;;
    4) view_logs ;;
    0) exit 0 ;;
    *) ;;
  esac
done

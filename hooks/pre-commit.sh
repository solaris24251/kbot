#!/bin/sh

# Use a variable to store the path to the .git directory
GIT_DIR=$(git rev-parse --git-dir)

# Check if the pre-commit file exists in the .git/hooks directory
if [ -f "$GIT_DIR/hooks/pre-commit" ]; then
    set -e
    "$GIT_DIR/hooks/pre-commit" "$@"
    set +e
fi

# Function to prompt the user for a yes/no response
# Return codes:
#   0: user entered yes
#   10: user entered no
#
prompt_yn() {
    local prompt ans
    if [ $# -ge 1 ]; then
        prompt="$1"
    else
        prompt="Continue?"
    fi

    while true; do
        # Allows us to read user input below, assigns stdin to keyboard (from Stackoverflow)
        exec </dev/tty
        read -r -p "$prompt [y/n] " ans
        exec <&-
        case "$ans" in
        Y | y | yes | YES | Yes)
            return 0
            ;;
        N | n | no | NO | No)
            return 10
            ;;
        esac
    done
}

run_gitleaks() {
    # Run gitleaks with the protect flag to check changes
    # Running _without_ `--redact` is safer in a local development
    # env, as you need unobfuscated feedback on whether you're
    # committing a real password, or an example one.
    cmd="$HOME/bin/gitleaks protect --staged --config=$HOME/.git-support/gitleaks.toml --verbose"
    $cmd
    status=$?
    if [ $status -eq 1 ]; then
        cat <<-\EOF
	Error: gitleaks has detected sensitive information in your changes.
	If you know what you are doing you can disable this check using:
	    SKIP=gitleaks git commit ...
	or using shell history:
	    SKIP=gitleaks !! 
EOF
        exit 1
    else
        exit $status
    fi
}

skip_gitleaks() {
    if prompt_yn "Do you want to SKIP gitleaks?"; then
        echo "Skipping..."
        exit 0
    else
        echo "Cancelled."
        exit 10
    fi
}

# Check if gitleaks check is enabled
gitleaksEnabled=$(git config --bool hooks.gitleaks)
if [ "$gitleaksEnabled" = "false" ]; then
    echo "You're skipping gitleaks since hooks.gitleaks is 'false'"
    skip_gitleaks
# Check if SKIP=gitleaks flag is set
elif [ "$SKIP" = "gitleaks" ]; then
    echo "You're skipping gitleaks since SKIP=gitleaks"
    skip_gitleaks
else
    run_gitleaks
fi
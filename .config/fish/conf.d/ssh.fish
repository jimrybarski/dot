#!/usr/bin/env fish

# cache SSH key password
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c > /dev/null)
end
set -x SSH_AUTH_SOCK $SSH_AUTH_SOCK
set -x SSH_AGENT_PID $SSH_AGENT_PID

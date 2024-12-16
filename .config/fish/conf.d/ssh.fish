#!/usr/bin/env fish

if test -z (pgrep ssh-agent | string collect)
    eval (ssh-agent -c | head -n2)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

function lazy_ssh_add --description 'Add ssh key to ssh-agent on first ssh usage'
   if test (ssh-add -L | wc -l) -eq 0
       echo "Adding SSH key to ssh-agent..."
       ssh-add
   end
end

function ssh
   lazy_ssh_add
   command ssh $argv
end

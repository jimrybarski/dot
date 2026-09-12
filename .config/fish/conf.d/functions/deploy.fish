function deploy --description 'Build and restart jim-helper on api.rybarski.com'
    # No TTY needed: root's github.com key is the passphrase-less deploy key,
    # so this is safe to run unattended (cron, CI) as well as by hand.
    # bash -l because `ssh host cmd` is a non-login, non-interactive shell and
    # won't source the profile that puts cargo on PATH.
    ssh web 'bash -l deploy.sh'
end

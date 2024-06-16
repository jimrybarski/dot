#!/usr/bin/env fish
# Configures the prompt.

# Hides the vi mode
function fish_mode_prompt
end

# Sets the prompt
function fish_prompt
    # Sets the prompt to look something like the below (note the execution time of the previous command on the right):
    # jim@desktop [13:28:53] [√] /home/jim $                                       1.2 s
    # or if there was an error, it shows the exit status instead of a checkmark:
    # jim@desktop [13:30:24] [127] /home/jim $                                 0.011 s 

    # Store the last command status, since it will get overwritten once we run any of the commands below
    set last_status $status
    # Get the current time
    set time (date +"%H:%M:%S")
    # Determine the last command's exit status
    if test $last_status -eq 0
        set status_indicator (set_color green)√(set_color normal)
    else
        set status_indicator (set_color red)$last_status(set_color normal)
    end
    # Construct the prompt
    set_color green
    echo -n "$USER@$hostname"
    set_color normal
    echo -n " [$time] [$status_indicator] $PWD \$ "
end

# Get the duration of the last command in seconds
function fish_right_prompt
    set cmd_duration (math $CMD_DURATION / 1000)
    echo -n (set_color yellow) "$cmd_duration s" (set_color normal)
end

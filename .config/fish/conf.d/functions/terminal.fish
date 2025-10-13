# Does the equivalent of Bash's `sudo !!`
function ugh
    eval command sudo $history[1]
end

# Displays the 16 (or 8) colors available to us, as text colors and background colors
function print_colors ()
    printf "|039| \033[39mWhite \033[m    |049| \033[49mClear \033[m    |037| \033[37mLight gray \033[m     |047| \033[30m\033[47mLight gray \033[m\n"
    printf "|030| \033[30mBlack \033[m    |040| \033[40mBlack \033[m    |090| \033[90mDark gray \033[m      |100| \033[100mDark gray \033[m\n"
    printf "|031| \033[31mRed \033[m      |041| \033[30m\033[41mRed \033[m      |091| \033[91mLight red \033[m      |101| \033[30m\033[101mLight red \033[m\n"
    printf "|032| \033[32mGreen \033[m    |042| \033[30m\033[42mGreen \033[m    |092| \033[92mLight green \033[m    |102| \033[30m\033[102mLight green \033[m\n"
    printf "|033| \033[33mYellow \033[m   |043| \033[30m\033[43mYellow \033[m   |093| \033[93mLight yellow \033[m   |103| \033[30m\033[103mLight yellow \033[m\n"
    printf "|034| \033[34mBlue \033[m     |044| \033[30m\033[44mBlue \033[m     |094| \033[94mLight blue \033[m     |104| \033[30m\033[104mLight blue \033[m\n"
    printf "|035| \033[35mMagenta \033[m  |045| \033[30m\033[45mMagenta \033[m  |095| \033[95mLight magenta \033[m  |105| \033[30m\033[105mLight magenta \033[m\n"
    printf "|036| \033[36mCyan \033[m     |046| \033[30m\033[46mCyan \033[m     |096| \033[96mLight cyan \033[m     |106| \033[30m\033[106mLight cyan \033[m\n"
end

# Explain a command's usage
function man ()
    tldr $argv[1] --color=always | bat
end

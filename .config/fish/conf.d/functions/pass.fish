#!/usr/bin/env fish

function otp
    set code (pass otp/$argv[1])
    while true
        sleep 1
        oathtool --totp -b $code | xclip -i -selection clipboard
    end
end

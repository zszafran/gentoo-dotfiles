xsetroot -cursor_name left_ptr &
xset s off &
xset -dpms &
compton -b &
nitrogen --restore &
urxvtd --quiet --opendisplay --fork &
/opt/google/chrome/google-chrome --no-startup-window &
synapse &
exec xmonad

# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import qtile

mod = "mod4"
terminal = "kitty"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "i", lazy.layout.grow(), desc="Grow window to the left"),
    Key([mod, "control"], "u", lazy.layout.shrink(), desc="Grow window to the right"),
    Key([mod, "control"], "o", lazy.layout.maximize(), desc="Grow window down"),
    # Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod, "control"], "f", lazy.window.bring_to_front()),    
]

groups = [Group(i) for i in "1234567"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

def init_layout_theme():
    return {
        "border_focus":"#bd93f9", 
        "border_normal":"#4c566a", 
        "margin":[3,3,3,3], 
        "border_width":2
    }
layout_theme = init_layout_theme()

layouts = [
    # layout.Columns(**layout_theme),
    # layout.Max(**layout_theme),    
     layout.MonadTall(margin=5, border_width=2, border_focus="#E5E9F0", border_normal="#4c566a"),    
     layout.MonadWide(margin=5, border_width=2, border_focus="#E5E9F0", border_normal="#4c566a"),    
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(margin=5, border_width=2, border_focus="#ffb86c", border_normal="#4c566a", border_on_single=True, add_on_top=False),
    # layout.Matrix(),
    # layout.RatioTile(),
    # layout.Tile(margin=5, border_width=2, border_focus="#ffb86c", border_normal="#4c566a", border_on_single=True, add_on_top=False),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=9,
    padding=4,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
		wallpaper='/home/icat/.config/qtile/wallpps/kali.jpg',
		wallpaper_mode='fill',
        top=bar.Bar(
            [
                widget.CurrentLayout(fmt=' Monad', foreground='#8be9fd'),
                widget.GroupBox(highlight_method='block'),
                widget.Prompt(foreground='#bd93f9'),
                widget.WindowName(foreground='#f8f8f2', for_current_screen=True, max_chars=80),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ffffff", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#50fa7b"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                # widget.Systray(),
                widget.TextBox("[[", name="default",foreground="#ffffff"),           
                widget.TextBox("WIN", name="default",foreground="#9ddcfc",
                    mouse_callbacks = {
                        'Button1': lambda: qtile.spawn('/bin/bash /home/icat/.config/qtile/scripts/widget.sh -w start'),
                        'Button3': lambda: qtile.spawn('/bin/bash /home/icat/.config/qtile/scripts/widget.sh -w stop') 
                    },                    
                ),                                                                
                widget.TextBox("|", name="default",foreground="#ffffff"),                           
                widget.TextBox("SET", name="default",foreground="#bd93f9", scroll=True,
                    mouse_callbacks = {'Button1': lambda: qtile.spawn('xfce4-settings-manager')}
                ),
                widget.TextBox("SCR", name="default",foreground="#bd93f9", scroll=True,
                    mouse_callbacks = {'Button1': lambda: qtile.spawn('xfce4-screenshooter')}
                ),
                widget.TextBox("CON", name="default",foreground="#bd93f9",
                    ## nmcli  -- wifi
                    ## arandr -- screen
                    ##        -- bluetooth
                    mouse_callbacks = {'Button1': lambda: qtile.spawn('/bin/bash /home/icat/.config/qtile/scripts/widget.sh -d')}
                ),                
                widget.TextBox("CAM", name="default",foreground="#bd93f9",
                    mouse_callbacks = {
                        'Button1': lambda: qtile.spawn('/bin/bash /home/icat/.config/qtile/scripts/widget.sh -c start'),
                        'Button3': lambda: qtile.spawn('/bin/bash /home/icat/.config/qtile/scripts/widget.sh -c stop')                 
                    }, 
                ),                
                widget.TextBox("REC", name="default",foreground="#bd93f9",
                    mouse_callbacks = {
                        'Button1': lambda: qtile.spawn('/bin/bash /home/icat/.config/qtile/scripts/widget.sh -f start'),
                        'Button3': lambda: qtile.spawn('/bin/bash /home/icat/.config/qtile/scripts/widget.sh -f stop') 
                    },                    
                ),                                
                widget.TextBox("]]", name="default",foreground="#ffffff"),                           
                widget.Pomodoro(color_inactive='#BF616A', color_active='#50fa7b', color_break='#ffb86c'),
				widget.Net(interface="wlp2s0",format='{down:4.2f}{down_suffix:<2} ↓↑ {up:4.2f}{up_suffix:<2}',prefix='M',foreground="#f1fa8c",
                                # widget.Net(interface="wlp2s0", format='{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}', prefix='M',foreground="#f1fa8c",
                    mouse_callbacks = {'Button1': lambda: qtile.spawn('nm-connection-editor')} 
                ),
                widget.Clock(format="%Y-%m-%d | %I:%M:%S %p",foreground="#ff79c6",
                    mouse_callbacks = {'Button1': lambda: qtile.spawn('xfce4-terminal -e calcurse')}                    
                    ),
				widget.Battery(format='BAT {percent:2.0%} {hour:d}:{min:02d}', foreground="#88C0D0"),
				widget.CPU(format='CPU {load_percent}%', foreground="#EBCB8B"),
				widget.Memory(format='RAM {MemUsed:.0f}{mm}', foreground="#B48EAD"),
				widget.Volume(fmt='VOL {}', foreground="#BEFB89",
                    mouse_callbacks = {'Button1': lambda: qtile.spawn('xfce4-terminal -e alsamixer')}                    
                ),
                widget.TextBox("Zzz", name="default",foreground="#bd93f9",
                    mouse_callbacks = {'Button1': lambda: qtile.spawn('systemctl suspend')}
                ),                
                # widget.QuickExit(foreground="#ff5555"),
            ],
            24,
            opacity=0.80,
            margin=[5,0,0,0],
#            border_width=[2, 2, 2, 2],  # Draw top and bottom borders
            border_color=["bd93f9", "bd93f9", "bd93f9", "bd93f9"]  # Borders are magenta
        ),
    ),
    Screen(
        wallpaper='/home/icat/.config/qtile/wallpps/kali.jpg',
        wallpaper_mode='fill'
    )
]

# Drag floating layouts.
mouse = [
    Drag([mod, "shift"], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod, "control"], "Button1", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_width=2, border_focus="#88C0D0", border_normal="#88C0D0",
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

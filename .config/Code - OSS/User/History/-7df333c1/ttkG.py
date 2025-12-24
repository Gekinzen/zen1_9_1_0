"""
Hyprland Control Center - GTK4 + Libadwaita
Single-file template: hyprland_control_center.py

Features:
- Libadwaita GTK4 UI with sidebar navigation
- Pages: Wallpapers, Themes, Hyprland, Rofi, Waybar, Animations
- JSON settings backend at ~/.config/hypr/settings.json
- Save/write Hyprland config snippets to ~/.config/hypr/hyprland_controls.conf
- Run shell commands (e.g., hyprctl) safely with subprocess

Dependencies (Arch):
  sudo pacman -S python-gobject gtk4 libadwaita xdg-desktop-portal
  # For optional: pillow (for thumbnails)
  pip install Pillow

Run:
  python hyprland_control_center.py

Notes:
- This is a template. Each page contains example controls and stub functions you can extend.
- The app writes to ~/.config/hypr/settings.json by default.

"""

from gi.repository import Gio, GLib, Gtk, Adw
import subprocess
import json
import os
from pathlib import Path
from datetime import datetime

# Initialize Adwaita
Adw.init()

CONFIG_DIR = Path.home() / '.config' / 'hypr'
CONFIG_DIR.mkdir(parents=True, exist_ok=True)
SETTINGS_FILE = CONFIG_DIR / 'settings.json'
HYPR_SNIPPET = CONFIG_DIR / 'hyprland_controls.conf'

DEFAULT_SETTINGS = {
    'theme': 'adw-dark',
    'wallpaper': '',
    'rofi_cmd': 'rofi -show drun',
    'waybar_enabled': True,
    'animations': True,
}


def load_settings():
    if SETTINGS_FILE.exists():
        try:
            with open(SETTINGS_FILE, 'r') as f:
                return json.load(f)
        except Exception:
            return DEFAULT_SETTINGS.copy()
    return DEFAULT_SETTINGS.copy()


def save_settings(data: dict):
    try:
        with open(SETTINGS_FILE, 'w') as f:
            json.dump(data, f, indent=2)
        return True
    except Exception as e:
        print('Error saving settings:', e)
        return False


def run_command(cmd_list, capture=False):
    """Run a shell command safely and return output if requested."""
    try:
        if capture:
            out = subprocess.check_output(cmd_list, stderr=subprocess.STDOUT)
            return out.decode('utf-8')
        else:
            subprocess.check_call(cmd_list)
            return ''
    except subprocess.CalledProcessError as e:
        return f'ERROR: {e.returncode} - {e.output.decode("utf-8") if e.output else ""}'
    except Exception as e:
        return f'ERROR: {e}'


class HyprControlApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id='com.example.HyprControl')
        self.connect('activate', self.on_activate)
        self.settings = load_settings()

    def on_activate(self, app):
        win = Adw.ApplicationWindow(application=app)
        win.set_title('Hyprland Control Center')
        win.set_default_size(900, 600)

        root = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        root.get_style_context().add_class('root')
        win.set_content(root)

        # Sidebar (listbox)
        sidebar = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        sidebar.set_valign(Gtk.Align.FILL)
        sidebar.set_size_request(220, -1)

        # Header
        header = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        title = Gtk.Label(label='Hyprland Control')
        title.get_style_context().add_class('title')
        subtitle = Gtk.Label(label='All-in-one settings panel')
        subtitle.get_style_context().add_class('dim-label')
        header.append(title)
        header.append(subtitle)
        sidebar.append(header)

        # Stack for content
        stack = Gtk.Stack()
        stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT)

        pages = {}

        # Create pages
        pages['wallpaper'] = self.build_wallpaper_page()
        pages['themes'] = self.build_themes_page()
        pages['hypr'] = self.build_hypr_page()
        pages['rofi'] = self.build_rofi_page()
        pages['waybar'] = self.build_waybar_page()
        pages['animations'] = self.build_animations_page()

        for k, w in pages.items():
            stack.add_titled(w, k, k.capitalize())

        # Sidebar buttons
        for key, label in [('wallpaper', 'Wallpapers'), ('themes', 'Themes'), ('hypr', 'Hyprland'), ('rofi', 'Rofi'), ('waybar', 'Waybar'), ('animations', 'Animations')]:
            btn = Gtk.Button(label=label)
            btn.set_halign(Gtk.Align.FILL)
            btn.connect('clicked', lambda b, k=key: stack.set_visible_child_name(k))
            sidebar.append(btn)

        # Save / Apply row
        apply_btn = Gtk.Button(label='Save & Apply')
        apply_btn.connect('clicked', self.on_save_apply)
        sidebar.append(apply_btn)

        root.append(sidebar)
        root.append(stack)

        win.present()
        self.win = win
        self.stack = stack
        self.pages = pages

    # ---------------------- Page Builders ----------------------
    def build_wallpaper_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        box.set_margin_top(12)
        box.set_margin_start(12)

        label = Gtk.Label(label='Wallpaper')
        label.set_halign(Gtk.Align.START)
        box.append(label)

        entry = Gtk.Entry()
        entry.set_text(self.settings.get('wallpaper', ''))
        entry.set_placeholder_text('Path to wallpaper image')
        box.append(entry)

        chooser = Gtk.Button(label='Pick File')
        def on_choose(_):
            dialog = Gtk.FileDialog()
            dialog.set_modal(True)
            dialog.set_select_multiple(False)
            response = dialog.open(self.win)
            # FileDialog returns list; simplified when available
        chooser.connect('clicked', on_choose)
        box.append(chooser)

        # Preview & apply button (stub)
        apply = Gtk.Button(label='Set as wallpaper (apply via swaybg/wayland)')
        def on_set(_):
            path = entry.get_text()
            if path:
                self.settings['wallpaper'] = path
                save_settings(self.settings)
                # Example: use swaybg replacement or hyprland command
                run_command(['wl-rootston', '--background', path])
        apply.connect('clicked', on_set)
        box.append(apply)

        self.wallpaper_entry = entry
        return box

    def build_themes_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        box.set_margin_top(12)
        box.set_margin_start(12)

        label = Gtk.Label(label='Theme (Libadwaita)')
        box.append(label)

        combo = Gtk.DropDown.new_from_strings(['adw-dark', 'adw-light'])
        combo.set_selected(0 if self.settings.get('theme') == 'adw-dark' else 1)
        def on_theme_changed(dd):
            idx = dd.get_selected()
            self.settings['theme'] = 'adw-dark' if idx == 0 else 'adw-light'
        combo.connect('notify::selected', on_theme_changed)
        box.append(combo)

        return box

    def build_hypr_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        box.set_margin_top(12)
        box.set_margin_start(12)

        label = Gtk.Label(label='Hyprland shortcuts / snippets')
        box.append(label)

        txt = Gtk.TextView()
        txt.set_size_request(-1, 300)
        if HYPR_SNIPPET.exists():
            with open(HYPR_SNIPPET, 'r') as f:
                txt.get_buffer().set_text(f.read())
        box.append(txt)

        def save_snip(_):
            start, end = txt.get_buffer().get_bounds()
            data = txt.get_buffer().get_text(start, end, True)
            with open(HYPR_SNIPPET, 'w') as f:
                f.write(data)
            # optionally reload hypr
            run_command(['hyprctl', 'reload'])
        sbtn = Gtk.Button(label='Save & Reload Hyprland')
        sbtn.connect('clicked', save_snip)
        box.append(sbtn)

        return box

    def build_rofi_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        box.set_margin_top(12)
        box.set_margin_start(12)

        label = Gtk.Label(label='Rofi launcher command')
        box.append(label)

        entry = Gtk.Entry()
        entry.set_text(self.settings.get('rofi_cmd', 'rofi -show drun'))
        box.append(entry)

        def test_run(_):
            cmd = entry.get_text().split()
            run_command(cmd)
        tbtn = Gtk.Button(label='Test Rofi Command')
        tbtn.connect('clicked', test_run)
        box.append(tbtn)

        self.rofi_entry = entry
        return box

    def build_waybar_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        box.set_margin_top(12)
        box.set_margin_start(12)

        label = Gtk.Label(label='Waybar')
        box.append(label)

        switch = Gtk.Switch()
        switch.set_active(self.settings.get('waybar_enabled', True))
        box.append(Gtk.Label(label='Enable Waybar'))
        box.append(switch)

        def on_toggle(s, g):
            self.settings['waybar_enabled'] = s.get_active()
        switch.connect('state-set', lambda s, v: on_toggle(s, v))

        return box

    def build_animations_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        box.set_margin_top(12)
        box.set_margin_start(12)

        label = Gtk.Label(label='Animations')
        box.append(label)

        switch = Gtk.Switch()
        switch.set_active(self.settings.get('animations', True))
        box.append(Gtk.Label(label='Enable animations'))
        box.append(switch)

        def on_toggle(s, v):
            self.settings['animations'] = s.get_active()
        switch.connect('state-set', lambda s, v: on_toggle(s, v))

        return box

    # ---------------------- Actions ----------------------
    def on_save_apply(self, _):
        # gather values from there (simple example)
        if hasattr(self, 'wallpaper_entry'):
            self.settings['wallpaper'] = self.wallpaper_entry.get_text()
        if hasattr(self, 'rofi_entry'):
            self.settings['rofi_cmd'] = self.rofi_entry.get_text()
        save_settings(self.settings)

        # write hypr snippet header
        with open(HYPR_SNIPPET, 'a') as f:
            f.write(f'# Applied: {datetime.now().isoformat()}\n')
            f.write('# This file is managed by Hyprland Control Center\n')

        # Optionally call hyprctl to reload
        out = run_command(['hyprctl', 'reload'], capture=True)
        dialog = Gtk.MessageDialog(transient_for=self.win, flags=0, message_type=Gtk.MessageType.INFO, buttons=Gtk.ButtonsType.OK, text='Saved and reloaded')
        dialog.format_secondary_text(str(out)[:1000])
        dialog.present()


if __name__ == '__main__':
    app = HyprControlApp()
    app.run(None)

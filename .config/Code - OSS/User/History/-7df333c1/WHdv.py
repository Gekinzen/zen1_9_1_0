"""
Hyprland Control Center - KDE / PikaOS Style
Single-file template: hypr_settings_kde.py

Features:
- KDE-style Sidebar with Category Headers (Workspace, System, etc.)
- "About this System" page that fetches REAL hardware info.
- Clean, centered layout mimicking the screenshot.
"""

import sys
import json
import subprocess
import platform
import psutil # Needs: sudo pacman -S python-psutil
import distro # Needs: sudo pacman -S python-distro
from pathlib import Path

import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')
from gi.repository import Gio, GLib, Gtk, Adw, Gdk

# Initialize Adwaita
Adw.init()

# --- Custom CSS to match the KDE Dark Look ---
CSS = """
.sidebar-header {
    font-weight: bold;
    font-size: 11px;
    color: alpha(@window_fg_color, 0.5);
    margin-top: 16px;
    margin-bottom: 4px;
    margin-left: 12px;
    text-transform: uppercase;
}

.sidebar-row {
    padding: 8px 12px;
    border-radius: 6px;
    margin: 2px 8px;
}

.sidebar-row:selected {
    background-color: @accent_bg_color;
    color: @accent_fg_color;
}

.sidebar-row:hover {
    background-color: alpha(@window_fg_color, 0.05);
}

.about-section-title {
    font-weight: bold;
    margin-top: 24px;
    margin-bottom: 8px;
    opacity: 0.8;
}

.info-label {
    font-size: 13px;
    color: alpha(@window_fg_color, 0.7);
}

.value-label {
    font-size: 13px;
    font-weight: 500;
}
"""

class SystemInfo:
    @staticmethod
    def get_info():
        # Get OS Info
        os_name = f"{distro.name()} {distro.version()}"
        kernel = platform.release()
        
        # Get Hyprland Version (safe try)
        try:
            hypr_v = subprocess.check_output(['hyprctl', 'version'], text=True).split('\n')[0]
            hypr_v = hypr_v.replace("Hyprland, built from branch  at commit ", "")[:10] # Shorten
        except:
            hypr_v = "Unknown"

        # Get CPU
        try:
            # Linux command for cleaner CPU name
            cpu = subprocess.check_output("grep -m1 'model name' /proc/cpuinfo", shell=True, text=True)
            cpu = cpu.split(':')[1].strip()
        except:
            cpu = platform.processor()

        # Get RAM
        ram = psutil.virtual_memory()
        ram_gb = round(ram.total / (1024**3), 1)

        # Get GPU (Basic LSPCI check, simplistic)
        try:
            gpu = subprocess.check_output("lspci | grep -i vga", shell=True, text=True).split(':')[2].strip()
        except:
            gpu = "Unknown GPU"

        return {
            "os": os_name,
            "kernel": kernel,
            "wm": f"Hyprland ({hypr_v})",
            "cpu": cpu,
            "ram": f"{ram_gb} GiB of RAM",
            "gpu": gpu,
            "graphics_platform": "Wayland"
        }

class HyprKDEApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id='com.example.HyprKDE', flags=Gio.ApplicationFlags.FLAGS_NONE)
        
        # Load CSS
        provider = Gtk.CssProvider()
        provider.load_from_data(CSS.encode('utf-8'))
        Gtk.StyleContext.add_provider_for_display(Gdk.Display.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

    def do_activate(self):
        win = Adw.ApplicationWindow(application=self)
        win.set_title('Control Center')
        win.set_default_size(1000, 750)
        win.set_size_request(900, 600)

        # Main Layout: Sidebar (Left) + Content (Right)
        main_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        win.set_content(main_box)

        # --- Sidebar Setup ---
        sidebar_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        sidebar_box.set_size_request(260, -1)
        sidebar_box.add_css_class("background") # Darker background

        # Search Bar
        search_bar = Gtk.SearchEntry(placeholder_text="Search...")
        search_bar.set_margin_top(12)
        search_bar.set_margin_bottom(8)
        search_bar.set_margin_start(12)
        search_bar.set_margin_end(12)
        sidebar_box.append(search_bar)

        # Scrolled Sidebar List
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_vexpand(True)
        scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        self.sidebar_list = Gtk.ListBox()
        self.sidebar_list.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self.sidebar_list.connect("row-selected", self.on_row_selected)
        scrolled.set_child(self.sidebar_list)
        sidebar_box.append(scrolled)

        main_box.append(sidebar_box)
        main_box.append(Gtk.Separator(orientation=Gtk.Orientation.VERTICAL))

        # --- Content Area Setup ---
        self.content_stack = Gtk.Stack()
        self.content_stack.set_transition_type(Gtk.StackTransitionType.CROSSFADE)
        self.content_stack.set_vexpand(True)
        self.content_stack.set_hexpand(True)
        
        # We wrap stack in a box to add the HeaderBar look
        content_area = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        content_area.set_hexpand(True)
        
        # Dynamic Header (changes based on selection)
        self.page_header_label = Gtk.Label(label="About this System", css_classes=["title-2"])
        header_bar = Adw.HeaderBar(show_end_title_buttons=True, show_start_title_buttons=False)
        header_bar.set_title_widget(self.page_header_label)
        
        # "Copy Details" button like in screenshot
        copy_btn = Gtk.Button(label="Copy Details", icon_name="edit-copy-symbolic")
        copy_btn.add_css_class("flat")
        header_bar.pack_end(copy_btn)
        
        content_area.append(header_bar)
        content_area.append(self.content_stack)
        main_box.append(content_area)

        # --- Build Sidebar & Pages ---
        # Structure: Category -> [(ID, Label, Icon)]
        menu_data = [
            ("Workspace", [
                ("behavior", "General Behavior", "preferences-desktop-display-symbolic"),
                ("search", "Search", "system-search-symbolic"),
            ]),
            ("Security & Privacy", [
                ("lock", "Screen Locking", "system-lock-screen-symbolic"),
            ]),
            ("System", [
                ("about", "About this System", "computer-symbolic"),
                ("power", "Power Management", "battery-symbolic"),
                ("users", "Users", "avatar-default-symbolic"),
                ("autostart", "Autostart", "media-playback-start-symbolic"),
            ])
        ]

        # Populate
        first_page = True
        for category, items in menu_data:
            # 1. Add Category Header
            header = Gtk.Label(label=category, xalign=0)
            header.add_css_class("sidebar-header")
            # Create a non-selectable row for header
            h_row = Gtk.ListBoxRow()
            h_row.set_selectable(False)
            h_row.set_activatable(False)
            h_row.set_child(header)
            self.sidebar_list.append(h_row)

            # 2. Add Items
            for pid, label, icon in items:
                # Add to Sidebar
                row_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
                row_box.add_css_class("sidebar-row")
                
                img = Gtk.Image.new_from_icon_name(icon)
                lbl = Gtk.Label(label=label)
                
                row_box.append(img)
                row_box.append(lbl)
                
                row = Gtk.ListBoxRow()
                row.set_child(row_box)
                row._page_id = pid
                row._page_title = label
                self.sidebar_list.append(row)

                # Add to Stack
                if pid == "about":
                    self.content_stack.add_named(self.build_about_page(), pid)
                else:
                    self.content_stack.add_named(self.build_placeholder(label), pid)
                
                if first_page and pid == "about": 
                    # Select About by default
                    self.sidebar_list.select_row(row)
                    first_page = False

        # If about wasn't first, force select it now
        # (Loop logic above might select first item, we want About specifically if possible, 
        # but for this logic, let's just let user click or default to first)
        
        win.present()

    def on_row_selected(self, box, row):
        if row and hasattr(row, '_page_id'):
            self.content_stack.set_visible_child_name(row._page_id)
            self.page_header_label.set_label(f"{row._page_title} — System Settings")

    # --- Page Builders ---

    def build_about_page(self):
        sys_info = SystemInfo.get_info()
        
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scroll.set_vexpand(True)
        
        # Main vertical alignment
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        vbox.set_valign(Gtk.Align.START)
        vbox.set_halign(Gtk.Align.CENTER)
        vbox.set_margin_top(48)
        vbox.set_margin_bottom(48)
        
        # 1. Logo Section
        # Try to find a distro logo, fallback to generic
        logo_icon_name = "archlinux-logo" if "Arch" in sys_info['os'] else "computer-symbolic"
        logo = Gtk.Image.new_from_icon_name(logo_icon_name)
        logo.set_pixel_size(128)
        logo.set_margin_bottom(16)
        vbox.append(logo)
        
        # OS Title
        os_title = Gtk.Label(label=sys_info['os'])
        os_title.add_css_class("title-1")
        vbox.append(os_title)
        
        # Link
        link = Gtk.LinkButton(uri="https://archlinux.org", label="https://archlinux.org/")
        link.set_margin_bottom(32)
        vbox.append(link)

        # 2. Information Grid
        # We use a clamp to keep width reasonable
        clamp = Adw.Clamp(maximum_size=500)
        grid_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=24)
        
        # Software Section
        soft_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        soft_box.append(Gtk.Label(label="Software", css_classes=["about-section-title"], xalign=0.5))
        
        self.add_info_row(soft_box, "OS Version:", sys_info['os'])
        self.add_info_row(soft_box, "Kernel Version:", sys_info['kernel'])
        self.add_info_row(soft_box, "Window Manager:", sys_info['wm'])
        self.add_info_row(soft_box, "Graphics Platform:", sys_info['graphics_platform'])
        grid_box.append(soft_box)

        # Hardware Section
        hard_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        hard_box.append(Gtk.Label(label="Hardware", css_classes=["about-section-title"], xalign=0.5))
        
        self.add_info_row(hard_box, "Processors:", sys_info['cpu'])
        self.add_info_row(hard_box, "Memory:", sys_info['ram'])
        self.add_info_row(hard_box, "Graphics Processor:", sys_info['gpu'])
        grid_box.append(hard_box)

        clamp.set_child(grid_box)
        vbox.append(clamp)
        
        scroll.set_child(vbox)
        return scroll

    def add_info_row(self, parent, label_text, value_text):
        row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        row.set_halign(Gtk.Align.CENTER) # Center the pair
        
        lbl = Gtk.Label(label=label_text, xalign=1)
        lbl.add_css_class("info-label")
        lbl.set_size_request(140, -1) # Fixed width for alignment
        
        val = Gtk.Label(label=value_text, xalign=0)
        val.add_css_class("value-label")
        
        row.append(lbl)
        row.append(val)
        parent.append(row)

    def build_placeholder(self, title):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        box.set_valign(Gtk.Align.CENTER)
        box.set_halign(Gtk.Align.CENTER)
        
        icon = Gtk.Image.new_from_icon_name("preferences-system-symbolic")
        icon.set_pixel_size(64)
        icon.set_opacity(0.5)
        
        lbl = Gtk.Label(label=f"{title} Settings")
        lbl.add_css_class("title-2")
        
        sub = Gtk.Label(label="This panel is under construction.")
        sub.add_css_class("dim-label")
        
        box.append(icon)
        box.append(lbl)
        box.append(sub)
        return box

if __name__ == '__main__':
    app = HyprKDEApp()
    app.run(sys.argv)
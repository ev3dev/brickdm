/*
 * brickman -- Brick Manager for LEGO MINDSTORMS EV3/ev3dev
 *
 * Copyright (C) 2014-2015 David Lechner <david@lechnology.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * ControlPanel.vala:
 *
 * Control Panel for driving GtkFramebuffer
 */

using Gtk;

namespace BrickManager {
    public class ControlPanel : Object {
        const string CONTROL_PANEL_GLADE_FILE = "ControlPanel.glade";

        public Gtk.Window window;
        public FakeFileBrowserController file_browser_controller;
        public FakeDeviceBrowserController device_browser_controller;
        public FakeNetworkController network_controller;
        public FakeSoundController sound_controller;
        public FakeBluetoothController bluetooth_controller;
        public FakeBatteryController battery_controller;
        public FakeAboutController about_controller;
        public FakeOpenRobertaController open_roberta_controller;

        enum Tab {
            DEVICE_BROWSER,
            NETWORK,
            SOUND,
            BLUETOOTH,
            BATTERY,
            OPEN_ROBERTA,
            ABOUT
        }

        enum NetworkNotebookTab {
            MAIN,
            CONNECTIONS,
            CONNECTION_INFO,
            WIFI,
            WIFI_INFO,
            TETHERING
        }

        enum PortsColumn {
            PRESENT,
            DEVICE_NAME,
            ADDRESS,
            DRIVER_NAME,
            MODE,
            MODES,
            STATUS,
            CAN_SET_DEVICE,
            USER_DATA,
            COLUMN_COUNT;
        }

        enum SensorsColumn {
            PRESENT,
            DEVICE_NAME,
            DRIVER_NAME,
            ADDRESS,
            FW_VERSION,
            POLL_MS,
            MODES,
            MODE,
            NUM_VALUES,
            DECIMALS,
            UNITS,
            COMMANDS,
            USER_DATA,
            COLUMN_COUNT;
        }

        enum TachoMotorsColumn {
            PRESENT,
            DEVICE_NAME,
            ADDRESS,
            DRIVER_NAME,
            POLARITY,
            RUNNING,
            USER_DATA,
            COLUMN_COUNT;
        }

        enum NetworkConnectionsColumn {
            PRESENT,
            CONNECTED,
            NAME,
            TYPE,
            USER_DATA,
            COLUMN_COUNT;
        }

        enum NetworkWifiColumn {
            PRESENT,
            CONNECTED,
            NAME,
            SECURITY,
            STRENGTH,
            USER_DATA,
            COLUMN_COUNT;
        }

        enum NetworkConnectionInfoDnsColumn {
            ADDRESS,
            COLUMN_COUNT;
        }

        enum NetworkTetherColumn {
            PRESENT,
            NAME,
            ENABLED,
            USER_DATA,
            COLUMN_COUNT;
        }

        enum SoundMixerElementsColumn {
            NAME,
            INDEX,
            VOLUME,
            CAN_MUTE,
            MUTE,
            USER_DATA
        }

        enum BluetoothDeviceColumn {
            PRESENT,
            NAME,
            ADAPTER,
            CONNECTED,
            USER_DATA,
            COLUMN_COUNT;
        }

        public ControlPanel () {
            var builder = new Builder ();
            try {
                builder.add_from_file (CONTROL_PANEL_GLADE_FILE);
                window = builder.get_object ("control_panel_window") as Gtk.Window;

                file_browser_controller = new FakeFileBrowserController (builder);
                device_browser_controller = new FakeDeviceBrowserController (builder);
                network_controller = new FakeNetworkController (builder);
                sound_controller = new FakeSoundController (builder);
                bluetooth_controller = new FakeBluetoothController (builder);
                battery_controller = new FakeBatteryController (builder);
                about_controller = new FakeAboutController (builder);
                open_roberta_controller = new FakeOpenRobertaController (builder);

                builder.connect_signals (this);
                window.show_all ();
            } catch (Error err) {
                critical ("ControlPanel init failed: %s", err.message);
            }
        }

        [CCode (instance_pos = -1)]
        public void on_quit_button_clicked (Gtk.Button button) {
            Ev3devKitDesktop.GtkApp.quit ();
        }

        internal static void update_listview_toggle_item (Gtk.ListStore store,
            CellRendererToggle toggle, string path, int column)
        {
            TreePath tree_path = new TreePath.from_string (path);
            TreeIter iter;
            store.get_iter (out iter, tree_path);
            store.set (iter, column, !toggle.active);
        }

        internal static void update_listview_text_item (Gtk.ListStore store,
            string path, string new_text, int column)
        {
            TreePath tree_path = new TreePath.from_string (path);
            TreeIter iter;
            store.get_iter (out iter, tree_path);
            store.set (iter, column, new_text);
        }
    }
}

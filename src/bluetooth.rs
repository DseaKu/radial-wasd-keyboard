use esp32_nimble::{BLEAdvertisementData, BLEDevice, BLEHIDDevice, BLEServer, BLECharacteristic};
use esp32_nimble::utilities::mutex::Mutex;
use std::sync::Arc;

// HID Report Descriptor for a standard Keyboard
const HID_REPORT_DISCRIPTOR: &[u8] = &[
    0x05, 0x01, 0x09, 0x06, 0xA1, 0x01, 0x85, 0x01, 0x05, 0x07, 0x19, 0xE0, 0x29, 0xE7, 0x15, 0x00,
    0x25, 0x01, 0x75, 0x01, 0x95, 0x08, 0x81, 0x02, 0x95, 0x01, 0x75, 0x08, 0x81, 0x01, 0x95, 0x06,
    0x75, 0x08, 0x15, 0x00, 0x25, 0x65, 0x05, 0x07, 0x19, 0x00, 0x29, 0x65, 0x81, 0x00, 0xC0,
];

/// Manages the BLE HID device state and communication.
pub struct BluetoothDevice {
    server: &'static mut BLEServer,
    input_report: Arc<Mutex<BLECharacteristic>>,
}

impl BluetoothDevice {
    /// Initializes the BLE stack, HID service, and starts advertising.
    pub fn new() -> anyhow::Result<Self> {
        let ble_device = BLEDevice::take();
        let server = ble_device.get_server();
        let mut hid = BLEHIDDevice::new(server);

        // Configure HID device identity
        hid.manufacturer("Espressif");
        hid.pnp(0x02, 0x05ac, 0x820a, 0x0210);
        hid.report_map(HID_REPORT_DISCRIPTOR);

        let input_report = hid.input_report(1);
        
        // Start BLE advertising
        let mut adv = ble_device.get_advertising().lock();
        adv.set_data(
            BLEAdvertisementData::new()
                .name("DIY GamePad")
                .appearance(0x03C1) // HID Keyboard
                .add_service_uuid(hid.hid_service().lock().uuid()),
        )?;
        adv.start()?;

        log::info!("BLE Keyboard started...");
        Ok(Self { server, input_report })
    }

    /// Sends a HID report to the connected host.
    pub fn send_report(&self, report: &[u8]) {
        if self.server.connected_count() > 0 {
            self.input_report.lock().set_value(report).notify();
        }
    }

    /// Returns the number of currently connected BLE clients.
    pub fn connected_count(&self) -> usize {
        self.server.connected_count()
    }
}

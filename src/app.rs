use crate::hardware::InputPeripherals;
use esp_idf_hal::delay::FreeRtos;
use esp32_nimble::{BLEAdvertisementData, BLEDevice, BLEHIDDevice};
use log::info;

pub struct App<'d> {
    ip: InputPeripherals<'d>,
}

const HID_REPORT_DISCRIPTOR: &[u8] = &[
    0x05, 0x01, // Usage Page (Generic Desktop)
    0x09, 0x06, // Usage (Keyboard)
    0xA1, 0x01, // Collection (Application)
    0x85, 0x01, // Report ID (1)
    0x05, 0x07, // Usage Page (Key Codes)
    0x19, 0xE0, // Usage Minimum (224)
    0x29, 0xE7, // Usage Maximum (231)
    0x15, 0x00, // Logical Minimum (0)
    0x25, 0x01, // Logical Maximum (1)
    0x75, 0x01, // Report Size (1)
    0x95, 0x08, // Report Count (8)
    0x81, 0x02, // Input (Data, Variable, Absolute)
    0x95, 0x01, // Report Count (1)
    0x75, 0x08, // Report Size (8)
    0x81, 0x01, // Input (Constant)
    0x95, 0x06, // Report Count (6)
    0x75, 0x08, // Report Size (8)
    0x15, 0x00, // Logical Minimum (0)
    0x25, 0x65, // Logical Maximum (101)
    0x05, 0x07, // Usage Page (Key Codes)
    0x19, 0x00, // Usage Minimum (0)
    0x29, 0x65, // Usage Maximum (101)
    0x81, 0x00, // Input (Data, Array)
    0xC0, // End Collection
];

impl<'d> App<'d> {
    pub fn new(ip: InputPeripherals<'d>) -> Self {
        Self { ip }
    }

    pub fn run(&mut self) -> anyhow::Result<()> {
        let ble_device = BLEDevice::take();
        let ble_server = ble_device.get_server();
        let mut ble_hid = BLEHIDDevice::new(ble_server);

        ble_hid.manufacturer("Espressif");
        ble_hid.pnp(0x02, 0x05ac, 0x820a, 0x0210); // Apple Keyboard PnP
        ble_hid.report_map(HID_REPORT_DISCRIPTOR);

        let input_report = ble_hid.input_report(1);

        let ble_advertising = ble_device.get_advertising();
        {
            let mut adv = ble_advertising.lock();
            adv.set_data(
                BLEAdvertisementData::new()
                    .name("DIY GamePad")
                    .appearance(0x03C1) // Keyboard
                    .add_service_uuid(ble_hid.hid_service().lock().uuid()),
            )?;
            adv.start()?;
        }

        info!("BLE HID Keyboard started and advertising...");

        loop {
            let dir_x = self.ip.analog_stick.get_x_hid_code().unwrap();

            let code = dir_x;
            let mut report = [0u8; 8];
            if code != 0 {
                report[2] = code;
            }

            if ble_server.connected_count() > 0 {
                input_report.lock().set_value(&report).notify();
                info!("Sent: {:?}", dir_x);
                FreeRtos::delay_ms(7);
            }

            FreeRtos::delay_ms(20);
        }
    }
}

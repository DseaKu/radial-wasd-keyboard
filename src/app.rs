use crate::bluetooth::BluetoothDevice;
use crate::hardware::InputPeripherals;
use esp_idf_hal::delay::FreeRtos;
use log::info;

/// Main application structure.
pub struct App<'a> {
    input_peripherals: InputPeripherals<'a>,
    bluetooth_device: BluetoothDevice,
}

impl<'d> App<'d> {
    pub fn new(input_peripherals: InputPeripherals<'d>, bluetooth_device: BluetoothDevice) -> Self {
        Self {
            input_peripherals,
            bluetooth_device,
        }
    }

    /// Main execution loop
    pub fn run(&mut self) -> anyhow::Result<()> {
        let mut report = [0u8; 8];

        loop {
            let mut has_update = false;

            // Poll hardware for changes
            self.input_peripherals.poll();

            // Check for X-axis movement
            if let Some(code_x) = self.input_peripherals.analog_stick.get_x_hid_code() {
                report[2] = code_x.into_inner();
                has_update = true;
            }

            // Check for Y-axis movement
            if let Some(code_y) = self.input_peripherals.analog_stick.get_y_hid_code() {
                report[3] = code_y.into_inner();
                has_update = true;
            }

            // Only send report if there's a connection and an update
            if self.bluetooth_device.connected_count() > 0 && has_update {
                // Pack the array to remove 0x00 gaps that break OS parsing
                let mut packed_report = [0u8; 8];
                let mut pack_idx = 2;

                for &keycode in &report[2..] {
                    if keycode != 0 {
                        packed_report[pack_idx] = keycode;
                        pack_idx += 1;
                    }
                }

                self.bluetooth_device.send_report(&packed_report);
                info!("Sent HID report: {:?}", &packed_report[2..4]);
            }

            FreeRtos::delay_ms(20);
        }
    }
}

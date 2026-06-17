use anyhow::Ok;
use esp_idf_hal::peripherals::Peripherals;

pub mod analog_stick;
pub use analog_stick::AnalogStick;

mod hardware_bridge_esp32;
use hardware_bridge_esp32::Esp32AdcReader;
type AnalogHardware<'a> = Esp32AdcReader<'a>;

/// Collection of all input hardware components.
pub struct InputPeripherals<'a> {
    hardware: AnalogHardware<'a>,
    pub analog_stick: AnalogStick,
}

impl<'a> InputPeripherals<'a> {
    /// Initializes hardware peripherals (ADC and pins).
    pub fn new(p: Peripherals) -> anyhow::Result<Self> {
        Ok(Self {
            hardware: AnalogHardware::new(p.adc1, p.pins.gpio3, p.pins.gpio2)?,
            analog_stick: AnalogStick::default(),
        })
    }

    /// Reads raw data from hardware and updates component states.
    pub fn poll(&mut self) {
        let raw_x = self.hardware.poll_x_axis();
        let raw_y = self.hardware.poll_y_axis();

        // Update state of XY-axis with new ADC values
        self.analog_stick.update(raw_x, raw_y);
    }
}

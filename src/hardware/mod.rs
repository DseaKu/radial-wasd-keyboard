use anyhow::Ok;
use esp_idf_hal::peripherals::Peripherals;

pub mod analog_stick;
pub use analog_stick::AnalogStick;

mod hardware_bridge_esp32;
use hardware_bridge_esp32::Esp32AdcReader;
type AnalogHardware<'a> = Esp32AdcReader<'a>;

pub struct InputPeripherals<'a> {
    hardware: AnalogHardware<'a>,
    pub analog_stick: AnalogStick,
}

impl<'a> InputPeripherals<'a> {
    pub fn new(p: Peripherals) -> anyhow::Result<Self> {
        Ok(Self {
            hardware: AnalogHardware::new(p.adc1, p.pins.gpio3, p.pins.gpio2)?,
            analog_stick: AnalogStick::default(),
        })
    }
    pub fn update(&mut self) {
        let raw_x = self.hardware.read_pin_x();
        let raw_y = self.hardware.read_pin_y();

        // log::info!(
        //     "Raw X: {}, Raw Y: {}",
        //     raw_x.into_inner(),
        //     raw_y.into_inner()
        // );

        self.analog_stick.update(raw_x, raw_y);
    }
}

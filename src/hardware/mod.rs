pub mod analog_stick;

use esp_idf_hal::peripherals::Peripherals;
pub use analog_stick::AnalogStick;

pub struct InputPeripherals<'d> {
    pub analog_stick: AnalogStick<'d>,
}

impl<'d> InputPeripherals<'d> {
    pub fn new(p: Peripherals) -> anyhow::Result<Self> {
        Ok(Self {
            analog_stick: AnalogStick::new(p.adc1, p.pins.gpio3, p.pins.gpio2)?,
        })
    }
}

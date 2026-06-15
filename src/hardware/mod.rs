mod adc_interface;
pub mod analog_stick;

pub use analog_stick::AnalogStick;
use esp_idf_hal::peripherals::Peripherals;

pub struct InputPeripherals<'a> {
    pub analog_stick: AnalogStick<'a>,
}

impl<'a> InputPeripherals<'a> {
    pub fn new(p: Peripherals) -> anyhow::Result<Self> {
        Ok(Self {
            analog_stick: AnalogStick::new(p.adc1, p.pins.gpio3, p.pins.gpio2)?,
        })
    }
}

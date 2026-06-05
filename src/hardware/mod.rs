use crate::hardware::analog_stick::AnalogStick;
mod analog_stick;

use esp_hal::peripherals;

pub struct InputPeripherals {
    pub analog_stick: AnalogStick,
}

impl InputPeripherals {
    pub fn init(p: peripherals::Peripherals) -> Self {
        Self {
            analog_stick: AnalogStick::init(p),
        }
    }
}

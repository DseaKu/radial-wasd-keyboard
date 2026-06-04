use esp_hal::gpio::Output;
use esp_hal::gpio::{Level, OutputConfig};

pub struct Hardware {
    pub led: Output<'static>,
}

impl Hardware {
    pub fn init(p: esp_hal::peripherals::Peripherals) -> Hardware {
        Self {
            led: Output::new(p.GPIO8, Level::Low, OutputConfig::default()),
        }
    }
}

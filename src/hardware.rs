use esp_hal::Blocking;
use esp_hal::analog::adc::{Adc, AdcConfig, AdcPin, Attenuation};
use esp_hal::gpio::Output;
use esp_hal::gpio::{Level, OutputConfig};
use esp_hal::peripherals::{ADC1, GPIO3};

pub struct Hardware {
    /// Board led
    pub led: Output<'static>,

    /// ADC instance
    pub adc: Adc<'static, ADC1<'static>, Blocking>,

    pub adc_pin: AdcPin<GPIO3<'static>, ADC1<'static>>,
}

impl Hardware {
    pub fn init(p: esp_hal::peripherals::Peripherals) -> Hardware {
        let mut adc_config = AdcConfig::new();

        // Attenuation::_11dB allows measuring a wider voltage range (roughly 0 - 3.3V).
        let adc_pin = adc_config.enable_pin(p.GPIO3, Attenuation::_11dB);

        Self {
            led: Output::new(p.GPIO8, Level::Low, OutputConfig::default()),
            adc: Adc::new(p.ADC1, adc_config),
            adc_pin,
        }
    }
}

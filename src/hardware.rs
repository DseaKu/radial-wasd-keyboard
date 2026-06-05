use esp_hal::Blocking;
use esp_hal::analog::adc::{Adc, AdcCalBasic, AdcConfig, AdcPin, Attenuation};
use esp_hal::gpio::Output;
use esp_hal::gpio::{Level, OutputConfig};
use esp_hal::peripherals::{ADC1, GPIO0};

pub struct Hardware {
    pub led: Output<'static>,
    pub adc: Adc<'static, ADC1<'static>, Blocking>,
    pub adc_pin: AdcPin<GPIO0<'static>, ADC1<'static>, AdcCalBasic<ADC1<'static>>>,
}

impl Hardware {
    pub fn init(p: esp_hal::peripherals::Peripherals) -> Hardware {
        let mut adc_config = AdcConfig::new();

        // Enable calibration to remove the hardware zero-offset
        let adc_pin = adc_config.enable_pin_with_cal(p.GPIO0, Attenuation::_11dB);

        // Force the internal pull-up and pull-down resistors off to prevent,
        // otherwise we have a voltage divider
        unsafe {
            let io_mux = &*esp_hal::peripherals::IO_MUX::PTR;
            io_mux
                .gpio(0)
                .modify(|_, w| w.fun_wpu().clear_bit().fun_wpd().clear_bit());
        }

        Self {
            led: Output::new(p.GPIO8, Level::Low, OutputConfig::default()),
            adc: Adc::new(p.ADC1, adc_config),
            adc_pin,
        }
    }
}

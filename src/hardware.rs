use esp_hal::Blocking;
use esp_hal::analog::adc::{Adc, AdcCalBasic, AdcConfig, AdcPin, Attenuation};
use esp_hal::gpio::Output;
use esp_hal::gpio::{Level, OutputConfig};
use esp_hal::peripherals::ADC1;

use esp_hal::peripherals::GPIO2 as JoyStickPinY;
use esp_hal::peripherals::GPIO3 as JoyStickPinX;

pub struct Hardware {
    _status_led: Output<'static>,
    adc1: Adc<'static, ADC1<'static>, Blocking>,
    joy_stick_pin_y: AdcPin<JoyStickPinY<'static>, ADC1<'static>, AdcCalBasic<ADC1<'static>>>,
    joy_stick_pin_x: AdcPin<JoyStickPinX<'static>, ADC1<'static>, AdcCalBasic<ADC1<'static>>>,
}

impl Hardware {
    pub fn init(p: esp_hal::peripherals::Peripherals) -> Hardware {
        let mut adc_config = AdcConfig::new();

        // Enable calibration to remove the hardware zero-offset
        let joy_stick_pin_y = adc_config.enable_pin_with_cal(p.GPIO2, Attenuation::_11dB);
        let joy_stick_pin_x = adc_config.enable_pin_with_cal(p.GPIO3, Attenuation::_11dB);

        Self {
            _status_led: Output::new(p.GPIO8, Level::Low, OutputConfig::default()),
            adc1: Adc::new(p.ADC1, adc_config),
            joy_stick_pin_y,
            joy_stick_pin_x,
        }
    }

    pub fn get_joy_stick_x(&mut self) -> u16 {
        nb::block!(self.adc1.read_oneshot(&mut self.joy_stick_pin_x)).unwrap()
    }
    pub fn get_joy_stick_y(&mut self) -> u16 {
        nb::block!(self.adc1.read_oneshot(&mut self.joy_stick_pin_y)).unwrap()
    }
}

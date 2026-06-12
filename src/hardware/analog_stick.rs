use esp_idf_hal::adc::*;
use esp_idf_hal::gpio::*;

pub struct AnalogStick<'a> {
    adc: AdcDriver<'a, ADCU1>,
    pin_x: AdcChannelDriver<'a, { attenuation::DB_12 }, ADCCH3<ADCU1>>,
    pin_y: AdcChannelDriver<'a, { attenuation::DB_12 }, ADCCH2<ADCU1>>,
}

impl<'a> AnalogStick<'a> {
    pub fn new(adc1: ADC1<'a>, gpio3: Gpio3<'a>, gpio2: Gpio2<'a>) -> anyhow::Result<Self> {
        let config = config::Config::new().calibration(true);
        let adc = AdcDriver::new(adc1, &config)?;

        let pin_x = AdcChannelDriver::new(gpio3)?;
        let pin_y = AdcChannelDriver::new(gpio2)?;

        Ok(Self { adc, pin_x, pin_y })
    }

    pub fn get_x(&mut self) -> u16 {
        self.adc.read(&mut self.pin_x).unwrap_or(0)
    }

    pub fn get_y(&mut self) -> u16 {
        self.adc.read(&mut self.pin_y).unwrap_or(0)
    }
}

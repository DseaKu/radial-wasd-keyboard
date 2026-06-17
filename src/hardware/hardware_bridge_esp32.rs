use crate::types::AdcValue;
use esp_idf_hal::adc::*;
use esp_idf_hal::gpio::ADCPin;

type AdcPeripheral<'a> = ADC1<'a>;
type ADCUnit = ADCU1;
type ChannelX = ADCCH3<ADCUnit>;
type ChannelY = ADCCH2<ADCUnit>;

/// ESP32-specific implementation for reading analog values via ADC.
pub struct Esp32AdcReader<'a> {
    adc: AdcDriver<'a, ADCUnit>,
    pin_x: AdcChannelDriver<'a, { attenuation::DB_12 }, ChannelX>,
    pin_y: AdcChannelDriver<'a, { attenuation::DB_12 }, ChannelY>,
}

impl<'a> Esp32AdcReader<'a> {
    /// Configures the ADC driver and pins with calibration and attenuation.
    pub fn new<PX, PY>(adc: AdcPeripheral<'a>, raw_pin_x: PX, raw_pin_y: PY) -> anyhow::Result<Self>
    where
        PX: ADCPin<AdcChannel = ChannelX> + 'a,
        PY: ADCPin<AdcChannel = ChannelY> + 'a,
    {
        let config = config::Config::new().calibration(true);
        let adc = AdcDriver::new(adc, &config)?;

        let pin_x = AdcChannelDriver::new(raw_pin_x)?;
        let pin_y = AdcChannelDriver::new(raw_pin_y)?;
        Ok(Self { adc, pin_x, pin_y })
    }

    /// Reads the current value from the X-axis pin.
    pub fn poll_x_axis(&mut self) -> AdcValue {
        AdcValue(self.adc.read(&mut self.pin_x).unwrap_or(0))
    }

    /// Reads the current value from the Y-axis pin.
    pub fn poll_y_axis(&mut self) -> AdcValue {
        AdcValue(self.adc.read(&mut self.pin_y).unwrap_or(0))
    }
}

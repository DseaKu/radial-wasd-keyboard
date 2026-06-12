use esp_idf_hal::adc::*;
use esp_idf_hal::gpio::*;

const DEADZONE: u16 = 1000;
const CENTER: u16 = (1 << 12) / 2;

#[derive(Default, PartialEq)]
pub struct Dir {
    n: bool,
    w: bool,
    s: bool,
    e: bool,
}
impl Dir {
    pub fn to_hid_code() {}
}

pub struct AnalogStick<'a> {
    adc: AdcDriver<'a, ADCU1>,
    pin_x: AdcChannelDriver<'a, { attenuation::DB_12 }, ADCCH3<ADCU1>>,
    pin_y: AdcChannelDriver<'a, { attenuation::DB_12 }, ADCCH2<ADCU1>>,
    dir: Dir,
    is_holding_dir: bool,
}

impl<'a> AnalogStick<'a> {
    pub fn new(adc1: ADC1<'a>, gpio3: Gpio3<'a>, gpio2: Gpio2<'a>) -> anyhow::Result<Self> {
        let config = config::Config::new().calibration(true);
        let adc = AdcDriver::new(adc1, &config)?;

        let pin_x = AdcChannelDriver::new(gpio3)?;
        let pin_y = AdcChannelDriver::new(gpio2)?;

        Ok(Self {
            adc,
            pin_x,
            pin_y,
            dir: Dir::default(),
            is_holding_dir: false,
        })
    }

    pub fn update_dir(&mut self) {
        let mut new_dir = Dir::default();

        let y = self.get_y();
        let x = self.get_x();

        if x < CENTER.saturating_sub(DEADZONE) {
            new_dir.w = true;
        } else if x > CENTER.saturating_add(DEADZONE) {
            new_dir.e = true;
        }

        if y < CENTER.saturating_sub(DEADZONE) {
            new_dir.s = true;
        } else if y > CENTER.saturating_add(DEADZONE) {
            new_dir.n = true;
        }

        if new_dir == self.dir {
            self.is_holding_dir = true;
        } else {
            self.dir = new_dir;
            self.is_holding_dir = false;
        }
    }

    pub fn is_holding_dir(&self) -> bool {
        self.is_holding_dir
    }

    pub fn get_x(&mut self) -> u16 {
        self.adc.read(&mut self.pin_x).unwrap_or(0)
    }

    pub fn get_y(&mut self) -> u16 {
        self.adc.read(&mut self.pin_y).unwrap_or(0)
    }
}

use esp_idf_hal::adc::*;
use esp_idf_hal::gpio::*;

const DEADZONE: u16 = 1000;
const CENTER: u16 = (1 << 12) / 2;

#[derive(Default, PartialEq)]
pub enum DirX {
    #[default]
    Center,
    Left,
    Right,
}
impl DirX {
    pub fn to_hid_code(&self) -> u8 {
        match self {
            Self::Center => 0x00,
            Self::Left => 0x50,
            Self::Right => 0x4F,
        }
    }
}

#[derive(Default, PartialEq)]
pub enum DirY {
    #[default]
    Center,
    Up,
    Down,
}
impl DirY {
    pub fn to_hid_code(&self) -> u8 {
        match self {
            Self::Center => 0x00,
            Self::Up => 0x52,
            Self::Down => 0x51,
        }
    }
}

pub struct AnalogStick<'a> {
    adc: AdcDriver<'a, ADCU1>,

    pin_x: AdcChannelDriver<'a, { attenuation::DB_12 }, ADCCH3<ADCU1>>,
    dir_x: DirX,
    is_holding_x: bool,

    pin_y: AdcChannelDriver<'a, { attenuation::DB_12 }, ADCCH2<ADCU1>>,
    dir_y: DirY,
    is_holding_y: bool,
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
            dir_x: DirX::default(),
            is_holding_x: false,

            pin_y,
            dir_y: DirY::default(),
            is_holding_y: false,
        })
    }

    fn update_x_position(&mut self) {
        let mut new_dir = DirX::default();

        let x = self.get_x();

        if x < CENTER.saturating_sub(DEADZONE) {
            new_dir = DirX::Left;
        } else if x > CENTER.saturating_add(DEADZONE) {
            new_dir = DirX::Right;
        }

        if new_dir == self.dir_x {
            self.is_holding_x = true;
        } else {
            self.dir_x = new_dir;
            self.is_holding_x = false;
        }
    }
    pub fn get_x_hid_code(&mut self) -> Option<u8> {
        self.update_x_position();
        if self.is_holding_x {
            return None;
        }
        Some(self.dir_x.to_hid_code())
    }

    fn update_y_position(&mut self) {
        let mut new_dir = DirY::default();

        let y = self.get_y();

        if y < CENTER.saturating_sub(DEADZONE) {
            new_dir = DirY::Down;
        } else if y > CENTER.saturating_add(DEADZONE) {
            new_dir = DirY::Up;
        }

        if new_dir == self.dir_y {
            self.is_holding_y = true;
        } else {
            self.dir_y = new_dir;
            self.is_holding_y = false;
        }
    }

    pub fn get_y_hid_code(&mut self) -> Option<u8> {
        self.update_y_position();
        if self.is_holding_y {
            return None;
        }
        Some(self.dir_y.to_hid_code())
    }
    fn get_x(&mut self) -> u16 {
        self.adc.read(&mut self.pin_x).unwrap_or(0)
    }

    fn get_y(&mut self) -> u16 {
        self.adc.read(&mut self.pin_y).unwrap_or(0)
    }
}

use esp_idf_hal::adc::*;
use esp_idf_hal::gpio::*;

const DEADZONE: u16 = 1000;
const CENTER: u16 = (1 << 12) / 2;

#[derive(Default, PartialEq, Copy, Clone)]
enum Direction {
    #[default]
    Center,
    Negative,
    Positive,
}

struct Axis<'a, C: AdcChannel> {
    pin: AdcChannelDriver<'a, { attenuation::DB_12 }, C>,
    dir: Direction,
    is_holding: bool,
}

impl<'a, C: AdcChannel<AdcUnit = ADCU1>> Axis<'a, C> {
    fn new(pin: impl ADCPin<AdcChannel = C> + 'a) -> anyhow::Result<Self> {
        Ok(Self {
            pin: AdcChannelDriver::new(pin)?,
            dir: Direction::default(),
            is_holding: false,
        })
    }

    fn read_pin(&mut self, adc: &mut AdcDriver<'a, ADCU1>) -> u16 {
        adc.read(&mut self.pin).unwrap_or(0)
    }

    fn update(&mut self, adc: &mut AdcDriver<'a, ADCU1>) {
        let analog_value = self.read_pin(adc);
        let mut new_dir = Direction::Center;

        if analog_value < CENTER.saturating_sub(DEADZONE) {
            new_dir = Direction::Negative;
        } else if analog_value > CENTER.saturating_add(DEADZONE) {
            new_dir = Direction::Positive;
        }

        if new_dir == self.dir {
            self.is_holding = true;
        } else {
            self.dir = new_dir;
            self.is_holding = false;
        }
    }

    fn get_hid_code(
        &mut self,
        adc: &mut AdcDriver<'a, ADCU1>,
        neg_code: u8,
        pos_code: u8,
    ) -> Option<u8> {
        self.update(adc);
        if self.is_holding {
            return None;
        }
        match self.dir {
            Direction::Center => None,
            Direction::Negative => Some(neg_code),
            Direction::Positive => Some(pos_code),
        }
    }
}

pub struct AnalogStick<'a> {
    adc: AdcDriver<'a, ADCU1>,
    axis_x: Axis<'a, ADCCH3<ADCU1>>,
    axis_y: Axis<'a, ADCCH2<ADCU1>>,
}

impl<'a> AnalogStick<'a> {
    pub fn new(adc1: ADC1<'a>, gpio3: Gpio3<'a>, gpio2: Gpio2<'a>) -> anyhow::Result<Self> {
        let config = config::Config::new().calibration(true);
        let adc = AdcDriver::new(adc1, &config)?;

        let axis_x = Axis::new(gpio3)?;
        let axis_y = Axis::new(gpio2)?;

        Ok(Self {
            adc,
            axis_x,
            axis_y,
        })
    }

    pub fn get_x_hid_code(&mut self) -> Option<u8> {
        // Left: 0x50, Right: 0x4F
        self.axis_x.get_hid_code(&mut self.adc, 0x50, 0x4F)
    }

    pub fn get_y_hid_code(&mut self) -> Option<u8> {
        // Up: 0x52, Down: 0x51
        self.axis_y.get_hid_code(&mut self.adc, 0x51, 0x52)
    }
}

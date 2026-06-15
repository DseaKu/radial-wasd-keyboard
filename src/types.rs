#[derive(Copy, Clone, PartialEq, Debug)]
pub struct HidCode(pub u8);
impl HidCode {
    pub fn into_inner(self) -> u8 {
        self.0
    }
}

#[derive(Copy, Clone, PartialEq, PartialOrd, Debug)]
pub struct AdcValue(pub u16);
impl AdcValue {
    pub fn into_inner(self) -> u16 {
        self.0
    }
    pub fn saturating_sub(self, rhs: Self) -> Self {
        AdcValue(self.0.saturating_sub(rhs.0))
    }

    pub fn saturating_add(self, rhs: Self) -> Self {
        AdcValue(self.0.saturating_add(rhs.0))
    }
}

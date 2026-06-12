use esp_idf_hal::peripherals::Peripherals;
use diy_game_pad::hardware::InputPeripherals;
use diy_game_pad::app::App;

fn main() -> anyhow::Result<()> {
    esp_idf_sys::link_patches();
    esp_idf_svc::log::EspLogger::initialize_default();

    let peripherals = Peripherals::take().unwrap();
    let ip = InputPeripherals::new(peripherals)?;
    
    let mut app = App::new(ip);
    
    app.run()
}

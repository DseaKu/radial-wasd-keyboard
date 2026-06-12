use diy_game_pad::app::App;
use diy_game_pad::hardware::InputPeripherals;
use esp_idf_hal::peripherals::Peripherals;

fn main() -> anyhow::Result<()> {
    esp_idf_sys::link_patches();
    esp_idf_svc::log::EspLogger::initialize_default();

    std::panic::set_hook(Box::new(|info| {
        log::error!("APPLICATION PANIC!");
        log::error!("{}", info);
        loop {
            std::thread::sleep(std::time::Duration::from_secs(10));
        }
    }));

    let peripherals = Peripherals::take().unwrap();
    let ip = InputPeripherals::new(peripherals)?;

    let mut app = App::new(ip);

    app.run()
}

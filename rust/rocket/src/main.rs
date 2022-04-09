use rocket::tokio::time::{sleep, Duration};
use rocket::State;
use std::net::{IpAddr, Ipv4Addr};
use std::sync::atomic::AtomicUsize;
use std::sync::atomic::Ordering;

use rocket::config::Config;

#[macro_use]
extern crate rocket;

struct HitCount {
    count: AtomicUsize,
}

#[get("/")]
fn index() -> &'static str {
    "Hello from Rocket 🚀🦀⚙️! Try visiting /count"
}

#[get("/delay/<seconds>")]
async fn delay(seconds: u64) -> String {
    sleep(Duration::from_secs(seconds)).await;
    format!("Waited for {} seconds", seconds)
}

#[get("/count")]
fn count(hit_count: &State<HitCount>) -> String {
    hit_count.count.fetch_add(1, Ordering::Relaxed);

    let current_count = hit_count.count.load(Ordering::Relaxed);
    format!("Number of visits: {}", current_count)
}

#[launch]
fn rocket() -> _ {
    let mut config = Config::release_default();
    config.port = 8080;

    let localhost_v4 = IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0));
    config.address = localhost_v4;

    rocket::custom(config)
        .manage(HitCount {
            count: AtomicUsize::new(0),
        })
        .mount("/", routes![index, delay, count])
}

use warp::Filter;

#[tokio::main]
async fn main() {
    // Create a simple route that responds to GET /
    let hello = warp::path::end()
        .map(|| "Hello, world from Rust!");

    // Get port from environment variable or default to 3000
    let port: u16 = std::env::var("PORT")
        .unwrap_or_else(|_| "3000".to_string())
        .parse()
        .unwrap_or(3000);

    println!("Starting server on port {}", port);

    // Start the server
    warp::serve(hello)
        .run(([0, 0, 0, 0], port))
        .await;
}
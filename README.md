# hello-world-rust

A super-simple Rust server which can be built and deployed as a container, or just natively on your chosen system.

# Build and Run Locally

```bash
cargo build --release
PORT=3456 ./target/release/hello-world-rust
```

# Containerise and Push

This project can also be containerised and pushed to a remote container registry with the `build_and_push.sh` script. The script uses Podman to build images for both `arm64` and `amd64` architectures.

```bash
# If on macOS, you'll first need to start the Podman VM
# podman machine init
# podman machins start

./build_and_push <IMAGE_NAME> <DOCKERHUB_USERNAME>
```

# Envionment Variables

By default, the server will try and bind to port `3000` to listen for connections, but you can override this with the environment variable `PORT`.
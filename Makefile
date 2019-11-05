TARGET = wasm32-unknown-unknown
LIB = lib_name.wasm

all: target/$(TARGET)/release/$(LIB) wasm-bindgen

target/$(TARGET)/release/$(LIB):
	cargo build --target $(TARGET) --release
.PHONY: target/$(TARGET)/release/$(LIB)

wasm-bindgen:
	wasm-bindgen target/$(TARGET)/release/$(LIB) --out-dir build --target nodejs
.PHONY: wasm-bindgen

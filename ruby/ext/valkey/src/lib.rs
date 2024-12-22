use magnus::{function, prelude::*, Error, Ruby};

#[magnus::wrap(class = "Valkey")]
struct Valkey {
}

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let class = ruby.define_class("Valkey", ruby.class_object())?;
    Ok(())
}

use magnus::{function, prelude::*, Error, Integer, Ruby};

fn hello(subject: String) -> String {
    format!("Hello from Rust, {subject}!")
}

fn pow(subject: Integer) -> Integer {
    let subject_as_i64: i64 = subject.to_i64().unwrap();
    Integer::from_i64(subject_as_i64 * subject_as_i64)
}

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let module = ruby.define_module("ValkeyGlide")?;
    module.define_singleton_method("hello", function!(hello, 1))?;
    module.define_singleton_method("pow", function!(pow, 1))?;
    Ok(())
}

use magnus::{function, method, prelude::*, Error, Ruby};

#[magnus::wrap(class = "Valkey")]
struct Valkey {
}

impl Valkey {
    fn new() -> Self {
        Self { }
    }

    fn test(&self) -> isize {
        2
    }
}

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let class = ruby.define_class("Valkey", ruby.class_object())?;
    class.define_singleton_method("new", function!(Valkey::new, 0))?;

    class.define_method("test", method!(Valkey::test, 0))?;
    Ok(())
}

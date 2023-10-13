require "big"

require "./cbor/**"

module CBOR
  VERSION = "0.1.0"

  # Represents CBOR types
  alias Type = Nil |
               Bool |
               String |
               Bytes |
               Array(Any) |
               Hash(Any, Any) |
               Int8 |
               UInt8 |
               Int16 |
               UInt16 |
               Int32 |
               UInt32 |
               Int64 |
               UInt64 |
               Int128 |
               Float32 |
               Float64

  struct Any
    getter raw : Type

    def initialize(@raw)
    end

    def ==(value : Type)
      @raw == value
    end

    private macro def_types(types)
      {% for name, type in types %}
        def as_{{name}} : {{type}}
          @raw.as {{type}}
        end

        def as_{{name}}? : {{type}}?
          @raw.as? {{type}}
        end
      {% end %}
    end

    def_types({
      nil:  Nil,
      bool: Bool,
      s:    String,
      b:    Bytes,
      a:    Array,
      h:    Hash,
      i:    Int32,
      f:    Float64,
      i8:   Int8,
      i16:  Int16,
      i32:  Int32,
      i64:  Int64,
      u8:   UInt8,
      u16:  UInt16,
      u32:  UInt32,
      u64:  UInt64,
      i128: Int128,
      f32:  Float32,
      f64:  Float64,
    })
  end
end

private macro def_equals
  def ==(other : CBOR::Any)
    other == self
  end
end

struct Nil
  def_equals
end

struct Bool
  def_equals
end

struct Int
  def_equals
end

struct Float
  def_equals
end

class String
  def_equals
end

struct Bytes
  def_equals
end

class Array
  def_equals
end

class Hash
  def_equals
end

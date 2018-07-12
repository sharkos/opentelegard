#
# POC Code to run the NANO editor via FFI from Jruby
#
require 'ffi'
module JExec
    extend FFI::Library
    ffi_lib("c")
    attach_function :execvp, [:string, :pointer], :int
end
  
 strptrs = []
  strptrs << FFI::MemoryPointer.from_string("/bin/rnano")
  strptrs << FFI::MemoryPointer.from_string("/tmp/foo")
  strptrs << nil

  # Now load all the pointers into a native memory block
  argv = FFI::MemoryPointer.new(:pointer, strptrs.length)
  strptrs.each_with_index do |p, i|
   argv[i].put_pointer(0,  p)
  end

  Exec.execvp("/bin/rnano", argv)


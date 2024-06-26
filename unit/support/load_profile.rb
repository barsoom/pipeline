if ENV["LOAD_PROFILE"]
  SLOW = ENV["SLOW"]&.to_f || 0.05

  puts "profiling enabled."
  module Kernel
    class ProfiledMethod
      def initialize(method, overridden_method, *opts)
        @method = method
        @overridden_method = overridden_method
        @opts = opts
      end

      def run
        result = measure_time { invoke_method }
        print_slow_time(result) if result.slow?
        result.return_value
      end

      private

      class InvocationResult < Struct.new(:elapsed_time, :return_value)
        def slow?
          elapsed_time > SLOW
        end
      end

      def invoke_method
        send(overridden_method, *opts)
      end

      def measure_time
        start_time = Time.now
        ret = yield
        InvocationResult.new(Time.now - start_time, ret)
      end

      def print_slow_time(result)
        puts "Slow #{method}: #{opts.first} #{(result.elapsed_time * 1000.0).to_i} ms"
      end

      attr_reader :method, :overridden_method, :opts
    end

    [ :require, :load ].each do |method|
      alias_method "old_#{method}", method

      define_method(method) do |*opts|
        ProfiledMethod.new(method, "old_#{method}", *opts).run
      end
    end
  end
end

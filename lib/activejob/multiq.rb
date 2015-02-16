require "active_support/inflector"
require "activejob/multiq/version"

module ActiveJob
  module Multiq
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      @multiq_queue_adapter = nil

      # ActiveJob delegates to this method when enqueueing a job
      def queue_adapter
        case @multiq_queue_adapter
        when nil then ActiveJob::Base.queue_adapter
        when Proc then @multiq_queue_adapter.call
        else @multiq_queue_adapter
        end
      end

      def queue_with(adapter_or_name = nil, options = {}, &block)
        if adapter_or_name.nil? && !block_given?
          raise ArgumentError, "Must provide adapter or block"
        end

        return if options[:unless] && options[:unless].call
        return if options[:if] && !options[:if].call

        if block_given?
          @multiq_queue_adapter = block
          return
        end

        @multiq_queue_adapter = convert_adapter_name(adapter_or_name)

        if @multiq_queue_adapter.nil?
          raise ArgumentError, "#{adapter_or_name} is not a valid adapter"
        end
      end

      private

      def convert_adapter_name(adapter_or_name)
        case adapter_or_name
        when :test
          ActiveJob::QueueAdapters::TestAdapter.new
        when Symbol, String
          "ActiveJob::QueueAdapters::#{adapter_or_name.to_s.camelize}Adapter".constantize
        else
          adapter_or_name if adapter_or_name.respond_to?(:enqueue)
        end
      end
    end
  end
end

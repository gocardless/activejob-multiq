require 'spec_helper'

RSpec.describe ActiveJob::Multiq do
  subject(:job) do
    Thread.current[:adapter_or_name] = adapter_or_name

    Class.new(ActiveJob::Base) do
      include ActiveJob::Multiq

      queue_with(Thread.current[:adapter_or_name])
    end
  end

  context 'when not calling queue_with' do
    subject(:job) do
      Class.new(ActiveJob::Base) do
        include ActiveJob::Multiq
      end
    end

    its(:queue_adapter) { is_expected.to eq(ActiveJob::QueueAdapters::InlineAdapter) }
  end

  context 'with :test' do
    let(:adapter_or_name) { :test }
    its(:queue_adapter) { is_expected.to be_a(ActiveJob::QueueAdapters::TestAdapter) }
  end

  context 'with a custom class' do
    let(:adapter_or_name) do
      Class.new do
        def self.enqueue
          'lol queues, who needs them?'
        end
      end
    end

    its(:queue_adapter) { is_expected.to eq(adapter_or_name) }
  end

  context 'with an object which does not respond to enqueue' do
    let(:adapter_or_name) do
      class MyAdapter
      end
    end

    specify { expect { job }.to raise_error(ArgumentError) }
  end

  context 'with nil' do
    let(:adapter_or_name) { nil }
    specify { expect { job }.to raise_error(ArgumentError) }
  end

  context 'with :que' do
    let(:adapter_or_name) { :que }
    its(:queue_adapter) { is_expected.to eq(ActiveJob::QueueAdapters::QueAdapter)}

    context 'with an unless proc' do
      context 'that returns true' do
        subject(:job) do
          Class.new(ActiveJob::Base) do
            include ActiveJob::Multiq

            queue_with :que, unless: -> { true }
          end
        end

        its(:queue_adapter) { is_expected.to eq(ActiveJob::Base.queue_adapter) }
      end

      context 'that returns false' do
        subject(:job) do
          Class.new(ActiveJob::Base) do
            include ActiveJob::Multiq

            queue_with :que, unless: -> { false }
          end
        end

        its(:queue_adapter) { is_expected.to eq(ActiveJob::QueueAdapters::QueAdapter) }
      end
    end

    context 'with an if proc' do
      context 'that returns true' do
        subject(:job) do
          Class.new(ActiveJob::Base) do
            include ActiveJob::Multiq

            queue_with :que, if: -> { true }
          end
        end

        its(:queue_adapter) { is_expected.to eq(ActiveJob::QueueAdapters::QueAdapter) }
      end

      context 'that returns false' do
        subject(:job) do
          Class.new(ActiveJob::Base) do
            include ActiveJob::Multiq

            queue_with :que, if: -> { false }
          end
        end

        its(:queue_adapter) { is_expected.to eq(ActiveJob::Base.queue_adapter) }
      end
    end
  end
end
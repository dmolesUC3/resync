require 'spec_helper'

module Resync
  RSpec.shared_examples ListBase do

    # ------------------------------------------------------
    # "Virtual" fixture methods

    def resource_list
      if defined? resource_list_override
        resource_list_override
      else
        [Resource.new(uri: 'http://example.org/'), Resource.new(uri: 'http://example.com/')]
      end
    end

    def new_list(**args)
      if defined? new_list_override
        new_list_override(**args)
      else
        described_class.new(**args)
      end
    end

    # ------------------------------------------------------
    # Tests

    describe '#new' do
      describe 'resources' do
        it 'accepts a list of resources' do
          resources = resource_list
          list = new_list(resources: resources)
          expect(list.resources).to eq(resources)
        end

        it 'defaults to an empty list if no resources are specified' do
          list = new_list
          expect(list.resources).to eq([])
        end
      end

      describe 'metadata' do
        it 'accepts metadata' do
          metadata = Metadata.new(capability: described_class::CAPABILITY)
          list = new_list(metadata: metadata)
          expect(list.metadata).to eq(metadata)
        end

        it 'defaults (otherwise empty) metadata with capability CAPABILITY if no metadata specified' do
          list = new_list
          metadata = list.metadata
          expect(metadata.capability).to eq(described_class::CAPABILITY)
        end

        it 'fails if metadata does not have capability CAPABILITY' do
          expect { new_list(metadata: Metadata.new) }.to raise_error(ArgumentError)
          expect { new_list(metadata: Metadata.new(capability: "not_#{described_class::CAPABILITY}")) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end

require 'spec_helper'
describe 'filebeats' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('filebeats') }
  end
end

require_relative 'podspec_helper'

Pod::Spec.new do |s|
  configure_putio_sdk_spec(s, name: 'PutioSDK', module_name: 'PutioSDK')
end

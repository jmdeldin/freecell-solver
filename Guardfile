guard :rspec do
  watch(%r{^lib/free_cell/(.+)\.rb$}) { |m| "spec/free_cell/#{m[1]}_spec.rb" }
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { "spec" }
end

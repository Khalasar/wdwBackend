group :red_green_refactor, halt_on_fail: true do
  guard :minitest, spring: "spring testunit", bundler: false do
    watch(%r|^test/test_helper\.rb|) { "test" }
    watch(%r|^test/.+_test\.rb|)
    watch(%r|^app/(.+)\.rb|)                               { |m| "test/#{m[1]}_test.rb" }
    watch(%r|^app/controllers/application_controller\.rb|) { "test/controllers" }
  end

  guard :rubocop do
    # run rubocop on modified file
    watch(%r{\Aapp/.+\.rb\z})
    watch(%r{\Atest/.+\.rb\z})
  end
end

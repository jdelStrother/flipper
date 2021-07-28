require 'bundler/setup'
require 'flipper'

basic_39_actor = Flipper::Actor.new(1, {
  "plan" => "basic",
  "age" => 39,
})
premium_40_actor = Flipper::Actor.new(2, {
  "plan" => "premium",
  "age" => 40,
})
no_plan_actor = Flipper::Actor.new(3)

p({
  basic_39: Flipper.enabled?(:redesign, basic_39_actor),
  premium_40: Flipper.enabled?(:redesign, premium_40_actor),
  no_plan: Flipper.enabled?(:redesign, no_plan_actor),
})

puts "Enabling for basic"
Flipper.enable_comparison :redesign, "plan", "eq", "basic"
p({
  basic_39: Flipper.enabled?(:redesign, basic_39_actor),
  premium_40: Flipper.enabled?(:redesign, premium_40_actor),
  no_plan: Flipper.enabled?(:redesign, no_plan_actor),
})

Flipper.disable_comparison :redesign, "plan", "eq", "basic"
puts "Disabling for basic"
p({
  basic_39: Flipper.enabled?(:redesign, basic_39_actor),
  premium_40: Flipper.enabled?(:redesign, premium_40_actor),
  no_plan: Flipper.enabled?(:redesign, no_plan_actor),
})

puts "Enabling for >= 40"
Flipper.enable_comparison :redesign, "age", "gte", 40
p({
  basic_39: Flipper.enabled?(:redesign, basic_39_actor),
  premium_40: Flipper.enabled?(:redesign, premium_40_actor),
  no_plan: Flipper.enabled?(:redesign, no_plan_actor),
})

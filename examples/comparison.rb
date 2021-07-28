require 'bundler/setup'
require 'flipper'

basic_actor = Flipper::Actor.new(1, {
  "plan" => "basic",
})
premium_actor = Flipper::Actor.new(2, {
  "plan" => "premium",
})
no_plan_actor = Flipper::Actor.new(3)

p basic: Flipper.enabled?(:redesign, basic_actor)
p premium: Flipper.enabled?(:redesign, premium_actor)
p no_plan: Flipper.enabled?(:redesign, no_plan_actor)

puts "Enabling for basic"
Flipper.enable_comparison :redesign, "plan", "eq", "basic"
# Or... Flipper.enable :redesign, Flipper::Types::Comparison.new(["plan", "eq", "basic"])
# Or... Flipper.enable_comparison :redesign, ["plan", "eq", "basic"]

p basic: Flipper.enabled?(:redesign, basic_actor)
p premium: Flipper.enabled?(:redesign, premium_actor)
p no_plan: Flipper.enabled?(:redesign, no_plan_actor)

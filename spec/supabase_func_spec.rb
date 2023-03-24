# frozen_string_literal: true

RSpec.describe SupabaseFunc do
  it "has a version number" do
    expect(SupabaseFunc::VERSION).not_to be nil
  end
end

RSpec.describe SupabaseFunc::Error do
  it "descends StandardError" do
    expect(SupabaseFunc::Error.ancestors).to include(StandardError)
  end
end

# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stock_inquiry/version"

Gem::Specification.new do |spec|
  spec.name          = "stock_inquiry"
  spec.version       = StockInquiry::VERSION
  spec.authors       = ["Julee117"]
  spec.email         = ["juliannne@gmail.com"]

  spec.summary       = "Stock inquiry"
  spec.description   = "Provides information on stocks"
  spec.homepage      = "http://www.github.com/julee117"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "nokogiri"
end

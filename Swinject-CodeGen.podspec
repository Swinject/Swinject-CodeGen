Pod::Spec.new do |s|
  s.name             = "Swinject-CodeGen"
  s.version          = "2.0.0"
  s.summary          = "Generates extensions on the container class, to make use of swinject less error prone and more typesafe."

  s.description      = <<-DESC
                       Generates extensions on the container class, to make use of swinject less error prone and more typesafe.

                       These extensions contain functions to match the specific resolve, using one resolve function per registered class, instead of the generic calls.
                       DESC

  s.homepage         = "https://github.com/Swinject/Swinject-CodeGeneration"
  s.license          = 'MIT'
  s.author           = 'Swinject Contributors'
  s.source           = { :git => "https://github.com/Swinject/Swinject-CodeGeneration.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.preserve_paths = ['erb', 'source', 'bin']

  s.dependency "Swinject" '~> 2.0.0'

end

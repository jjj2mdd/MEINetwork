Pod::Spec.new do |s|
  s.name             = 'MEINetwork'
  s.version          = '0.1.0'
  s.summary          = 'MEINetwork是移动中台项目iOS端实现网络功能的基础组件。'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://10.25.81.246/maochaolong041/MEINetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'maochaolong041' => 'maochaolong041@pingan.com.cn' }
  s.source           = { :git => 'http://10.25.81.246/maochaolong041/MEINetwork.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.subspec 'Core' do |c|
    c.source_files = 'MEINetwork/Classes/Core/*'
    c.dependency 'Moya'
  end

end

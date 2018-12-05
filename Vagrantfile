Vagrant.configure("2") do |config|
  config.vm.box = "Win2016"
  config.vm.box_url = "windows2016r2-virtualbox.box"
  config.vm.communicator = "winrm"
  config.vm.network "forwarded_port", guest: 3389, host: 33389, id: "rdp", auto_correct: true
  #config.vm.provider "virtualbox" do |vb| 
  #  vb.gui = true
  #  vb.memory = "4096"
  #end  
end
